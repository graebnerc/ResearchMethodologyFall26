#!/usr/bin/env bash
# Build lab10.zip: the R project students download for lab 10.
#
#   lab10/
#     lab10.Rproj
#     lab10_worksheet.qmd            <- _student_template.qmd
#     data/cps-earnings-mra-2014.csv <- content/material/data/ (the lecture's data)
#
# The worksheet and the data are copied from their single sources, so re-run
# this script after any change to either:
#     ./make-lab10-zip.sh
set -euo pipefail
cd "$(dirname "$0")"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
proj="$tmp/lab10"
mkdir -p "$proj/data"

cp _student_template.qmd "$proj/lab10_worksheet.qmd"
cp ../data/cps-earnings-mra-2014.csv "$proj/data/"
cat > "$proj/lab10.Rproj" <<'EOF'
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: No

EnableCodeIndexing: Yes
Encoding: UTF-8

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
EOF

rm -f lab10.zip
(cd "$tmp" && zip -q -r -X "$OLDPWD/lab10.zip" lab10)
echo "wrote lab10.zip:"
unzip -l lab10.zip
