
apt install wireguard

wg genkey | tee /etc/wireguard/private.key

chmod go= /etc/wireguard/private.key

cat /etc/wireguard/private.key | wg pubkey | tee /etc/wireguard/public.key

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p

cat <<EOT >> /etc/wireguard/wg0.conf
[Interface]
PrivateKey = <private_key>
Address = <ip>/24
ListenPort = <port>
SaveConfig = true

PostUp = iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
PreDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOT

systemctl enable wg-quick@wg0.service
