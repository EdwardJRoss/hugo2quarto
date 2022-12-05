# hugo2quarto
Scripts to convert [Skeptric](https://github.com/EdwardJRoss/skeptric) from a [Hugo](https://gohugo.io/) blog using the [Casper 3 template](https://github.com/jonathanjanssens/hugo-casper3) to [Quarto](https://quarto.org/).

# Installation

Use conda (or [mamba](https://github.com/mamba-org/mamba), which is much faster) to set up a virtual environment and install the Python requirements:

```sh
conda env create -f environment.yml
conda activate hugo2quarto
python -m pip install -r requirements.txt
```

# Running

There are a series of scripts to transform the code in `./scripts`:

- `00_get_input.sh` - git clone the input blog
- `01_convert.sh` - create empty quarto blog in output, convert each of the posts frontmatter from TOML to YAML, and save each post in output directory
- `02_fix_R_eval_code_chunks.sh` - fix issues with some posts that erroneously have evaluated R blocks
- `03_fix_sicp_urls.sh` - fix issues with some broken URLs (which causes fatal errors in quarto < 1.2)
- `04_fix_ipynb_url.sh` - fix ipynb URLs being converted to HTML by Quarto (by directing them somewhere else)
- `05_fix_mermaid.sh` - fix mermaid diagrams generated with Hugo
- `06_fix_tex.sh` - remove peculiar conventions of mmark format (double $ escaping TeX)

The input (`./data/`) and output (`./output/`) directories are defined in `./common.sh`, and the actual code to convert post frontmatter from Hugo (TOML) to Quarto (YAML) is `./convert_post.py`.

An overview of the approach can be seen in `./notebooks/convert.ipynb`

# Approach

The Hugo repository has a folder structure that renders like:

```
    content/post/blah.mmark  --> blah/index.html
    static/images/blah_image.jpg --> images/blah_image.jpg
```

For Quarto we want to move things around to

```
   blah/index.md --> blah/index.html
   images/blah_image.jpg --> images/blah_image.jpg
```

This means all output URLs and content will remain unchanged, so it won't break any existing links.

To do this we just need to copy all the static asset folders across, and for each post we need to create a directory of the same name and copy the post to `index.md` in that folder.

## Frontmatter Mapping

Hugo uses TOML frontmatter, and Quarto uses YAML, so we will have to convert it and map the tags appropriately.

```
title -> title
date --> date
draft --> draft
feature_image --> image
tags --> categories
```

## Notebooks and Rmd

...

# Issues

RMarkdown rendering in constant-models.md

```
  ```{R}
```

* URLs
* LaTeX display
* Keeping ipynb files

```
project:
  type: website
  resources:
    - "*.ipynb"
```

https://nbviewer.org/


# Checklist

Different blog posts use different features; it's worth manually checking that some of them work correctly:

- [] Large code blocks: `dvi-by-example`
- [] Large tables: `schema-jobposting`
- [] Mermaid diagrams: `value-of-gold`
- [] TeX equations: `symmetry-lie-alebras-qde-2`
- [] Jupyter notebooks: `calculate-centroid-on-sphere`
- [] Rmd: `plotting-bayesian-parameters-tidyverse`
