#!/usr/bin/env bash
# ~/.config/waybar/scripts/hook-matugen.sh
# Régénère style.css via matugen à partir de template.css (+ template.json
# qui force le schéma "dark"), puis reload waybar.
#
# Utilisation : hook-matugen.sh [image]
#   Sans argument : cherche le wallpaper Hyprland courant, sinon
#   ~/.config/hypr/wallpaper.png.
# Intégration hyprland.conf (au changement de wallpaper) :
#   bind = SUPER, W, exec, ~/.config/hypr/wallpaper.sh && ~/.config/waybar/scripts/hook-matugen.sh
# ou en systemd user / cron si piloté par swayrd/wpg.

set -u

IMG="${1:-}"

# --- Résolution du wallpaper courant ----------------------------------------
if [ -z "$IMG" ] && command -v hyprctl >/dev/null 2>&1; then
  # hyprctl getoption decoration:wallpaper -j -> {"str":"path:///chemin.png"}
  IMG=$(hyprctl getoption decoration:wallpaper -j 2>/dev/null \
        | python3 -c 'import sys,json;print(json.load(sys.stdin).get("str",""))' 2>/dev/null \
        | sed 's|^path://||')
fi
[ -z "$IMG" ] && IMG="$HOME/.config/hypr/wallpaper.png"
[ -f "$IMG" ] || { echo "wallpaper introuvable: $IMG" >&2; exit 1; }

CFG="$HOME/.config/waybar"
TPL="$CFG/template.css"
[ -f "$TPL" ] || { echo "template manquant: $TPL" >&2; exit 1; }

# --- Matugen -----------------------------------------------------------------
if ! command -v matugen >/dev/null 2>&1; then
  echo "matugen absent (pacman -S matugen / cargo install matugen)" >&2
  exit 1
fi

# Copie le template dans $XDG_CONFIG_HOME (~/.config) car matugen résout -t/-o
# relativement à ce dossier. => lit ~/.config/waybar/template.{css,json} et
# écrit ~/.config/waybar/style.css. hexbox => {{SEPARATOR}} = "." et des
# #rrggbb purs (compatible @define-color GTK). template.json force "dark".
CFG_SRC="$HOME/.config/waybar"
TMPD="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
mkdir -p "$TMPD"
cp "$CFG_SRC/template.css" "$CFG_SRC/template.json" "$TMPD/" 2>/dev/null || true
matugen -l hexbox -t waybar/template.css -o waybar image "$IMG" \
  || { echo "échec de matugen" >&2; exit 1; }
if [ "$TMPD" != "$CFG_SRC" ]; then cp "$TMPD/style.css" "$CFG_SRC/style.css"; fi

pkill -USR2 waybar 2>/dev/null   # reload config+style (Waybar >= 0.10.2)
exit 0
