import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s\t%(levelname)s\t%(message)s',
    datefmt='%F_%T',
)
logger = logging.getLogger()
