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

An overview of the approach can be seen in `./notebooks/convert.ipynb`.

The approach to fix TeX is in `./notebooks/mmark2pandoc_maths.ipynb` corresponding to the script `./fix_tex.py`.

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

Notebooks have already been converted to markdown, and so we don't bother to regenerate them.

We copy across Rmd files separately (and not their generated HTML).

# Issues

The fix scripts help deal with issues that came up when running this.

## Failure to evaluate

In `constant-models.md` an R codeblock has curly brackets in the fenced code block definition (`{R}`), which Hugo ignores, but Quarto thinks is an executable code block.
Quarto then complains this isn't a `qmd` file and exits with an error.

This is fixed with `02_fix_R_eval_code_chunks.sh`.

## Broken URLs

There are a few URLs that, mistakenly, have `%_` in them which isn't valid.
Quarto <1.2 exits with error on this (1.2 emits a warning).
The script `03_fix_sicp_urls.sh` fixes these examples (and the fact that the URLs have actually changed since it was written).

## Ipynb URLs

Quarto automatically changes all references of `ipynb` to `html`, which breaks my links to the raw `ipynb`.
To get around this `04_fix_ipynb_url.sh` changes the links to an [nbviewer](https://nbviewer.org/) pointing to the corresponding file in Github.

## Mermaid diagrams

Through some hacks and Javascript I had a few posts with mermaid diagrams.
Quarto provides this out of the box for `qmd` documents and `05_fix_mermaid.sh` converts them to the quarto format.

## Equation rendering

Hugo mmark uses `$$...$$` for maths blocks, but Pandoc uses `$...$` for inline maths blocks.
We need to convert these, and escape existing `$` signs (unless they are in a code block).
This is all done in `06_fix_tex.sh` using `./fix_tex.py`.

## Backslashes

Sometimes we had an unescaped backslash in paragraph text which broke rendering (like `\special` in `dvi-by-example`).
All these cases were found in `notebooks/mmark2pandoc_backslash.ipynb` and manually corrected.

It's also worth noting that notebooks converted to posts with mathematics used `\\[` and `\\]` for maths blocks, and `\\(` and `\\)` for inline maths (and had extra backslash escapes inside).
Because there were so few I corrected them manually.

## Internal links

The post `calculate-centroid-on-sphere` had som internal links like `(#Coordinate-transormations)` to link to the section `Coordinate transformations`, which had to be lower cased to work.

# Checklist

Different blog posts use different features; it's worth manually checking that some of them work correctly on Quarto 1.3.34

- [x] Large code blocks: `dvi-by-example`: Ok after fixes
- [x] Large tables: `schema-jobposting`: Table overflows to right on desktop full screen, but readable
- [x] Mermaid diagrams: `value-of-gold`
- [x] TeX equations: `symmetry-lie-alebras-qde-2`
- [x] Jupyter notebooks: `calculate-centroid-on-sphere`: Fixed internal links
- [x] Rmd: `plotting-bayesian-parameters-tidyverse`
- [x] TeX tables `calculate-logs`
- [x] Previous Checks: `casper-2-to-3`
- [x] LaTeX and TeX symbol: `latex-multiple-equations`
- [] Shows drafts: `remote-jupyter-console`: Yes it does, but they are not indexed
