#!/bin/bash
TMPL=$(find ./_scaffolds | grep .md)

sed -e "s/{{title}}/$1/" -e "s/{{date}} {{time}}/$(date '+%Y-%m-%d %H:%M:%S')/" $TMPL
