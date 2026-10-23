#!/usr/bin/env bash
# Menu réseau simple pour le clic sur #network (wofi + nmcli).
# Adapte le launcher si tu utilises hyprpicker/rofi/fuzzel.
LAUNCHER="wofi --dmenu"
if ! command -v wofi >/dev/null 2>&1; then LAUNCHER="fuzzel --dmenu"; fi

choice=$(nmcli -t -f NAME,TYPE connection show --active | cut -d: -f1 | \
  printf "Déconnecter tout\n%s\n" "$(nmcli -f SSID --fields SSID device wifi list 2>/dev/null | tail -n +2)" | \
  $LAUNCHER -p "Réseau")
[ -z "$choice" ] && exit 0
if [ "$choice" = "Déconnecter tout" ]; then
  nmcli networking off
else
  nmcli device wifi connect "$choice"
fi
