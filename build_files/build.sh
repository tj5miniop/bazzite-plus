#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos


#Install base apps/utilities
dnf5 install -y fastfetch nano wget curl git fzf zsh flatpak

#Install Apps for Content Creation - EG - OBS Studio, Discord etc
dnf5 install -y obs-studio mangohud

# Remove random KDE stuff - NOT NEEDED AS THESE ARE INSTALLED AS FLATPAKS
#dnf5 -y remove okular kmines kwrite kcalc elisa kmahjongg gwenview 

# Install Custom Kernel 
wget -O kernel.tar.gz https://github.com/tj5miniop/linux-tkg/releases/download/kinoiteplus/kernel.tar.gz
tar -xvf ./kernel.tar.gz
cd kernel
sudo dnf install --allowerasing --allowdowngrade ./*.rpm



# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
