#!/usr/bin/env bash
# ~/.config/waybar/scripts/privacy.sh
# Placeholder privacy (Hyprland n'a pas de module "privacy" natif).
# Affiche une icône "bouclier" neutre pour rester visible dans la pill.
# Phase 2 : pw-dump / hyprctl pour détecter les sources actives ;
#          class "active" -> rouge via le CSS (#custom-privacy.active).

printf '{"text":"\uf3ed ","class":"inactive"}\n'   # shield-outline NF
