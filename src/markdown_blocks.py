from enum import Enum
import re


def markdown_to_blocks(markdown):
    code_block_pattern = r"(```.*?```)"
    code_block_split = re.split(code_block_pattern, markdown)
    code_block_pattern = r"^```.*?```$"
    blocks = []
    for split in code_block_split:
        if re.fullmatch(code_block_pattern, split, re.S):
            blocks.append(split)
        else:
            blocks.extend(split.split("\n\n"))
    blocks = list(map(lambda x: x.strip(), blocks))
    blocks = [block for block in blocks if block]
    return blocks


class BlockType(Enum):
    PARAGRAPH = "paragraph"
    HEADING = "heading"
    CODE = "code"
    QUOTE = "quote"
    UL = "ul"
    OL = "ol"
    TABLE = "table"


def block_to_blocktype(block):
    heading_pattern = r"^#{1,6} .+"
    if re.fullmatch(heading_pattern, block):
        return BlockType.HEADING
    code_pattern = r"^```.*?```$"
    if re.fullmatch(code_pattern, block, re.S):
        return BlockType.CODE
    quote_pattern = r"^>.*?$"
    lines = block.split("\n")
    quote_fail = [line for line in lines if not re.fullmatch(quote_pattern, line)]
    if not quote_fail:
        return BlockType.QUOTE
    ul_pattern = r"^- .*?$"
    ul_fail = [line for line in lines if not re.fullmatch(ul_pattern, line)]
    if not ul_fail:
        return BlockType.UL
    is_ol = check_is_ol(lines)
    if is_ol:
        return BlockType.OL
    is_table = check_is_table(lines)
    if is_table:
        return BlockType.TABLE
    return BlockType.PARAGRAPH


def check_is_ol(lines):
    ol_pattern = r"^[1-9]\d*\. .*?$"
    counter = 1
    for line in lines:
        if re.fullmatch(ol_pattern, line):
            num = int(line.split(". ", 1)[0])
            if num != counter:
                return False
            counter += 1
            continue
        return False
    return True


def check_is_table(lines):
    # Check pattern for the header row
    header_pattern = r"^(\| .+ )+\|$"
    valid_table_header = re.fullmatch(header_pattern, lines[0])
    if not valid_table_header:
        return False
    column_count_pattern = r"\| .+ "
    # Save the number of columns
    column_count = len(re.findall(column_count_pattern, lines[0]))
    # Check pattern for the separator row
    separator_pattern = r"^(\| -+ )+\|$"
    valid_table_separator = re.fullmatch(separator_pattern, lines[1])
    if not valid_table_separator:
        return False
    separator_column_count = len(re.findall(column_count_pattern, lines[1]))
    if column_count != separator_column_count:
        return False
    # Check patter for remaining rows
    row_pattern = header_pattern
    for line in lines[2:]:
        valid_table_row = re.fullmatch(row_pattern, line)
        if not valid_table_row:
            return False
        row_column_count = len(re.findall(column_count_pattern, line))
        if column_count != row_column_count:
            return False
    # Valid table
    return True
