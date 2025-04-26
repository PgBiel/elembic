#!/bin/sh
temp="$(mktemp)"
ANSI_RED=$'\e[31m'
ANSI_GREEN=$'\e[32m'
ANSI_BLUE=$'\e[34m'
ANSI_END=$'\e[0m'
status=0
cd "$(dirname "$0")/.."
for doc in test/integration/*.typ
do
  echo "Compiling ${ANSI_BLUE}$doc${ANSI_END}..."
  timings="${temp}"
  if typst compile "$doc" --root . --timings "${timings}" --format pdf - >/dev/null
  then
    echo "Compiled ${ANSI_BLUE}$doc${ANSI_END} in ${ANSI_GREEN}$(jq '.[-1]?.ts / 1000' <${timings}) ms${ANSI_END}"
  else
    echo "Failed to compile ${ANSI_RED}$doc${ANSI_END}"
    status=1
  fi
done
exit $status
