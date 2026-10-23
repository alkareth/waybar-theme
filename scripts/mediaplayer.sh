#!/usr/bin/env bash
# ~/.config/waybar/scripts/mediaplayer.sh
# Module média "custom" basé sur playerctl, sortie JSON {text, tooltip, class}.
# Prépare le ricing avancé (drop-down) de la phase 2.

set -u

if ! command -v playerctl >/dev/null 2>&1; then
  printf '{"text":"","class":"inactive"}\n'; exit 0
fi

status=$(playerctl status 2>/dev/null) || status=""

if [ -z "$status" ]; then
  printf '{"text":"","class":"inactive"}\n'
  exit 0
fi

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
player=$(playerctl -p "$(playerctl -l | head -1)" 2>/dev/null && true)

# tronque le titre pour la barre
max=40
if [ "${#title}" -gt "$max" ]; then
  short="${title:0:$((max-1))}…"
else
  short="$title"
fi

case "$status" in
  Playing)  icon=""; cls="playing" ;;   # play
  Paused)   icon=""; cls="paused" ;;    # pause
  *)        icon=""; cls="stopped" ;;   # stop
esac

tooltip="$artist — $title"
printf '{"text":"%s %s","tooltip":"%s","class":"%s"}\n' \
  "$icon" "$short" "${tooltip//\"/\\\"}" "$cls"
