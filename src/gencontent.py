from logconfig import logger
from document import markdown_to_html_node
import os
from pathlib import Path


def extract_title(markdown):
    first_line = markdown.split("\n\n", 1)[0].strip()
    if first_line[:2] != "# ":
        raise ValueError("title missing or invalid")
    return first_line[2:]


def build_breadcrumbs(from_path, basepath):
    file_path = Path(from_path)
    parts = file_path.parts[1:-1]
    parts = (basepath,) + parts
    breadcrumbs = []
    for i, part in enumerate(parts):
        bc_path = f"{'/'.join(parts[0:i+1])}"
        if basepath == "/" and i > 0:
            bc_path = bc_path[1:]
        bc = f"<a href=\"{bc_path}\">{part}</a>"
        breadcrumbs.append(bc)
    return " / ".join(breadcrumbs)


def generate_page(from_path, template_path, dest_path, basepath):
    logger.info(f"Generating page from {from_path} to {dest_path} using {template_path}")
    logger.info("Getting markdown content")
    with open(from_path) as f:
        markdown = f.read()
    logger.info("Getting html template")
    with open(template_path) as f:
        template = f.read()
    logger.info("Converting markdown to html")
    content = markdown_to_html_node(markdown).to_html()
    logger.info("Getting page title")
    title = extract_title(markdown)
    breadcrumbs = build_breadcrumbs(from_path, basepath)
    logger.info("Inserting title, breadcrumbs, and page content into template")
    template = template.replace("{{ Title }}", title)
    template = template.replace("{{ Breadcrumbs }}", breadcrumbs)
    template = template.replace("{{ Content }}", content)
    template = template.replace('href="/', f'href="{basepath}')
    template = template.replace('src="/', f'src="{basepath}')
    logger.info(f"Writing {dest_path} to disk")
    path = os.path.dirname(dest_path)
    if not os.path.exists(path):
        os.makedirs(path)
    with open(dest_path, "w") as f:
        f.write(template)


def generate_pages_recursive(dir_path_content, template_path, dest_dir_path, basepath):
    files = os.listdir(dir_path_content)
    for file in files:
        if Path(file).suffix != ".swp":
            from_path = os.path.join(dir_path_content, file)
            dest_path = os.path.join(dest_dir_path, file)
            if os.path.isfile(from_path):
                dest_path = Path(dest_path).with_suffix(".html")
                generate_page(from_path, template_path, dest_path, basepath)
                continue
            generate_pages_recursive(from_path, template_path, dest_path, basepath)


