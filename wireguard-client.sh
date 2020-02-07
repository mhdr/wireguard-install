#!/bin/bash
# Secure WireGuard For CentOS, Debian, Ubuntu, Arch, Fedora, Redhat, Raspbian

# Check Root Function
function root-check() {
  if [ "$EUID" -ne 0 ]; then
    echo "You need to run this script as root."
    exit
  fi
}

# Root Check
root-check

# Checking For Virtualization
function virt-check() {
  # Deny OpenVZ
  if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ virtualization is not supported (yet)."
    exit
  fi
  # Deny LXC
  if [ "$(systemd-detect-virt)" == "lxc" ]; then
    echo "LXC virtualization is not supported (yet)."
    exit
  fi
}

# Virtualization Check
virt-check

# Detect Operating System
function dist-check() {
  if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ]; then
    DISTRO=$(lsb_release -is)
  elif [ -e /etc/arch-release ]; then
    DISTRO="Arch"
  elif [ -e /etc/fedora-release ]; then
    DISTRO="Fedora"
  elif [ -e /etc/redhat-release ]; then
    DISTRO="Redhat"
  else
    echo "Your distribution is not supported (yet)."
    exit
  fi
}

# Check Operating System
dist-check

# Install WireGuard Client
function install-wireguard-client() {
  # Installation begins here.
  if [ "$DISTRO" == "Ubuntu" ]; then
    apt-get update
    apt-get install linux-headers-"$(uname -r)" -y
    apt-get install wireguard qrencode haveged resolvconf -y
  if [ ! $VERSION_ID = (16.04|18.04) ]; then
    apt-get update
    apt-get install software-properties-common -y
    add-apt-repository ppa:wireguard/wireguard -y
    apt-get update
    apt-get install linux-headers-"$(uname -r)" -y
    apt-get install wireguard qrencode haveged resolvconf -y
  fi
  elif [ "$DISTRO" == "Debian" ]; then
    apt-get update
    echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable
    apt-get update
    apt-get install linux-headers-"$(uname -r)" -y
    apt-get install wireguard qrencode haveged resolvconf -y
  elif [ "$DISTRO" == "Raspbian" ]; then
    apt-get update
    apt-get install dirmngr -y
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
    echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable
    apt-get update
    apt-get install raspberrypi-kernel-headers -y
    apt-get install wireguard qrencode haveged resolvconf -y
  elif [ "$DISTRO" == "Arch" ]; then
    pacman -Syu --noconfirm linux-headers
    pacman -Syu --noconfirm haveged qrencode iptables
    pacman -Syu --noconfirm wireguard-tools wireguard-arch
  elif [ "$DISTRO" = 'Fedora' ]; then
    dnf update -y
    dnf install wireguard-tools resolvconf
  if [ ! $VERSION_ID = (31) ]; then
    dnf update -y
    dnf copr enable jdoss/wireguard
    dnf dnf install wireguard-dkms wireguard-tools resolvconf
  fi
  elif [ "$DISTRO" == "CentOS" ]; then
    yum update -y
    yum install epel-release
    yum config-manager --set-enabled PowerTools
    yum copr enable jdoss/wireguard
    yum install wireguard-dkms wireguard-tools resolvconf
  if [ ! $VERSION_ID = (6|7) ]; then
    yum update -y
    wget -O /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum update -y
    yum install epel-release -y
    yum install kernel-headers-"$(uname -r)" kernel-devel-"$(uname -r)" -y
    yum install wireguard-dkms wireguard-tools qrencode haveged resolvconf -y
  fi
  elif [ "$DISTRO" == "Redhat" ]; then
    yum update -y
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
    yum copr enable jdoss/wireguard
    yum install wireguard-dkms wireguard-tools resolvconf
  if [ ! $VERSION_ID = (8) ]; then
    yum update -y
    wget -O /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum update -y
    yum install epel-release -y
    yum install kernel-headers-"$(uname -r)" kernel-devel-"$(uname -r)" -y
    yum install wireguard-dkms wireguard-tools qrencode haveged resolvconf -y
fi
  fi
  }

  # WireGuard Client
  install-wireguard-client
