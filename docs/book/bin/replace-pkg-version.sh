#!/bin/sh

PKG_VERSION=$(cat "$(dirname -- "$0")/../../../typst.toml" | grep version | sed -e 's/version = "\|"//g')

# .[1] => take just the second item of the input array, which has '.sections'
# Next, for each section, if it isn't a Chapter (e.g. PartTitle) then it is kept as is through '.'
# Oterwise, we replace "@preview/elembic:X.X.X" with "@preview/elembic:VERSION" in both the top-level
# chapter's as well as any sub-chapter's contents.
jq .[1] | jq '.sections[] |= (if .Chapter? == null then . else (.Chapter.content, .Chapter.sub_items[].Chapter.content) |= gsub("@preview/elembic:X.X.X"; "@local/elembic:'$PKG_VERSION'") end)'
