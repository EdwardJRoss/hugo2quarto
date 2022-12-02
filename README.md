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
   blah/blah_image.jpg --> blah/blah_image.jpg
```

This means all URL to images (and other assets such as notebooks) will change, but all webpages will remain the same.

For each post:

1. Create a directory of the same name in output folder
2. Find all internal asset links (images, notebooks, but not other posts)
3. Copy all internal assets to output location
4. Update all links to point to new location
5. Write out to `index.md` in output folder

## Frontmatter Mapping

TOML -> YAML

```
title -> title
date --> date
draft --> draft
feature_image --> image
tags --> categories
```

# Notebooks and Rmd

...