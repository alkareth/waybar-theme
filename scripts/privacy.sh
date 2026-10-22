#!/usr/bin/env bash
# ~/.config/waybar/scripts/privacy.sh
# Placeholder privacy (Hyprland n'a pas de module "privacy" natif).
# Renvoie un JSON vide tant que la détection micro/cam n'est pas branchée.
# Phase 2 : pw-dump / hyprctl pour détecter les sources actives.

printf '{"text":"","class":"inactive"}\n'
