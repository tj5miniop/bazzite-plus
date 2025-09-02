#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1



# NOTICE - Kernel installation will be moved to a separate script/Containerfile - as of 08/06/25 - trying this now in build.sh - Note, kernel installation appears to be working
#dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-rar.repo
#dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo --overwrite
#dnf5 -y config-manager setopt "*fedora*".exclude="mesa-* kernel-core-* kernel-modules-* kernel-uki-virt-*"

#Remove firefox - Users can install their own browser
#dnf5 -y remove firefox

#Install CachyOS optimisations
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y update
dnf5 -y install libcap-ng libcap-ng-devel procps-ng procps-ng-devel
dnf5 -y install cachyos-settings scx-scheds uksmd --allowerasing
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons
dnf5 -y clean all

# Add SELinux override to install kernel
setsebool -P domain_kernel_load_modules on

#Install base apps/utilities
dnf5 install -y fastfetch nano wget curl git fzf zsh flatpak

#Install Apps for Content Creation - EG - OBS Studio, Discord etc
dnf5 install -y obs-studio mangohud



# Remove Bazzite Apps which I don't use 
dnf5 -y remove webapp-manager fish btop p7zip p7zip-plugins rar cockpit-networkmanager cockpit-podman cockpit-selinux cockpit-system cockpit-navigator cockpit-storaged btrfs-assistant waydroid cage lutris steamdeck-kde-presets-desktop wallpaper-engine-kde-plugin kate


# Flatpak Uninstallation & Configuration - 
flatpak uninstall --all 
dnf5 -y clean all

flatpak -y install flathub com.vysp3r.ProtonPlus --system 
flatpak -y install flathub com.usebottles.bottles --system
flatpak -y install flathub com.github.tchx84.Flatseal --system
flatpak -y install flathub com.ranfdev.DistroShelf --system
flatpak -y install flathub io.github.Foldex.AdwSteamGtk --system 
flatpak -y install flathub com.brave.Browser --system
# Clean Flatpak Dependencies
flatpak -y uninstall --unused --system


# Set KDE Defaults 



# Enable Systemd Units
systemctl enable podman.socket
