#!/usr/bin/env bash
# ~/.config/waybar/scripts/swaync.sh
# Renvoie un JSON {text, tooltip, class} pour le module custom/swaync.
# Dépend de swaync-client (swaynotificationcenter).

set -u

state=$(swaync-client -sw 2>/dev/null)   # "Inhibit" si DND activé, sinon ""
count=$(swaync-client -c 2>/dev/null | tr -dc '0-9')
count=${count:-0}

if [ "$state" = "Inhibit" ]; then
  class="dnd"
elif [ "${count:-0}" -gt 0 ]; then
  class="notification"
else
  class="inactive"
fi

case "$class" in
  dnd)          icon="" ;;   # bell-slash
  notification) icon="" ;;   # bell
  *)            icon="" ;;   # bell-outline
esac

printf '{"text":"%s","tooltip":"%s notif(s)","class":"%s"}\n' \
  "$icon" "$count" "$class"
