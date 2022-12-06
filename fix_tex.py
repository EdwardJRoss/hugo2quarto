#!/usr/bin/env python
"""Convert mmark TeX to Pandoc TeX"""
import argparse
from dataclasses import dataclass
from enum import Enum, auto
import logging
import re
import sys
from typing import Optional

logger = logging.getLogger()


class Mode(Enum):
    DEFAULT = auto()
    INLINE_CODE = auto()
    BLOCK_CODE = auto()
    INLINE_MATH = auto()
    BLOCK_MATH = auto()
    INDENTED_CODE = auto()


@dataclass
class Action:
    input_mode: Mode
    match_re: str
    output_mode: Mode
    output: Optional[str] = None

    def __post_init__(self):
        self.pattern = re.compile(self.match_re)

    def match(self, s: str, idx: int = 0) -> Optional[str]:
        match = self.pattern.match(s, idx)
        if match:
            match_str = match.group(0)
            len_match_str = len(match_str)
            assert len_match_str > 0
            return {"output": self.output or match_str, "size": len_match_str}


ACTIONS = (
    Action(Mode.DEFAULT, "\n```", Mode.BLOCK_CODE),
    Action(Mode.DEFAULT, "`", Mode.INLINE_CODE),
    Action(Mode.DEFAULT, "\n\$\$ *", Mode.BLOCK_MATH, "\n$$"),
    Action(Mode.DEFAULT, "\$\$ *", Mode.INLINE_MATH, "$"),
    Action(Mode.DEFAULT, "\n    ", Mode.INDENTED_CODE),
    Action(Mode.DEFAULT, "\$", Mode.DEFAULT, "\$"),
    Action(Mode.BLOCK_CODE, "```", Mode.DEFAULT),
    Action(Mode.INLINE_CODE, "`", Mode.DEFAULT),
    Action(Mode.INLINE_MATH, " *\$\$", Mode.DEFAULT, "$"),
    Action(Mode.BLOCK_MATH, " *\$\$", Mode.DEFAULT, "$$"),
    Action(Mode.INDENTED_CODE, "\n {,3}\S", Mode.DEFAULT),
)


def parse(s):
    mode = Mode.DEFAULT
    idx = 0
    output = []

    while idx < len(s):
        logger.debug(
            "Mode: %s, Last output: %s, Next chars: %s"
            % (mode, output[-1:], s[idx : idx + 5].replace("\n", "\\n"))
        )
        last_idx = idx
        for action in ACTIONS:
            if action.input_mode != mode:
                continue
            match = action.match(s, idx)
            if match:
                logger.debug("Match: %s" % action)
                mode = action.output_mode
                idx += match["size"]
                output += match["output"]
                break
        else:
            output += s[idx]
            idx += 1

        assert idx > last_idx, "Infinite loop"

    return "".join(output)

def main(input_file, output_file):
    data = input_file.read()
    output = parse(data)
    if output_file != sys.stdout:
        output_file.seek(0)
        output_file.truncate()
    output_file.write(output)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("r+"), default=sys.stdout
    )
    args = parser.parse_args()
    main(input_file=args.infile, output_file=args.outfile)
