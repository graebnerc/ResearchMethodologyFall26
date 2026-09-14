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
# automatically when _site/ is missing, on the first run, and whenever ANY
# non-.qmd file changed — slide PDFs, images, data files, css/, _quarto.yml.
# Quarto copies static resources into _site/ only during a full project render,
# so rendering single pages would leave a newly added PDF out of the upload.
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

typeset -a touched changed other extra
if (( ! FULL )); then
  if [[ ! -f $STAMP ]]; then
    FULL=1; warn "No $STAMP yet (first run) — doing a full render."
  elif [[ ! -d _site ]]; then
    FULL=1; warn "_site/ is missing — doing a full render."
  else
    # Everything that changed since the last publish, ignoring build output and
    # tooling scratch. Anything that is NOT a .qmd — a slide PDF, an image, a
    # data file, the theme, _quarto.yml — is a static resource or affects every
    # page, and Quarto only copies those into _site/ during a FULL project
    # render. Rendering single pages would silently leave them out.
    touched=( ${(f)"$(find . \
        \( -path './_site' -o -path './_freeze' -o -path './.quarto' \
           -o -path './.git' -o -path './renv' -o -path './.Rproj.user' \
           -o -path './INBOX' \) -prune -o \
        -type f -newer $STAMP \
        ! -name '.DS_Store' ! -name '.Rhistory' ! -name '.RData' \
        ! -name '*.command' -print 2>/dev/null)"} )
    touched=( ${touched:#} )

    changed=( ${(M)touched:#*.qmd} )
    other=(  ${touched:#*.qmd} )

    if (( ${#other} )); then
      FULL=1
      warn "${#other} non-.qmd file(s) changed — these are only copied into _site/"
      warn "by a full render, so doing one. First few:"
      for f in ${other[1,5]}; do print -r -- "      ${f#./}"; done
      (( ${#other} > 5 )) && print -r -- "      … and $(( ${#other} - 5 )) more"
    fi
  fi
fi

if (( ! FULL )); then
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
