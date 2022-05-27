#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: $0 <input.md> <output.pdf>"
	exit
fi

echo "Printing ..."

pandoc $1 -o $2 \
--from markdown+yaml_metadata_block+raw_html \
--template eisvogel \
--table-of-contents \
--toc-depth 6 \
--number-sections \
--top-level-division=chapter \
--highlight-style tango


echo "Done! View the report at $2"
