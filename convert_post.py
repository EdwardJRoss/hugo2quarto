#!/usr/bin/env python
import argparse
import sys

import frontmatter

META_MAP = {
    "title": "title",
    "date": "date",
    "feature_image": "image",
    "tags": "categories",
    "draft": "draft",
}


def post_hugo2quarto(post: frontmatter.Post) -> frontmatter.Post:
    post_meta = {META_MAP.get(k, k): v for k, v in dict(post).items()}
    return frontmatter.Post(
        post.content, handler=frontmatter.YAMLHandler(), **post_meta
    )


def export_post(input_file, output_file) -> None:
    in_post = frontmatter.load(input_file)
    out_post = post_hugo2quarto(in_post)
    out_text = frontmatter.dumps(out_post)
    output_file.write(out_text)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    args = parser.parse_args()
    export_post(input_file=args.infile, output_file=args.outfile)
