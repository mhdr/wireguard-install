# Wireguard Install

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install?ref=badge_shield)

## Prerequisite 
- Linux Server
- Client Device
- Sudo acess

## Installation

```
wget https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/wireguard-server.sh -P /etc/wireguard/
bash /etc/wireguard/wireguard-server.sh
```

You need to run the script as root ```sudo su```

The first time you run it, you'll have to follow the assistant and answer a few questions to setup your VPN server.

When WireGuard is installed, you can run the script again, and you will get the choice to :

- Show WireGuard Interface
- Start WireGuard Interface
- Stop WireGuard Interface
- Add WireGuard Peer
- Remove WireGuard Peer
- Uninstall WireGuard Interface
- Update this script

In your ```/etc/wireguard/clients``` directory, you will have `.conf` files. These are the client configuration files. Download them from your server and connect using your favorite WireGuard client.

## Features

- Installs and configures a ready-to-use WireGuard server
- Iptables rules and forwarding managed in a seamless way
- If needed, the script can cleanly remove WireGuard, including configuration and iptables rules
- Variety of DNS resolvers to be pushed to the clients
- Choice to use a self-hosted resolver with Unbound (supports already existing Unbound installations)
- Block DNS leaks
- Protect clients with a password (private key encryption)
- Many other little things!

## Options

The script can be configured by setting the following environment variables:

* INTERACTIVE - if set to "no", the script will not prompt for user input
* PRIVATE_SUBNET_V4 - private subnet configuration, "10.0.0.0/24" by default
* PRIVATE_SUBNET_V6 - private subnet configuration, "fd42:42:42::0/64" by default
* SERVER_HOST_V4 - public IPv4 address, detected by default
* SERVER_HOST_V6 - public IPv6 address, detected by default
* SERVER_PORT - public port for wireguard server
* MTU_CHOICE - the MTU the client will use to connect to DNS


## Compatibility

The script supports these OS and architectures:

| OS              | Supported          | i386               | amd64              | armhf              | arm64              |
| --------------  | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ |
| Amazon Linux    |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
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
---
Which hosting provider do you recommend?
- [Google Cloud](https://console.cloud.google.com/freetrial?referralId=9142cd715558411aaaaaf2dc6d2b7886): Worldwide locations, starting at $10/month
- [Vultr](https://www.vultr.com/?ref=8211592): Worldwide locations, IPv6 support, starting at $3.50/month
- [Digital Ocean](https://m.do.co/c/fb46acb2b3b1): Worldwide locations, IPv6 support, starting at $5/month
- [Linode](https://www.linode.com/?r=63227744138ea4f9d2dff402cfe5b8ad19e45dae): Worldwide locations, IPv6 support, starting at $5/month
---
Which WireGuard client do you recommend?
- Windows: [WireGuard](https://download.wireguard.com/windows-client/wireguard-amd64-0.0.38.msi).
- macOS: [WireGuard](https://apps.apple.com/us/app/wireguard/id1451685025).
- Android: [WireGuard](https://play.google.com/store/apps/details?id=com.wireguard.android).
- iOS: [WireGuard](https://itunes.apple.com/us/app/wireguard/id1441195209).
---
Is there an WireGuard documentation?
- Yes, please head to the [WireGuard Manual](https://www.wireguard.com), which references all the options.
---

## Credits & Licence

Many thanks to the [contributors](https://github.com/complexorganizations/wireguard-install/graphs/contributors)
This project is under the [MIT Licence](https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/LICENSE)
