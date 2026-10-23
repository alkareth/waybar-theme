#!/usr/bin/env bash
# ~/.config/waybar/scripts/toggle-mute.sh
# Mute/unmute via WirePlumber (pipewire). wpctl est fourni par wireplumber.

set -u
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
