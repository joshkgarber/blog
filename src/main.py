import os
import shutil
from logconfig import logger
from copystatic import copy_files_recursive
from gencontent import generate_pages_recursive
import sys


dir_path_static = "./static"
default_dir_path_public = "./public"
dir_path_content = "./content"
template_path = "./template.html"
default_basepath = "/"


def main():
    dir_path_public = default_dir_path_public
    basepath = default_basepath
    if len(sys.argv) > 1:
        basepath = sys.argv[1]
    if len(sys.argv) > 2:
        dir_path_public = sys.argv[2]
    if len (sys.argv) > 3:
        logger.error("Usage: main.py [basepath] [dir_path_public]")
        exit(1)
    logger.info("Clearing public")
    if not os.path.exists(dir_path_static):
        raise ValueError("Source folder does not exist")
    if os.path.exists(dir_path_public):
        shutil.rmtree(dir_path_public)
    os.mkdir(dir_path_public)
    logger.info("Copying static content from to public")
    copy_files_recursive(dir_path_static, dir_path_public)
    logger.info("Generating content in public")
    generate_pages_recursive(dir_path_content, template_path, dir_path_public, basepath)


if __name__ == "__main__":
    main()
