#!/bin/bash

echo "You have wrote $(find _* -name *.md | xargs cat 2>/dev/null | wc -l) lines in total!"
