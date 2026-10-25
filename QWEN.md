# Projet

Configuration [Waybar](https://github.com/Alexays/Waybar) pour Hyprland.

## Conventions

- **Scripts shell** : sortie JSON `{text, tooltip, class}` pour les modules custom.
- **CSS** : couleurs via `@define-color` + `alpha()` GTK.
- **config.jsonc** : commentaires `//` autorisés.

## Limites

Le fichier `style.css` contient un bloc délimité `MATUGEN START / MATUGEN END` qui est régénéré par Matugen au changement de wallpaper. **Ne jamais renommer** les variables contenues dans ce bloc.

## Commandes

`killall -SIGUSR2 waybar` pour recharger après modif.
