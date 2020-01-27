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

# Install WireGuard Server
function install-wireguard-server() {
  # Installation begins here.
  if [ "$DISTRO" == "Ubuntu" ]; then
    apt-get update
    apt-get install software-properties-common -y
    add-apt-repository ppa:wireguard/wireguard -y
    apt-get update
    apt-get install linux-headers-"$(uname -r)" -y
    apt-get install wireguard qrencode haveged resolvconf -y
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
    pacman -Syu --noconfirm wireguard-tools wireguard-arch resolvconf
  elif [ "$DISTRO" = 'Fedora' ]; then
    dnf update -y
    dnf copr enable jdoss/wireguard -y
    dnf install kernel-headers-"$(uname -r)" kernel-devel-"$(uname -r)" -y
    dnf install qrencode wireguard-dkms wireguard-tools haveged resolvconf -y
  elif [ "$DISTRO" == "CentOS" ]; then
    yum update -y
    wget -O /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum update -y
    yum install epel-release -y
    yum install kernel-headers-"$(uname -r)" kernel-devel-"$(uname -r)" -y
    yum install wireguard-dkms wireguard-tools qrencode haveged resolvconf -y
  elif [ "$DISTRO" == "Redhat" ]; then
    yum update -y
    wget -O /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum update -y
    yum install epel-release -y
    yum install kernel-headers-"$(uname -r)" kernel-devel-"$(uname -r)" -y
    yum install wireguard-dkms wireguard-tools qrencode haveged resolvconf -y
  fi
  }

  # WireGuard Server
  install-wireguard-server
