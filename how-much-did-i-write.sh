#!/bin/bash

res=$(find ./_* | xargs cat 2>/dev/null | wc -l)

echo "You have wrote $res lines in total!"
