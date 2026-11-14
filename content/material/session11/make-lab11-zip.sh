#!/usr/bin/env bash
# Build lab11.zip: the R project students download for lab 11.
#
#   lab11/
#     lab11.Rproj
#     lab11_worksheet.qmd            <- _student_template.qmd
#     data/*.csv                     <- data/ in this folder
#
# The worksheet and the data are copied from their single sources, so re-run
# this script after any change to either:
#     ./make-lab11-zip.sh
set -euo pipefail
cd "$(dirname "$0")"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
proj="$tmp/lab11"
mkdir -p "$proj/data"

cp _student_template.qmd "$proj/lab11_worksheet.qmd"
cp data/*.csv "$proj/data/"
cat > "$proj/lab11.Rproj" <<'EOF'
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: No

EnableCodeIndexing: Yes
Encoding: UTF-8

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
EOF

rm -f lab11.zip
(cd "$tmp" && zip -q -r -X "$OLDPWD/lab11.zip" lab11)
echo "wrote lab11.zip:"
unzip -l lab11.zip
