#!/bin/bash

PACMAN_PACKAGES=(
  "alacritty" "base-devel" "btop" "file-roller" "hyprland" "hyprpaper" "ly" "nano" "neofetch" "nvidia" "pulsemixer" "steam" "thunar" "waybar" "wofi"
)

PARU_PACKAGES=(
  "bibata-cursor-theme-bin" "google-chrome" "gruvbox-gtk-theme-git" "gruvbox-icon-theme-git" "hyprshot" "spicetify-cli" "spotify" "vesktop-bin"
)


# === Step 1: Update pacman.conf ===
echo "Updating pacman.conf..."
cd ~
sudo cp -f ~/Hypr/pacman.conf /etc/
sudo cp -f ~/Hypr/nanorc /etc/

# === Step 2: Install paru (AUR helper) ===
echo "Installing paru..."
git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm
cd ~
sudo rm -rf paru/


# === Step 3: Install essential packages with pacman ===
echo "Installing essential packages with pacman..."
sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"

# === Step 4: Install essential packages with paru ===
echo "Installing essential packages with paru..."
paru -S --noconfirm "${PARU_PACKAGES[@]}"

# === Step 5: Install oh-my-bash ===
echo "Installing and setuping oh-my-bash..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sudo cp -f ~/Hypr/.bashrc ~

# === Step 6: Enable and disable systemd services ===
echo "Configuring systemd services..."
sudo systemctl enable pipewire.service
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# === Step 7: Clone and copy dotfiles ===
sudo cp -r ~/Hypr/.config ~

# === Step 8: Final cleanup ===
echo "Cleaning up unnecessary files..."
sudo pacman -Rns $(pacman -Qdtq) --noconfirm
sudo pacman -Scc --noconfirm
echo "Reboot your system!"
sudo rm -rf ~/Hypr/
