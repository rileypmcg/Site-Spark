#!/usr/bin/env bash
#
# new-mockup.sh — publish a finished mockup as a live, sendable link.
#
#   ./scripts/new-mockup.sh {slug} {path-to-mockup.html}
#
# Copies the mockup to mockups/{slug}/index.html, adds a noindex robots tag,
# commits, pushes to the branch GitHub Pages serves, and prints the live URL.
#
# mockups/ is for cold-lead previews. portfolio/ is for won clients — this
# script never touches it.

set -euo pipefail

PAGES_BRANCH="${PAGES_BRANCH:-main}"

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

usage() {
  cat >&2 <<'EOF'
usage: scripts/new-mockup.sh {slug} {path-to-mockup.html}

  slug   lead identifier, lowercase letters/numbers/dashes (e.g. bossman-landscaping)
  path   the finished mockup .html file to publish

example:
  ./scripts/new-mockup.sh bossman-landscaping bossman-landscaping-mockup.html
EOF
  exit 1
}

[ $# -eq 2 ] || usage

slug="$1"
src="$2"

# Reject anything that could escape mockups/ or break a URL.
case "$slug" in
  *[!a-z0-9-]* | -* | *- | '') die "invalid slug '$slug' (use lowercase letters, numbers and dashes)" ;;
esac

[ -f "$src" ] || die "no such file: $src"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || die "not inside a git repository"
cd "$repo_root"

remote_url="$(git remote get-url origin 2>/dev/null)" || die "no 'origin' remote configured"

# github.com/OWNER/REPO(.git) from either https:// or git@ form.
slug_path="${remote_url#*github.com}"
slug_path="${slug_path#[:/]}"
slug_path="${slug_path%.git}"
owner="${slug_path%%/*}"
repo="${slug_path##*/}"
[ -n "$owner" ] && [ -n "$repo" ] && [ "$owner" != "$slug_path" ] \
  || die "could not parse owner/repo from origin: $remote_url"

dest_dir="mockups/$slug"
dest="$dest_dir/index.html"

mkdir -p "$dest_dir"
cp "$src" "$dest"

# Strip HTML comments. Source mockups carry build notes — pitch angles, "confirm
# real numbers with client", owner phone numbers — and the published copy is a
# URL we hand to that very lead, who can read it with View Source. The notes stay
# in the source file; they just never ship.
awk '
  {
    rest = $0; out = ""; had = 0
    while (1) {
      if (incom) {
        p = index(rest, "-->")
        if (p == 0) { rest = ""; break }
        rest = substr(rest, p + 3); incom = 0; had = 1
      } else {
        p = index(rest, "<!--")
        if (p == 0) { out = out rest; break }
        out = out substr(rest, 1, p - 1)
        rest = substr(rest, p + 4); incom = 1; had = 1
      }
    }
    # Drop lines that held only a comment; keep genuinely blank source lines.
    if (had && out ~ /^[ \t]*$/) next
    print out
  }
' "$dest" > "$dest.tmp" && mv "$dest.tmp" "$dest"

# Same treatment for /* */ comments inside <style> — they carry notes like
# "PLACEHOLDER photo tiles, replace with real job photos". Scoped to <style> on
# purpose: script bodies hold no build notes, and // would eat the // in URLs.
awk '
  {
    orig = $0
    if (instyle || incom) {
      rest = orig; out = ""; had = 0
      while (1) {
        if (incom) {
          p = index(rest, "*/")
          if (p == 0) { rest = ""; break }
          rest = substr(rest, p + 2); incom = 0; had = 1
        } else {
          p = index(rest, "/*")
          if (p == 0) { out = out rest; break }
          out = out substr(rest, 1, p - 1)
          rest = substr(rest, p + 2); incom = 1; had = 1
        }
      }
      if (tolower(orig) ~ /<\/style>/) instyle = 0
      if (had && out ~ /^[ \t]*$/) next
      print out
      next
    }
    if (tolower(orig) ~ /<style[ >]/) instyle = 1
    if (tolower(orig) ~ /<\/style>/) instyle = 0
    print orig
  }
' "$dest" > "$dest.tmp" && mv "$dest.tmp" "$dest"

# Add <meta name="robots" content="noindex"> unless a robots meta is already
# there — these are private previews for one lead, not pages we want indexed.
if grep -qi '<meta[^>]*name=["'"'"']\?robots' "$dest"; then
  printf 'robots meta already present — left as-is\n'
else
  awk '
    !done && tolower($0) ~ /<head[ >]/ {
      print
      print "<meta name=\"robots\" content=\"noindex\" />"
      done = 1
      next
    }
    { print }
    END { if (!done) exit 3 }
  ' "$dest" > "$dest.tmp" || die "no <head> found in $src — cannot insert noindex"
  mv "$dest.tmp" "$dest"
  printf 'inserted noindex robots meta\n'
fi

url="https://$owner.github.io/$repo/mockups/$slug/"

current_branch="$(git rev-parse --abbrev-ref HEAD)"
[ "$current_branch" = "$PAGES_BRANCH" ] \
  || die "on branch '$current_branch' but Pages serves '$PAGES_BRANCH' — switch branches first"

git add "$dest"

if git diff --cached --quiet -- "$dest"; then
  printf 'no changes to commit — %s is already published\n' "$dest"
else
  git commit -q -m "Add live mockup preview for $slug"
  git push -q origin "$PAGES_BRANCH"
  printf 'pushed to %s\n' "$PAGES_BRANCH"
fi

cat <<EOF

  live link (allow ~1 min for Pages to build):
  $url

EOF
