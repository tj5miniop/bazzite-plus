#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1



# NOTICE - Kernel installation will be moved to a separate script/Containerfile - as of 08/06/25 - trying this now in build.sh - Note, kernel installation appears to be working
dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-rar.repo
dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo --overwrite
dnf5 -y config-manager setopt "*fedora*".exclude="mesa-* kernel-core-* kernel-modules-* kernel-uki-virt-*"

#Remove firefox - Users can install their own browser
dnf5 -y remove firefox

#Install CachyOS optimisations
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y update
dnf5 -y install libcap-ng libcap-ng-devel procps-ng procps-ng-devel
dnf5 -y install cachyos-settings scx-scheds uksmd --allowerasing
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons
dnf5 -y clean all

# Add SELinux override to install kernel
setsebool -P domain_kernel_load_modules on


dnf5 -y copr enable gloriouseggroll/nobara-42
dnf5 -y upgrade kernel* 
dnf5 -y copr disable gloriouseggroll/nobara-42


#Install base apps/utilities
dnf5 install -y fastfetch nano wget curl git fzf zsh flatpak

#Install Apps for Content Creation - EG - OBS Studio, Discord etc
dnf5 install -y obs-studio mangohud

# Remove random KDE stuff - NOT NEEDED AS THESE ARE INSTALLED AS FLATPAKS
#dnf5 -y remove okular kmines kwrite kcalc elisa kmahjongg gwenview 

# Install Gaming-Related Stuff
#Mesa-git 
dnf5 -y copr enable danayer/mesa-git 
dnf5 -y update
dnf5 -y copr disable danayer/mesa-git

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
