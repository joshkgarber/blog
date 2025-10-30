from logconfig import logger
from document import markdown_to_html_node
import os
from pathlib import Path


def extract_title(markdown):
    first_line = markdown.split("\n\n", 1)[0].strip()
    if first_line[:2] != "# ":
        raise ValueError("title missing or invalid")
    return first_line[2:]


def generate_page(from_path, template_path, dest_path, basepath):
    with open(from_path) as f:
        markdown = f.read()
    with open(template_path) as f:
        template = f.read()
    content = markdown_to_html_node(markdown).to_html()
    title = extract_title(markdown)
    template = template.replace("{{ Title }}", title)
    template = template.replace("{{ Content }}", content)
    template = template.replace('href="/', f'href="{basepath}')
    template = template.replace('src="/', f'src="{basepath}')
    logger.info(f"Writing {dest_path}")
    path = os.path.dirname(dest_path)
    if not os.path.exists(path):
        os.makedirs(path)
    with open(dest_path, "w") as f:
        f.write(template)


def generate_pages_recursive(dir_path_content, template_path, dest_dir_path, basepath):
    files = os.listdir(dir_path_content)
    for file in files:
        if Path(file).suffix not in [".swp", ".draft"]:
            from_path = os.path.join(dir_path_content, file)
            dest_path = os.path.join(dest_dir_path, file)
            if os.path.isfile(from_path):
                dest_path = Path(dest_path).with_suffix(".html")
                generate_page(from_path, template_path, dest_path, basepath)
                continue
            generate_pages_recursive(from_path, template_path, dest_path, basepath)


