#!/bin/bash
set -euo pipefail
source common.sh

git clone --branch hugo-eol --depth 1 https://github.com/EdwardJRoss/skeptric.git "${IN_PATH}"
