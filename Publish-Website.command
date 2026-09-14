#!/bin/zsh
# ---------------------------------------------------------------------------
# Publish-Website.command — Research Methodology (Fall 2026)
#
# Double-click in Finder (or run in a terminal) to render the pages that
# changed since the last successful publish and push the site to Netlify.
#
#   ./Publish-Website.command           incremental: render only changed .qmd
#   ./Publish-Website.command --full    force a full `quarto render`
#
# The Netlify target comes from _publish.yml (site
# researchmethodology-fall26.netlify.app); the access token is the one Quarto
# already has stored, so no login is required.
#
# "Changed" means: newer than the marker file .quarto-last-publish, which this
# script touches after every successful publish. A full render is forced
# automatically when the site structure or theme changed (_quarto.yml, css/,
# assets/, references/, any _metadata.yml), when _site/ is missing, or on the
# first run.
# ---------------------------------------------------------------------------

emulate -L zsh
set -euo pipefail

# Finder does not start a login shell, so make sure the usual tool paths exist.
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

PROJECT="${0:A:h}"
cd "$PROJECT"

STAMP=".quarto-last-publish"

bold=$'\e[1m'; green=$'\e[32m'; yellow=$'\e[33m'; red=$'\e[31m'; reset=$'\e[0m'

info()  { print -r -- "${bold}▶${reset} $*" }
ok()    { print -r -- "${green}✔${reset} $*" }
warn()  { print -r -- "${yellow}!${reset} $*" }
die()   { print -r -- "${red}✖ $*${reset}"; pause_and_exit 1 }

pause_and_exit() {
  local code=${1:-0}
  if [[ -t 0 ]]; then
    print -r -- ""
    print -rn -- "Press return to close this window… "
    read -r _ || true
  fi
  exit $code
}
trap 'die "Aborted — see the messages above."' ERR

# --- sanity checks ----------------------------------------------------------
(( $+commands[quarto] )) || die "quarto not found in PATH. Install it or adjust PATH at the top of this script."
[[ -f _quarto.yml  ]] || die "No _quarto.yml in $PROJECT — this script must sit in the site's root folder."
[[ -f _publish.yml ]] || die "No _publish.yml in $PROJECT — run 'quarto publish netlify' once by hand to set the target."

print -r -- ""
print -r -- "${bold}Publishing: $(basename "$PROJECT")${reset}"
print -r -- "Target:     $(grep -o 'https://[^ ]*' _publish.yml | head -1)"
print -r -- ""

# --- decide full vs. incremental -------------------------------------------
FULL=0
[[ "${1:-}" == "--full" || "${1:-}" == "-f" ]] && FULL=1

typeset -a changed extra structural
if (( ! FULL )); then
  if [[ ! -f $STAMP ]]; then
    FULL=1; warn "No $STAMP yet (first run) — doing a full render."
  elif [[ ! -d _site ]]; then
    FULL=1; warn "_site/ is missing — doing a full render."
  else
    # Structural/theme changes affect every page, so they force a full render.
    typeset -a struct_roots
    for p in _quarto.yml css assets references .Rprofile renv.lock; do
      [[ -e $p ]] && struct_roots+=("$p")
    done
    structural=( ${(f)"$(find $struct_roots -newer $STAMP -type f 2>/dev/null)"} )
    structural+=( ${(f)"$(find ./content -name '_metadata.yml' -newer $STAMP -type f 2>/dev/null)"} )
    structural=( ${structural:#} )
    if (( ${#structural} )); then
      FULL=1
      warn "Structure/theme changed (${#structural} file(s), e.g. ${structural[1]#./}) — doing a full render."
    fi
  fi
fi

if (( ! FULL )); then
  changed=( ${(f)"$(find . -name '*.qmd' -type f -newer $STAMP \
      -not -path './_site/*'      -not -path './_freeze/*' \
      -not -path './.quarto/*'    -not -path './renv/*' \
      -not -path './INBOX/*'      -not -path './.Rproj.user/*' 2>/dev/null)"} )
  changed=( ${changed:#} )

  # Listing pages do not notice that one of their entries changed, so rebuild
  # them alongside the entry.
  for f in $changed; do
    case $f in
      ./content/tutorials/*) [[ -f ./content/tutorials.qmd ]] && extra+=(./content/tutorials.qmd) ;;
      ./content/exercises/*) [[ -f ./content/exercises.qmd ]] && extra+=(./content/exercises.qmd) ;;
    esac
  done
  typeset -U changed
  changed=( $changed $extra )
  typeset -U changed
fi

# --- render -----------------------------------------------------------------
if (( FULL )); then
  info "Full render of the whole site (freeze: auto — unchanged R code is not re-executed)…"
  quarto render
  ok "Site rendered."
elif (( ${#changed} == 0 )); then
  warn "Nothing changed since the last publish — re-uploading the existing _site/ unchanged."
else
  info "Rendering ${#changed} changed page(s):"
  for f in $changed; do print -r -- "    ${f#./}"; done
  print -r -- ""
  for f in $changed; do
    info "quarto render ${f#./}"
    quarto render "$f"
  done
  ok "Changed pages rendered."
fi

# --- publish ----------------------------------------------------------------
print -r -- ""
info "Uploading to Netlify…"
quarto publish netlify --no-render --no-prompt --no-browser
touch "$STAMP"

print -r -- ""
ok "Published. The marker $STAMP was updated, so the next run starts from here."
if (( ! FULL )); then
  print -r -- "  (Ran incrementally. If something looks stale on the live site,"
  print -r -- "   run it again as:  ./Publish-Website.command --full)"
fi

pause_and_exit 0
