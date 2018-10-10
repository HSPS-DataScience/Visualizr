import itertools as it
import re


class Parser:
    """class to parse R scripts into standalone Rmd files

    - Any line in R script which starts with "## " is considered a comment
        block and not an R code chunk in the Rmd
    - Requires Python 3.6.5 >=
    """
    def __init__(self, r_script_path="", new_filename="new.Rmd"):
        self.delimiter = "## "
        self.r_script_path = r_script_path
        self.new_filename = new_filename

        self.rmd_content = self.parse_script()

    def write_to_new_rmd(self):
        """write to a new rmd file from an r script  """
        with open(self.new_filename, 'w') as f:
            for line in self.rmd_content:
                f.write(line)

    def parse_script(self):
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
        with open(self.r_script_path, "r") as f:
            new_rmd = []

            # divide file text into groups of code or comments
            for key, group in it.groupby(f, lambda line: line.startswith(self.delimiter) or line == '\n'):
                if key: # comment block
                    comment_chunk = self.create_comment_chunk(list(group))
                    new_rmd.append(comment_chunk)
                if not key: # code block
                    r_chunk = self.create_rchunk(list(group))
                    new_rmd.append(r_chunk)

            return new_rmd

    def parse_group(self, group):
        """parse quotation marks out of strings to prep for final Rmd document """
        code = ""
        for text in group:
            code += text.strip('\"')
        return code

    def create_comment_chunk(self, group):
        """remove delimiter from comments for final Rmd document """
        comments = self.parse_group(group)
        return re.sub(self.delimiter, "", comments)

    def create_rchunk(self, group):
        """surround code with triple tick marks for Rmd R chunks """
        code = self.parse_group(group)

        header = "```{r}"
        return f"\n{header}\n{code}\n```\n\n"


    # parser = Parser(r_script_path="R/visualize_functions.R", new_filename="../test.Rmd")
