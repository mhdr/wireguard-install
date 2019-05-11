#!/bin/bash
#
# https://github.com/LiveChief/wireguard-install
#

WG_CONFIG="/etc/wireguard/wg0.conf"

if [[ "$EUID" -ne 0 ]]; then
    echo "Sorry, you need to run this as root"
    exit
fi

if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
else
    echo "Your distribution is not supported (yet)"
    exit
fi

if [ "$( systemd-detect-virt )" == "openvz" ]; then
    echo "OpenVZ virtualization is not supported"
    exit
fi

if [ "$(systemd-detect-virt)" == "lxc" ]; then
    echo "LXC virtualization is not supported."
    exit
fi

if [ ! -f "$WG_CONFIG" ]; then
    ### Install server and add default client
    INTERACTIVE=${INTERACTIVE:-yes}
    PRIVATE_SUBNET_V4=${PRIVATE_SUBNET_V4:-"10.8.0.0/24"}
    PRIVATE_SUBNET_MASK_V4=$( echo $PRIVATE_SUBNET_V4 | cut -d "/" -f 2 )
    GATEWAY_ADDRESS_V4="${PRIVATE_SUBNET_V4::-4}1"
    PRIVATE_SUBNET_V6=${PRIVATE_SUBNET_V6:-"fd42:42:42::0/64"}
    PRIVATE_SUBNET_MASK_V6=$( echo $PRIVATE_SUBNET_V6 | cut -d "/" -f 2 )
    GATEWAY_ADDRESS_V6="${PRIVATE_SUBNET_V6::-4}1"

    if [ "$SERVER_HOST_V4" == "" ]; then
        SERVER_HOST_V4="$(wget -O - -q https://v4.ident.me)"
        if [ "$INTERACTIVE" == "yes" ]; then
            read -p "Servers public IPV4 address is $SERVER_HOST_V4. Is that correct? [y/n]: " -e -i "y" CONFIRM
            if [ "$CONFIRM" == "n" ]; then
                echo "Aborted. Use environment variable SERVER_HOST_V4 to set the correct public IP address"
                exit
            fi
        fi
    fi
    
if [ "$SERVER_HOST_V6" == "" ]; then
        SERVER_HOST_V6="$(wget -O - -q https://v6.ident.me)"
        if [ "$INTERACTIVE" == "yes" ]; then
            read -p "Servers public IPV6 address is $SERVER_HOST_V6. Is that correct? [y/n]: " -e -i "y" CONFIRM
            if [ "$CONFIRM" == "n" ]; then
                echo "Aborted. Use environment variable SERVER_HOST_V6 to set the correct public IP address"
                exit
            fi
        fi
    fi

    	echo "What port do you want WireGuard to listen to?"
	echo "   1) Default: 51820"
	echo "   2) Custom"
	echo "   3) Random [2000-65535]"
	until [[ "$PORT_CHOICE" =~ ^[1-3]$ ]]; do
		read -rp "Port choice [1-3]: " -e -i 1 PORT_CHOICE
	done
	case $PORT_CHOICE in
		1)
			SERVER_PORT="51820"
		;;
		2)
			until [[ "$SERVER_PORT" =~ ^[0-9]+$ ]] && [ "$SERVER_PORT" -ge 1 ] && [ "$SERVER_PORT" -le 65535 ]; do
				read -rp "Custom port [1-65535]: " -e -i 51820 SERVER_PORT
			done
		;;
		3)
			# Generate random number within private ports range
			SERVER_PORT=$(shuf -i2000-65535 -n1)
			echo "Random Port: $SERVER_PORT"
		;;
	esac
	
    echo "Are you behind a firewall or NAT?"
    echo "   1) Yes"
    echo "   2) No"
    until [[ "$NAT_CHOICE" =~ ^[1-2]$ ]]; do
        read -rp "Nat Choice [1-2]: " -e -i 2 NAT_CHOICE
    done
    case $NAT_CHOICE in
        1)
            NAT_CHOICE="25"
        ;;
        2)
            NAT_CHOICE="0"
        ;;
    esac
 
    echo "What MTU do you want to use?"
    echo "   1) 1500"
    echo "   2) 1420"
    until [[ "$MTU_CHOICE" =~ ^[1-2]$ ]]; do
        read -rp "MTU Choice [1-2]: " -e -i 2 MTU_CHOICE
    done
    case $MTU_CHOICE in
        1)
            MTU_CHOICE="1500"
        ;;
        2)
            MTU_CHOICE="1420"
        ;;
    esac

    echo "What IPv do you want to connect via IPV4 or IPV6?"
    echo "   1) IPv4 (Recommended)"
    echo "   2) IPv6 (SOON)"
    until [[ "$SERVER_HOST" =~ ^[1-2]$ ]]; do
        read -rp "IP Choice [1-2]: " -e -i 1 SERVER_HOST
    done
    case $SERVER_HOST in
        1)
            SERVER_HOST="$SERVER_HOST_V4"
        ;;
        2)
            SERVER_HOST="$SERVER_HOST_V6"
        ;;
    esac
    
    echo "What IPv do you want to diable IPV4 or IPV6 on the server?"
    echo "   1) No (Recommended)"
    echo "   2) IPv4 (SOON)"
    echo "   3) IPv6"
    until [[ "$DISABLE_HOST" =~ ^[1-2]$ ]]; do
        read -rp "IP Choice [1-3]: " -e -i 1 DISABLE_HOST
    done
    case $DISABLE_HOST in
        1)
            DISABLE_HOST=""
        ;;
        2)
            DISABLE_HOST=""
        ;;
        3)
            DISABLE_HOST="net.ipv6.conf.all.disable_ipv6 = 1
	net.ipv6.conf.default.disable_ipv6 = 1
	net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf
	sysctl -w net.ipv6.conf.all.disable_ipv6=1
	sysctl -w net.ipv6.conf.default.disable_ipv6=1"
        ;;
    esac
    echo "What traffic do you want the client to forward to wireguard?"
    echo "   1) Everything"
    echo "   2) Exclude Private IPs"
    until [[ "$CLIENT_ALLOWED_IP" =~ ^[1-2]$ ]]; do
        read -rp "Client Allowed IP Choice [1-2]: " -e -i 1 CLIENT_ALLOWED_IP
    done
    case $CLIENT_ALLOWED_IP in
        1)
            CLIENT_ALLOWED_IP="0.0.0.0/0,::/0"
        ;;
        2)
            CLIENT_ALLOWED_IP="0.0.0.0/5,8.0.0.0/7,11.0.0.0/8,12.0.0.0/6,16.0.0.0/4,32.0.0.0/3,64.0.0.0/2,128.0.0.0/3,160.0.0.0/5,168.0.0.0/6,172.0.0.0/12,172.32.0.0/11,172.64.0.0/10,172.128.0.0/9,173.0.0.0/8,174.0.0.0/7,176.0.0.0/4,192.0.0.0/9,192.128.0.0/11,192.160.0.0/13,192.169.0.0/16,192.170.0.0/15,192.172.0.0/14,192.176.0.0/12,192.192.0.0/10,193.0.0.0/8,194.0.0.0/7,196.0.0.0/6,200.0.0.0/5,208.0.0.0/4,::/0,176.103.130.130/32,176.103.130.131/32"
        ;;
    esac
    
    if [ "$CLIENT_DNS" == "" ]; then
        echo "Which DNS do you want to use with the VPN?"
        echo "   1) Cloudflare"
        echo "   2) Google"
        echo "   3) OpenDNS"
        echo "   4) AdGuard"
        echo "   5) Verisign"
        echo "   6) Quad9"
        echo "   7) FDN"
        echo "   8) DNS.WATCH"
        echo "   9) Yandex Basic"
        echo "   10) Clean Browsing"
        read -p "DNS [1-10]: " -e -i 4 DNS_CHOICE

        case $DNS_CHOICE in
            1)
            CLIENT_DNS="1.1.1.1,1.0.0.1,2606:4700:4700::1111,2606:4700:4700::1001"
            ;;
            2)
            CLIENT_DNS="8.8.8.8,8.8.4.4,2001:4860:4860::8888,2001:4860:4860::8844"
            ;;
            3)
            CLIENT_DNS="208.67.222.222,208.67.220.220,2620:119:35::35,2620:119:53::53"
            ;;
            4)
            CLIENT_DNS="176.103.130.130,176.103.130.131,2a00:5a60::ad1:0ff,2a00:5a60::ad2:0ff"
            ;;
            5)
            CLIENT_DNS="64.6.64.6,64.6.65.6,2620:74:1b::1:1,2620:74:1c::2:2"
            ;;
            6)
            CLIENT_DNS="9.9.9.9,149.112.112.112,2620:fe::fe,2620:fe::9"
            ;;
            7)
            CLIENT_DNS="80.67.169.40,80.67.169.12,2001:910:800::40,2001:910:800::12"
            ;;
            8)
            CLIENT_DNS="84.200.69.80,84.200.70.40,2001:1608:10:25::1c04:b12f,2001:1608:10:25::9249:d69b"
            ;;
            9)
            CLIENT_DNS="77.88.8.8,77.88.8.1,2a02:6b8::feed:0ff,2a02:6b8:0:1::feed:0ff"
            ;;
            10)
            CLIENT_DNS="185.228.168.9,185.228.169.9,2a0d:2a00:1::2,2a0d:2a00:2::2"
            ;;
        esac
        
    fi

    if [ "$DISTRO" == "Ubuntu" ]; then
        apt-get update
        apt-get install software-properties-common -y
        add-apt-repository ppa:wireguard/wireguard -y
        apt-get update
        apt-get install wireguard qrencode iptables-persistent unattended-upgrades apt-listchanges haveged ntpdate linux-headers-$(uname -r) -y
        wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/ubuntu/50unattended-upgrades.Ubuntu"
	ntpdate pool.ntp.org
	
    elif [ "$DISTRO" == "Debian" ]; then
        echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
        printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable
        apt-get update
        apt-get install wireguard qrencode iptables-persistent unattended-upgrades apt-listchanges haveged ntpdate linux-headers-$(uname -r) -y
        wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/debian/50unattended-upgrades.Debian"
	ntpdate pool.ntp.org
	
    elif [ "$DISTRO" == "CentOS" ]; then
        curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
        yum install epel-release -y
        yum install wireguard-dkms qrencode wireguard-tools firewalld -y
    fi
    
    SERVER_PRIVKEY=$( wg genkey )
    SERVER_PUBKEY=$( echo $SERVER_PRIVKEY | wg pubkey )
    CLIENT_PRIVKEY=$( wg genkey )
    CLIENT_PUBKEY=$( echo $CLIENT_PRIVKEY | wg pubkey )
    CLIENT_ADDRESS_V4="${PRIVATE_SUBNET_V4::-4}3"
    CLIENT_ADDRESS_V6="${PRIVATE_SUBNET_V6::-4}3"

    mkdir -p /etc/wireguard
    touch $WG_CONFIG && chmod 600 $WG_CONFIG

    echo "# $PRIVATE_SUBNET_V4 $PRIVATE_SUBNET_V6 $SERVER_HOST:$SERVER_PORT $SERVER_PUBKEY $CLIENT_DNS $MTU_CHOICE $NAT_CHOICE $CLIENT_ALLOWED_IP
[Interface]
Address = $GATEWAY_ADDRESS_V4/$PRIVATE_SUBNET_MASK_V4,$GATEWAY_ADDRESS_V6/$PRIVATE_SUBNET_MASK_V6
ListenPort = $SERVER_PORT
PrivateKey = $SERVER_PRIVKEY
SaveConfig = false" > $WG_CONFIG

    echo "# client
[Peer]
PublicKey = $CLIENT_PUBKEY
AllowedIPs = $CLIENT_ADDRESS_V4/32,$CLIENT_ADDRESS_V6/128" >> $WG_CONFIG

    echo "[Interface]
PrivateKey = $CLIENT_PRIVKEY
Address = $CLIENT_ADDRESS_V4/$PRIVATE_SUBNET_MASK_V4,$CLIENT_ADDRESS_V6/$PRIVATE_SUBNET_MASK_V6
DNS = $CLIENT_DNS
MTU = $MTU_CHOICE
[Peer]
PublicKey = $SERVER_PUBKEY
AllowedIPs = $CLIENT_ALLOWED_IP
Endpoint = $SERVER_HOST:$SERVER_PORT
PersistentKeepalive = $NAT_CHOICE" > $HOME/client-wg0.conf
qrencode -t ansiutf8 -l L < $HOME/client-wg0.conf

    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
    sysctl -p

    if [ "$DISTRO" == "CentOS" ]; then
        systemctl start firewalld
        firewall-cmd --zone=public --add-port=$SERVER_PORT/udp
        firewall-cmd --zone=trusted --add-source=$PRIVATE_SUBNET_V4
	firewall-cmd --zone=trusted --add-source=$PRIVATE_SUBNET_V6
        firewall-cmd --permanent --zone=public --add-port=$SERVER_PORT/udp
        firewall-cmd --permanent --zone=trusted --add-source=$PRIVATE_SUBNET_V4
	firewall-cmd --permanent --zone=trusted --add-source=$PRIVATE_SUBNET_V6
        firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -s $PRIVATE_SUBNET_V4 ! -d $PRIVATE_SUBNET_V4 -j SNAT --to $SERVER_HOST
        firewall-cmd --direct --add-rule ipv6 nat POSTROUTING 0 -s $PRIVATE_SUBNET_V6 ! -d $PRIVATE_SUBNET_V6 -j SNAT --to $SERVER_HOST
        firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s $PRIVATE_SUBNET_V4 ! -d $PRIVATE_SUBNET_V4 -j SNAT --to $SERVER_HOST
        firewall-cmd --permanent --direct --add-rule ipv6 nat POSTROUTING 0 -s $PRIVATE_SUBNET_V6 ! -d $PRIVATE_SUBNET_V6 -j SNAT --to $SERVER_HOST
    else
        iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT	
        ip6tables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT	
        iptables -A FORWARD -m conntrack --ctstate NEW -s $PRIVATE_SUBNET_V4 -m policy --pol none --dir in -j ACCEPT	
        ip6tables -A FORWARD -m conntrack --ctstate NEW -s $PRIVATE_SUBNET_V6 -m policy --pol none --dir in -j ACCEPT	
        iptables -t nat -A POSTROUTING -s $PRIVATE_SUBNET_V4 -m policy --pol none --dir out -j MASQUERADE	
        ip6tables -t nat -A POSTROUTING -s $PRIVATE_SUBNET_V6 -m policy --pol none --dir out -j MASQUERADE	
        iptables -A INPUT -p udp --dport $SERVER_PORT -j ACCEPT
        ip6tables -A INPUT -p udp --dport $SERVER_PORT -j ACCEPT
        iptables-save > /etc/iptables/rules.v4	
    fi		

    systemctl enable wg-quick@wg0.service
    systemctl start wg-quick@wg0.service
    DISABLE_HOST
    
    echo "Client config --> $HOME/client-wg0.conf"
else
    ### Server is installed, add a new client
    CLIENT_NAME="$1"
    if [ "$CLIENT_NAME" == "" ]; then
        echo "Tell me a name for the client config file. Use one word only, no special characters."
        read -p "Client name: " -e CLIENT_NAME
    fi
    CLIENT_PRIVKEY=$( wg genkey )
    CLIENT_PUBKEY=$( echo $CLIENT_PRIVKEY | wg pubkey )
    PRIVATE_SUBNET_V4=$( head -n1 $WG_CONFIG | awk '{print $2}')
    PRIVATE_SUBNET_MASK_V4=$( echo $PRIVATE_SUBNET_V4 | cut -d "/" -f 2 )
    PRIVATE_SUBNET_V6=$( head -n1 $WG_CONFIG | awk '{print $3}')
    PRIVATE_SUBNET_MASK_V6=$( echo $PRIVATE_SUBNET_V6 | cut -d "/" -f 2 )
    SERVER_ENDPOINT=$( head -n1 $WG_CONFIG | awk '{print $4}')
    SERVER_PUBKEY=$( head -n1 $WG_CONFIG | awk '{print $5}')
    CLIENT_DNS=$( head -n1 $WG_CONFIG | awk '{print $6}')
    MTU_CHOICE=$( head -n1 $WG_CONFIG | awk '{print $7}')
    NAT_CHOICE=$( head -n1 $WG_CONFIG | awk '{print $8}')
    CLIENT_ALLOWED_IP=$( head -n1 $WG_CONFIG | awk '{print $9}')
    LASTIP4=$( grep "/32" $WG_CONFIG | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 )
    LASTIP6=$( grep "/128" $WG_CONFIG | tail -n1 | awk '{print $6}' | cut -d "/" -f 1 | cut -d "." -f 4 )
    CLIENT_ADDRESS_V4="${PRIVATE_SUBNET_V4::-4}$((LASTIP4+1))"
    CLIENT_ADDRESS_V6="${PRIVATE_SUBNET_V6::-4}$((LASTIP4+1))"
    echo "# $CLIENT_NAME
[Peer]
PublicKey = $CLIENT_PUBKEY
AllowedIPs = $CLIENT_ADDRESS_V4/32, $CLIENT_ADDRESS_V6/128" >> $WG_CONFIG

    echo "[Interface]
PrivateKey = $CLIENT_PRIVKEY
Address = $CLIENT_ADDRESS_V4/$PRIVATE_SUBNET_MASK_V4, $CLIENT_ADDRESS_V6/$PRIVATE_SUBNET_MASK_V6
DNS = $CLIENT_DNS
MTU = $MTU_CHOICE
[Peer]
PublicKey = $SERVER_PUBKEY
AllowedIPs = $CLIENT_ALLOWED_IP
Endpoint = $SERVER_ENDPOINT
PersistentKeepalive = $NAT_CHOICE" > $HOME/$CLIENT_NAME-wg0.conf
qrencode -t ansiutf8 -l L < $HOME/$CLIENT_NAME-wg0.conf

    ip address | grep -q wg0 && wg set wg0 peer "$CLIENT_PUBKEY" allowed-ips "$CLIENT_ADDRESS_V4/32 , $CLIENT_ADDRESS_V6/64"
    echo "Client added, new configuration file --> $HOME/$CLIENT_NAME-wg0.conf"
fi
