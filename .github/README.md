# Secure Wireguard Installer
![GitHub release (latest by date)](https://img.shields.io/github/v/release/complexorganizations/wireguard-install)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install?ref=badge_shield)
![GitHub All Releases](https://img.shields.io/github/downloads/complexorganizations/wireguard-install/total)
![GitHub](https://img.shields.io/github/license/complexorganizations/wireguard-install)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/complexorganizations/wireguard-install)
![GitHub issues](https://img.shields.io/github/issues/complexorganizations/wireguard-install)
![GitHub contributors](https://img.shields.io/github/contributors/complexorganizations/wireguard-install)

### Prerequisite 
- CentOS, Debian, Ubuntu, Arch, Fedora, Redhat, Raspbian, Alpine, Gentoo
- Linux Kernel 4.1 or newer
- You will need root access, or a user account with `sudo` privilege.

## Installation
```
wget https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/wireguard-server.sh -P /etc/wireguard/
bash /etc/wireguard/wireguard-server.sh
```
The first time you run it, you'll have to follow the assistant and answer a few questions to setup your VPN server.

## Headless install
The headless install lets users skip all the questions.

```
chmod +x /etc/wireguard/wireguard-server.sh
HEADLESS_INSTALL=y /etc/wireguard/wireguard-server.sh
```

---
### After Installation
In your `/etc/wireguard/clients` directory, you will have `.conf` files. These are the client configuration files. Download them from your WireGuard Interface and connect using your favorite WireGuard Peer.

- Show WireGuard Interface
- Start WireGuard Interface
- Stop WireGuard Interface
- Add WireGuard Peer
- Remove WireGuard Peer
- Uninstall WireGuard Interface
- Update this script

---
### Features

- Installs and configures a ready-to-use WireGuard Interface
- Iptables rules and forwarding managed in a seamless way
- If needed, the script can cleanly remove WireGuard, including configuration and iptables rules
- Variety of DNS resolvers to be pushed to the clients
- Choice to use a self-hosted resolver with Unbound (supports already existing Unbound installations)
- Block DNS leaks
- Many other little things!

---
### Options

* `PRIVATE_SUBNET_V4` - private subnet configuration, "10.0.0.0/24" by default
* `PRIVATE_SUBNET_V6` - private subnet configuration, "fd42:42:42::0/64" by default
* `SERVER_HOST_V4` - public IPv4 address, detected by default using `wget`
* `SERVER_HOST_V6` - public IPv6 address, detected by default using `wget`
* `SERVER_PORT` - public port for wireguard server
* `MTU_CHOICE` - the MTU the client will use to connect to DNS

---
### Compatibility
| OS              | Supported          | i386               | amd64              | armhf              | arm64              |
| --------------  | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ |
| Amazon Linux    |:white_check_mark:  |:x:                 |:white_check_mark:  |:x:                 |:x:                 |
| Ubuntu 16.04    |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Ubuntu 18.04    |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Ubuntu 19.04    |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Ubuntu 20.04    |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Raspbian        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 6.x      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| Debian 7.x      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| Debian 8.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 9.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 10.x     |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| CentOS 6.x      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| CentOS 7.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| CentOS 8.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| CentOS 9.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Fedora          |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| RedHat 6.x      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| RedHat 7.x      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Arch            |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| LXC             |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| OpenVZ          |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |

| Cloud           | Supported          |
| --------------  | ------------------ |
| AWS             |:white_check_mark:  |
| Google Cloud    |:white_check_mark:  |
| Linode          |:white_check_mark:  |
| Digital Ocean   |:white_check_mark:  |
| Vultr           |:white_check_mark:  |
| Microsoft Azure |:white_check_mark:  |
| OpenStack       |:white_check_mark:  |
| Rackspace       |:white_check_mark:  |
| Scaleway        |:white_check_mark:  |
| EuroVPS         |:white_check_mark:  |
| Hetzner Cloud   |:x:                 |
---
### Q&A
Which hosting provider do you recommend?
- [Google Cloud](https://gcpsignup.page.link/H9XL): Worldwide locations, starting at $10/month
- [Vultr](https://www.vultr.com/?ref=8211592): Worldwide locations, IPv6 support, starting at $3.50/month
- [Digital Ocean](https://m.do.co/c/fb46acb2b3b1): Worldwide locations, IPv6 support, starting at $5/month
- [Linode](https://www.linode.com/?r=63227744138ea4f9d2dff402cfe5b8ad19e45dae): Worldwide locations, IPv6 support, starting at $5/month

Which WireGuard client do you recommend?
- Windows: [WireGuard](https://download.wireguard.com/windows-client/wireguard-amd64-0.0.38.msi).
- macOS: [WireGuard](https://apps.apple.com/us/app/wireguard/id1451685025).
- Android: [WireGuard](https://play.google.com/store/apps/details?id=com.wireguard.android).
- iOS: [WireGuard](https://itunes.apple.com/us/app/wireguard/id1441195209).

Is there an WireGuard documentation?
- Yes, please head to the [WireGuard Manual](https://www.wireguard.com), which references all the options.
---
### Credits & Licence
Many thanks to the [Contributors](https://github.com/complexorganizations/wireguard-install/graphs/contributors)
This project is under the [General Public License](https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/LICENSE)
