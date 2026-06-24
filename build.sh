#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
tectonic -X compile main.tex
echo "[OK] main.pdf $(du -h main.pdf | cut -f1)"
