#!/bin/bash
set -euo pipefail
source common.sh

find "${OUT_PATH}" -name 'index.*md' -exec ./fix_tex.py {} {} \;
