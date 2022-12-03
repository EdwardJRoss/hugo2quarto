# hugo2quarto
Scripts to convert [Skeptric](https://github.com/EdwardJRoss/skeptric) from a [Hugo](https://gohugo.io/) blog using the [Casper 3 template](https://github.com/jonathanjanssens/hugo-casper3) to [Quarto](https://quarto.org/).

# Installation

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

# Checklist

Different blog posts use different features; it's worth manually checking that some of them work correctly:

- [] Large code blocks: `dvi-by-example`
- [] Large tables: `schema-jobposting`
- [] Mermaid diagrams: `value-of-gold`
- [] TeX equations: `symmetry-lie-alebras-qde-2`
- [] Jupyter notebooks: `calculate-centroid-on-sphere`
- [] Rmd: `plotting-bayesian-parameters-tidyverse`