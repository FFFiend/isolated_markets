# isolated_markets

# Description
This repository contains all the files and source code for the paper titled "Deeper investigation into the Isolated Markets of Greece".

# File Structure
The file structure is as follows:
```inputs``` contains the llm chat history, as well as raw data.
```other``` contains the SSRP report and reproduction code.
```outputs``` contains the actual paper.

# Replication Code

TBD

# Data Access

TBD

# LLM Usage Statement

There was extensive LLM usage throughout the entire reproduction and paper writing process, which can be seen in ```inputs/llm/usage.txt```

# NOTE ON REPRODUCIBILITY (working with main_islands.dta)
As per the original paper's author's README file, the main_islands.dta file was the main file used to 
produce all regression tables and figures. This file is too large to upload to GitHub however (around 170MB, GitHub has a limit of 100MB) and so unfortunately, one would have to manually download this file to begin reproducing.

Here are the steps to follow:
- Navigate to https://www.aeaweb.org/articles?id=10.1257/app.20200863 and click on Replication Package
- Click on download project, sign in and unzip the folder locally.
You should now have access and can begin working with the ```main_islands.dta``` file.