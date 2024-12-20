#!/bin/bash

PACMAN_PACKAGES=(
  "alacritty" "base-devel" "btop" "file-roller" "hyprland" "hyprpaper" "ly" "nano" "neofetch" "nvidia" "pulsemixer" "steam" "thunar" "waybar" "rofi-wayland" "plymouth"
)

PARU_PACKAGES=(
  "bibata-cursor-theme-bin" "google-chrome" "gruvbox-gtk-theme-git" "gruvbox-icon-theme-git" "hyprshot" "spicetify-cli" "spotify" "vesktop-bin" "plymouth-theme-loader-2-git"
)


# === Step 1: Update pacman.conf ===
cd ~
sudo cp -f ~/Hypr/pacman.conf /etc/
sudo cp -f ~/Hypr/nanorc /etc/

# === Step 2: Install essential packages with pacman ===
sudo pacman -Sy --noconfirm "${PACMAN_PACKAGES[@]}"

# === Step 3: Install paru (AUR helper) and essential packeges ===
git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm
cd ~
sudo rm -rf paru/

# === Step 4: Install essential packages with paru ===
paru -Sy --noconfirm "${PARU_PACKAGES[@]}"

# === Step 5: Enable and disable systemd services ===
sudo systemctl enable pipewire.service
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# === Step 6: Clone and copy dotfiles ===
sudo cp -r ~/Hypr/.config ~
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Green-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface font-name 'SourceCodePro 11'
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify update
sudo cp -f ~/Hypr/mkinitcpio.conf /etc/
sudo mkinitcpio -p linux
sudo cp -f ~/Hypr/grub /etc/default/
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo plymout-default-theme -R loader_2
sudo cp -f ~/Hypr/pltmouth.conf /etc/plymouth/
sudo mkinitcpio -p linux

# === Step 7: Final cleanup ===
sudo pacman -Rns $(pacman -Qdtq) --noconfirm
sudo pacman -Scc --noconfirm
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" & cp -f ~/Hypr/.bashrc ~ & sudo rm -rf ~/Hypr/ & reboot
