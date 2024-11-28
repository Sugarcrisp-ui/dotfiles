#!/bin/bash

# Define source and destination directories
SOURCE_DIR="$HOME/dotfiles/"
DEST_DIR="desktop:/media/brett/backup/dotfiles-laptop/"
LOG_FILE="$HOME/backup.log"

    rsync -av --delete \
        --include 'bash/***' \
        --include 'config/.config/' \
        --include 'config/.config/bluetooth/***' \
        --include 'config/.config/i3/***' \
        --include 'config/.config/i3-auto-layout/***' \
        --include 'config/.config/nemo/***' \
        --include 'config/.config/picom/***' \
        --include 'config/.config/polybar/***' \
        --include 'config/.config/Proton/***' \
        --include 'config/.config/qBittorrent/***' \
        --include 'config/.config/rofi/***' \
        --include 'config/.config/i3-xdg-terminals.list' \
        --include 'config/.config/input.conf' \
        --include 'config/.config/main.conf' \
        --include 'config/.config/mimeapps.list' \
        --include 'config/.config/network.conf' \
        --include 'config/.config/pavucontrol.ini' \
        --include 'config/.config/QtProject.conf' \
        --include 'config/.config/user-dirs.dirs' \
        --include 'config/.config/user-dirs.locale' \
        --include 'config/.config/xdg-terminals.list' \
        --include 'feh/***' \
        --include 'fonts/***' \
        --include 'i3status/***' \
		--include 'local/***' \
        --include 'ssh/***' \
        --include 'git-v1.sh' \
        --include 'git-v2.sh' \
        --include 'setup-git-v1.sh' \
        --include 'setup-git-v2.sh' \
        --include '*.swp' \
        --exclude '*' \
        "$SOURCE_DIR" "$DEST_DIR"
