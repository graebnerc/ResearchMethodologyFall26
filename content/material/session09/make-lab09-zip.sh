#!/usr/bin/env bash
# Build lab09.zip: the R project students download for lab 9.
#
#   lab09/
#     lab09.Rproj
#     lab09_worksheet.qmd            <- _student_template.qmd
#     chart_template.R               <- chart_template.R
#     data/gdplifexp2007.csv         <- data/ in this folder
#
# All files are copied from their single sources, so re-run this script
# after any change to one of them:
#     ./make-lab09-zip.sh
set -euo pipefail
cd "$(dirname "$0")"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
proj="$tmp/lab09"
mkdir -p "$proj/data"

cp _student_template.qmd "$proj/lab09_worksheet.qmd"
cp chart_template.R "$proj/chart_template.R"
cp data/*.csv "$proj/data/"
cat > "$proj/lab09.Rproj" <<'EOF'
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: No

EnableCodeIndexing: Yes
Encoding: UTF-8

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
EOF

rm -f lab09.zip
(cd "$tmp" && zip -q -r -X "$OLDPWD/lab09.zip" lab09)
echo "wrote lab09.zip:"
unzip -l lab09.zip
