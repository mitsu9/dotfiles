#!/bin/sh
# herdr tab_bar_right entry: Claude subscription usage for both accounts.
# Reads the cache written by ~/.config/herdr/claude-usage.sh (the statusLine command).
#
# The tab bar is a single row and clips whatever does not fit beside the tabs,
# so this shows the 5-hour window only: a gauge, the percentage consumed, and
# the time the window resets. Set SEVEN_DAY=1 to append the weekly window too.
set -u

cache_dir="$HOME/.cache/claude-usage"
cells=6
seven_day=${SEVEN_DAY:-}
now=$(date +%s)
out=""

for pair in "Work:main" "Private:private"; do
  label=${pair%%:*}
  file="$cache_dir/${pair#*:}.json"
  [ -f "$file" ] || continue
  line=$(jq -r --arg label "$label" --arg seven_day "$seven_day" \
             --argjson cells "$cells" --argjson now "$now" '
    # Filled and empty cells differ in shape, not shading, so the boundary and
    # the ends of the gauge stay readable at terminal size.
    def bar(pct):
      ([([(pct * $cells / 100 | round), $cells] | min), 0] | max) as $f
      | (if $f > 0 then "▰" * $f else "" end)
      + (if $f < $cells then "▱" * ($cells - $f) else "" end);

    # within a day: clock time. further out: weekday (2 columns, cheaper than a date).
    def at(t): if t - $now < 86400 then (t | strflocaltime("%H:%M"))
               else (t | strflocaltime("%a") | sub("Mon";"月") | sub("Tue";"火")
                     | sub("Wed";"水") | sub("Thu";"木") | sub("Fri";"金")
                     | sub("Sat";"土") | sub("Sun";"日")) end;

    def live(w; name): w as $w
      | if $w == null or ($w.resets_at // 0) < $now then empty
        else $w + {name: name} end;

    def render: .name + " " + bar(.used_percentage)
                + " " + (.used_percentage | floor | tostring) + "% ↻" + at(.resets_at);

    [ live(.rate_limits.five_hour; "5h") ]
    + (if $seven_day == "" then [] else [live(.rate_limits.seven_day; "7d")] end)
    | [$label] + map(render) | join(" ")
  ' "$file" 2>/dev/null) || continue
  [ -n "$line" ] || continue
  if [ -n "$out" ]; then out="$out   $line"; else out="$line"; fi
done

printf '%s' "$out"
