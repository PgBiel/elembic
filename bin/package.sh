#!/bin/sh
if [ $# -lt 1 ]; then
    echo "Please specify the path to your fork of 'https://github.com/typst/packages'."
    exit 1
fi

version=${ELEMBIC_VERSION:-"$(grep "version = " typst.toml | sed -e 's/^version = "\|"$//g')"}
orig_dir="$(realpath "$(dirname "$0")/..")"
dest_dir="$1/packages/preview/elembic/${version}"
mkdir -p "${dest_dir}"
IFS=$' '
for file in LICENSE LICENSE-MIT LICENSE-APACHE README.md src typst.toml
do
    cp -r "${orig_dir}/${file}" -t "${dest_dir}"
done

echo "Copied files to ${dest_dir}"
