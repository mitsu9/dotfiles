#!/bin/sh
# Claude Code statusLine command.
#  1. forwards the payload to orca's statusline integration (it owns this slot too)
#  2. caches this account's rate-limit windows for ~/.config/herdr/status.sh
#  3. prints the status line Claude Code renders
set -u

input=$(cat)

# Keep orca's integration working: it reads the same payload on stdin and prints nothing.
orca="$HOME/.orca/agent-hooks/claude-statusline.sh"
if [ -r "$orca" ] && [ -x "$orca" ]; then
  printf '%s' "$input" | /bin/sh "$orca" >/dev/null 2>&1 || :
fi

# Which account is this session logged in as? The private profile is launched through
# ~/dotfiles/home/claude/bin/claude-private, which exports CLAUDE_CONFIG_DIR.
case "${CLAUDE_CONFIG_DIR:-}" in
  */profiles/private) profile=private ;;
  *)                  profile=main ;;
esac

cache_dir="$HOME/.cache/claude-usage"
mkdir -p "$cache_dir" 2>/dev/null || :

# rate_limits is absent until the session's first API response, so only overwrite
# the cache when this session actually has a reading.
printf '%s' "$input" | jq -c --argjson now "$(date +%s)" \
  'select(.rate_limits != null) | {updated_at: $now, rate_limits: .rate_limits}' \
  >"$cache_dir/.$profile.tmp" 2>/dev/null \
  && [ -s "$cache_dir/.$profile.tmp" ] \
  && mv -f "$cache_dir/.$profile.tmp" "$cache_dir/$profile.json"
rm -f "$cache_dir/.$profile.tmp" 2>/dev/null || :

# Drop the two jq lines below to go back to an empty status line in Claude Code.
printf '%s' "$input" | jq -r '
  def pct: if . == null then "-" else ((. | floor | tostring) + "%") end;
  [ .model.display_name,
    (.workspace.current_dir | sub("^" + env.HOME; "~")),
    "ctx " + (.context_window.used_percentage | pct),
    "5h "  + (.rate_limits.five_hour.used_percentage | pct),
    "7d "  + (.rate_limits.seven_day.used_percentage | pct)
  ] | join(" | ")'
