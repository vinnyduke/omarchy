# CHANGELOG-OMARCHY-DELTA.md

> Modifications du fork `vinnyduke/omarchy` par rapport à l'upstream `basecamp/omarchy`.
> Facile à étendre : ajouter une entrée datée dans la catégorie appropriée.

## 2026-06-13 — Packages Retirés

- **1password-beta**: Remplacé par rbw (gestionnaire de mots de passe Bitwarden)
- **1password-cli**: Remplacé par rbw
- **aether**: Non utilisé
- **alacritty**: Remplacé par Ghostty comme terminal par défaut
- **jdk-openjdk**: Java non nécessaire sur le système
- **kdenlive**: Éditeur vidéo non utilisé
- **neovim** (alias nvim dans upstream): Retiré puis restauré — n'est plus l'éditeur par défaut (nano remplace) mais reste installé
- **omarchy-nvim**: Retiré puis restauré — conservé avec neovim
- **obs-studio**: Streaming non utilisé
- **pinta**: Éditeur d'images non utilisé
- **typora**: Éditeur markdown payant non utilisé
- **xournalpp**: Prise de notes non utilisée
- **yay-debug**: Package debug non nécessaire
- **nvidia-dkms**: Doublon de nvidia-open-dkms (déjà dans les listes)
- **apple-bcm-firmware** → Déplacé vers AUR list (package AUR, conservé pour multi-arch)
- **apple-t2-audio-config** → Déplacé vers AUR list
- **linux-t2** → Déplacé vers AUR list
- **linux-t2-headers** → Déplacé vers AUR list
- **t2fanrd** → Déplacé vers AUR list
- **tiny-dfr** → Déplacé vers AUR list

## 2026-06-13 — Packages Ajoutés

- **ghostty**: Terminal par défaut du fork (remplace Alacritty)
- **yazi**: File manager TUI
- **atuin**: Shell history amélioré
- **television**: TUI tool
- **git-delta**: Git diff amélioré
- **ollama**: LLM local (optionnel)
- **rbw**: Bitwarden CLI (optionnel)
- **etckeeper**: Suivi des modifications /etc

## 2026-06-13 — AUR (Externalisés)

- **install/packaging/aur-packages.txt**: 14 packages AUR gérés séparément
  - ccstatusline, python-rich-rst, rich-cli, rtk, rtk-debug, traur, traur-debug
  - apple-bcm-firmware, apple-t2-audio-config, linux-t2, linux-t2-headers, t2fanrd, tiny-dfr (Apple T2)
- **install/packaging/aur-install.sh**: Script d'installation avec support `--skip-aur`

## 2026-06-13 — Configs Modifiées

- **default/hypr/looknfeel.conf**: Thème Catppuccin, 8px rounding, animations upstream conservées. Layout dwindle (restauré après correction — scrolling était commenté dans la config utilisateur, pas activé). Gaps 5/10, border 2.
- **default/hypr/bindings.conf**: Remplacement de `$passwordManager` par `rbw-menu` (corrigé post-vérification — sed initial non fonctionnel)
- **default/hypr/autostart.conf**: 13 exec-once upstream conservés (hypridle, mako, waybar, fcitx5, swaybg, polkit-gnome, first-run, powerprofiles, monitor-watch, systemd env vars, post-boot hooks)
- **default/hypr/input.conf**: Synchronisé avec la config utilisateur (kb_layout=ca — valeur locale, adaptée à l'utilisateur du fork)

## 2026-06-13 — Configs Ajoutées

- **default/waybar/config.jsonc**: Configuration personnalisée Waybar
- **default/waybar/style.css**: Style personnalisé Waybar
- **default/nano/**: 119 fichiers de syntax highlighting nano

## 2026-06-13 — Applications

- **applications/Ghostty.desktop**: Créé (Icon=com.mitchellh.ghostty)
- **applications/Alacritty.desktop**: Supprimé (remplacé par Ghostty)
- **applications/typora.desktop**: Supprimé (package retiré)

## 2026-06-13 — Scripts Ajoutés

- **install/config/nano.sh**: Installation des fichiers de syntax highlighting nano + EDITOR=nano
- **install/config/shell.sh**: Personnalisations shell (EDITOR=nano, atuin init, keybindings)
- **bin/rbw-menu**: Gestionnaire de mots de passe Bitwarden intégré à Walker
- **install/preflight/partition-setup.sh**: Script de partitionnement personnalisé avec `/home` séparé (exécution manuelle depuis l'ISO)

## 2026-06-13 — Pilotes Hardware Conservés

Les pilotes hardware suivants sont conservés dans les listes officielles pour garantir l'installabilité sur toute architecture :
- apple-*, intel-*, nvidia-*, broadcom-wl, asusctl, dell-xps-touchpad-haptics, macbook12-spi-driver-dkms, sof-firmware, thermald, tuxedo-drivers-nocompatcheck-dkms, vulkan-*, yt6801-dkms, etc.

## 2026-06-13 — Correctifs

- **default/hypr/looknfeel.conf**: Layout scrolling → dwindle. Le scrolling était commenté dans la config utilisateur, pas activé. Gaps et bordures restaurés (5/10/2).
- **default/hypr/autostart.conf**: Restauration complète des 13 exec-once upstream. Le fichier avait été vidé par l'agent autonome (remplacé par l'override utilisateur vide), ne laissant que swaybg. Le override `~/.config/hypr/autostart.conf` est revenu à son état pré-phase 2 (commentaires seuls).
- **waybar.service**: Désactivé (`systemctl --user disable`). Waybar est maintenant géré par Hyprland via l'exec-once upstream.
- **install/omarchy-base.packages**: Restauration de `neovim` et `omarchy-nvim` (supprimés car nano est l'éditeur par défaut, mais l'utilisateur les conserve comme outils).
