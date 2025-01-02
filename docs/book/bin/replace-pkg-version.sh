#!/bin/sh

PKG_VERSION=$(cat "$(dirname -- "$0")/../../../typst.toml" | grep version | sed -e 's/version = "\|"//g')
jq .[1] | jq '.sections[].Chapter.content |= gsub("@preview/elemmic:X.X.X"; "@preview/elemmic:'$PKG_VERSION'")' | jq '.sections[].Chapter.sub_items[].Chapter.content |= gsub("@preview/elemmic:X.X.X"; "@preview/elemmic:'$PKG_VERSION'")'
