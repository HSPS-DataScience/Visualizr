import itertools as it 
import pickle 
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
    
    """ 
    with open(filename, "r") as f:
        new_rmd = []  

        for key, group in it.groupby(f, lambda line: line.startswith(DELIMITER) or line == '\n'): 
            if not key:
                group = list(group)
                r_chunk = create_rchunk(group)
                new_rmd.append(r_chunk)
            if key: 
                group = list(group)
                comment_chunk = create_comment_chunk(group) 
                new_rmd.append(comment_chunk)

        return new_rmd

def parse_group(group):
    code = "" 
    for text in group: 
        code += text.strip('\"') 
    return code 

def create_comment_chunk(group): 
    comments = parse_group(group) 
    return re.sub(DELIMITER, "", comments) 

def create_rchunk(group):
    code = parse_group(group) 

    header = "```{r}"
    return f"\n{header}\n{code}\n```\n\n"


build_rmd_from_script(r_script_path="R/visualize_functions.R",rmd_filename="test.Rmd") 