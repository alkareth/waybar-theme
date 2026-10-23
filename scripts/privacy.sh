#!/usr/bin/env bash
# ~/.config/waybar/scripts/privacy.sh
# Indicateur vie privée pour Hyprland (le module "privacy" est spécifique Sway).
# Détection PipeWire :
#   - micro actif  : un flux Stream/Input/Audio dont l'état du param AUDIO
#                    est "running" (pw-dump -> info.params[].state == "running")
#   - lecture/sortie active : le sink par défaut a au moins un lien "output_*"
#                    vers un stream (via pw-link / wpctl) — approx. simple :
#                    un Stream/Output/Audio en état "running".
# Sortie JSON {text, tooltip, class} ; class "active" -> coloré par le CSS
# (#custom-privacy.active). Pour réintégrer dans la barre :
#   1. ajouter "custom/privacy" dans group/status-icons (config.jsonc)
#   2. ajouter le bloc :
#      "custom/privacy": { "exec": "~/.config/waybar/scripts/privacy.sh",
#                          "return-type": "json", "interval": 2 }
#
# Dépendances : pipewire (pw-dump), python3.

set -u

detect() {
  command -v pw-dump >/dev/null 2>&1 || return 0
  pw-dump 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
mic = play = False
for n in d:
    p = n.get("info", {}).get("props", {})
    mc = p.get("media.class", "")
    if mc not in ("Stream/Input/Audio", "Stream/Output/Audio"):
        continue
    running = any(par.get("state") == "running"
                  for par in n.get("info", {}).get("params", [])
                  if isinstance(par, dict))
    if mc == "Stream/Input/Audio" and running:
        mic = True
    elif mc == "Stream/Output/Audio" and running:
        play = True
print(f"{int(mic)} {int(play)}")
' 2>/dev/null
}

read -r mic play <<<"$(detect)"
mic=${mic:-0}; play=${play:-0}

cls="inactive"
parts=()
[ "$mic" = "1" ] && { parts+=("🎙 micro"); cls="active"; }
[ "$play" = "1" ] && parts+=("🔊 lecture")

if [ ${#parts[@]} -gt 0 ]; then
  IFS=' • '; tooltip="${parts[*]}"
else
  tooltip="Aucune source active"
fi

if [ "$cls" = "active" ]; then
  icon="\uf03d"    # mic (NF) si micro sinon volume-high
  [ "$mic" != "1" ] && icon="\uf028"
else
  icon="\uf3ed"    # shield-outline NF
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$icon" "$tooltip" "$cls"
