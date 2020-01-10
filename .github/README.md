# Wireguard Install

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcomplexorganizations%2Fwireguard-install?ref=badge_shield)

## Usage 

```
wget -O /etc/wireguard/wireguard-server.sh https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/wireguard-server.sh
bash /etc/wireguard/wireguard-server.sh
```

You need to run the script as root
The first time you run it, you'll have to follow the assistant and answer a few questions to setup your VPN server.

When WireGuard is installed, you can run the script again, and you will get the choice to :

- Show WireGuard Interface
- Start WireGuard Interface
- Stop WireGuard Interface
- Add WireGuard Peer
- Remove WireGuard Peer
- Uninstall WireGuard Interface
- Update this script
- Exit

In your ```/etc/wireguard/clients``` directory, you will have `.wg` files. These are the client configuration files. Download them from your server and connect using your favorite WireGuard client.

## Features

- Installs and configures a ready-to-use WireGuard server
- Iptables rules and forwarding managed in a seamless way
- If needed, the script can cleanly remove WireGuard, including configuration and iptables rules
- Variety of DNS resolvers to be pushed to the clients
- Choice to use a self-hosted resolver with Unbound (supports already existing Unbound installations)
- Block DNS leaks
- Protect clients with a password (private key encryption)
- Many other little things!

## Compatibility

The script supports these OS and architectures:

|                | i386 | amd64 | armhf | arm64 |
| -------------- | ---- | ----- | ----- | ----- |
| Amazon Linux 2 |  ❔  |  ✅  |   ❔  |   ❔  |
|  Arch Linux    |  ❔  |  ✅  |   ❔  |   ✅  |
|   Centos 9     |  ❌  |  ✅  |   ❔  |   ❔  |
|   Centos 8     |  ❌  |  ✅  |   ❔  |   ❔  |
|   CentOS 7     |  ❔  |  ✅  |   ❌  |   ✅  |
|   Debian 8     |  ✅  |  ✅  |   ❌  |   ❌  |
|   Debian 9     |  ❌  |  ✅  |   ✅  |   ✅  |
|   Debian 10    |  ❔  |  ✅  |   ✅  |   ❔  |
|   Fedora 27    |  ❔  |  ✅  |   ❔  |   ❔  |
|   Fedora 28    |  ❔  |  ✅  |   ❔  |   ❔  |
| Ubuntu 16.04   |  ✅  |  ✅  |   ❌  |   ❌  |
| Ubuntu 18.04   |  ❌  |  ✅  |   ✅  |   ✅  |
| Ubuntu 19.04   |  ❌  |  ✅  |   ✅  |   ✅  |
| Ubuntu 20.04   |  ❌  |  ✅  |   ✅  |   ✅  |


**Q:** Which provider do you recommend?
**A:** I recommend these:
- [Google Cloud](https://console.cloud.google.com/freetrial?referralId=9142cd715558411aaaaaf2dc6d2b7886): Worldwide locations, IPv6 support, starting at $10/month
- [Vultr](https://www.vultr.com/?ref=8211592): Worldwide locations, IPv6 support, starting at $3.50/month
- [Digital Ocean](https://m.do.co/c/fb46acb2b3b1): Worldwide locations, IPv6 support, starting at $5/month
- [Linode](https://m.do.co/c/fb46acb2b3b1): Worldwide locations, IPv6 support, starting at $5/month
---
**Q:** Which WireGuard client do you recommend?
**A:** If possible, an official WireGuard client.
- Windows: [WireGuard](https://www.wireguard.com/install/).
- macOS: [WireGuard](https://www.wireguard.com/install/).
- Android: [WireGuard](https://www.wireguard.com/install/).
- iOS: [WireGuard](https://www.wireguard.com/install/).
---

## Credits & Licence

Many thanks to the [contributors](https://github.com/complexorganizations/wireguard-install/graphs/contributors)
This project is under the [MIT Licence](https://raw.githubusercontent.com/complexorganizations/wireguard-install/master/LICENSE)
