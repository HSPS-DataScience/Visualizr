import itertools as it 
import re 


# global delimiter(s) for portions of R script to be left as Markdown and not R chunks 
DELIMITER = "## "

def build_rmd_from_script(r_script_path="", rmd_filename="new.Rmd"): 
    """write to a new rmd file from an r script  

    """
    rmd_content = parse_script(r_script_path) 
    
    with open(rmd_filename, 'w') as f: 
        for line in rmd_content: 
            f.write(line)

def parse_script(filename=""):
    """parse r script based off of delimiter 
    
    There are two groups in the parsed R script we are looking for: 
        - Comment Blocks
            + any line which starts with the set delimiter (## )
            + any blank line (\n in a string format) 
        - Code Blocks
            + any line which is not a comment block is assumed to be a line of code 

    Operations are used on groups to create R chunks or normal comment blocks 
        in the final Rmd file. All lines which start with "## " are considered
        comments which will not be included in R chunks. 
    """ 
    with open(filename, "r") as f:
        new_rmd = []  

        # divide file text into groups of code or comments 
        for key, group in it.groupby(f, lambda line: line.startswith(DELIMITER) or line == '\n'): 
            if key: # comment block 
                comment_chunk = create_comment_chunk(list(group)) 
                new_rmd.append(comment_chunk)
            if not key: # code block 
                r_chunk = create_rchunk(list(group))
                new_rmd.append(r_chunk)

        return new_rmd

def parse_group(group):
    """parse quotation marks out of strings to prep for final Rmd document """
    code = "" 
    for text in group: 
        code += text.strip('\"') 
    return code 

def create_comment_chunk(group): 
    """remove delimiter from comments for final Rmd document """
    comments = parse_group(group) 
    return re.sub(DELIMITER, "", comments) 

def create_rchunk(group):
    """surround code with triple tick marks for Rmd R chunks """
    code = parse_group(group) 

    header = "```{r}"
    return f"\n{header}\n{code}\n```\n\n"


# build_rmd_from_script(r_script_path="R/visualize_functions.R",rmd_filename="test.Rmd") 