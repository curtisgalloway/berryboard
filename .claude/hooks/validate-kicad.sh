#!/bin/bash
# Run before git commit — abort if any staged KiCad file fails to parse.
cmd=$(jq -r '.tool_input.command // ""')
echo "$cmd" | grep -q 'git commit' || exit 0

fail() { printf '{"continue":false,"stopReason":"%s"}' "$1"; exit 1; }

for f in $(git diff --cached --name-only | grep '\.kicad_pcb$'); do
  kicad-cli pcb export svg --layers F.Cu --output /tmp/ "$f" 2>&1 | grep -q 'Done\.' \
    || fail "KiCad PCB parse error in $f — fix before committing"
done

for f in $(git diff --cached --name-only | grep '\.kicad_sch$'); do
  kicad-cli sch export svg --output /tmp/ "$f" 2>&1 | grep -q 'Done\.' \
    || fail "KiCad schematic parse error in $f — fix before committing"
done
