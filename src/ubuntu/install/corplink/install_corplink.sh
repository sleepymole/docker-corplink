#!/usr/bin/env bash
set -ex

apt update
apt install supervisor privoxy jq -y
sed -i '/^listen-address/d' /etc/privoxy/config
echo 'listen-address 0.0.0.0:8118' >>/etc/privoxy/config

# Corplink service
mkdir -p /var/log/corplink/
cat <<EOF >/etc/supervisor/conf.d/corplink.conf
[program:corplink]
command=/opt/apps/com.volcengine.feilian/files/corplink-service
autostart=true
autorestart=true
stderr_logfile=/var/log/corplink/stderr.log
stdout_logfile=/var/log/corplink/stdout.log
EOF

# Privoxy
mkdir -p /var/log/privoxy
cat <<EOF >/etc/supervisor/conf.d/privoxy.conf
[program:privoxy]
command=/usr/sbin/privoxy --no-daemon /etc/privoxy/config
autostart=true
autorestart=true
stderr_logfile=/var/log/privoxy/stderr.log
stdout_logfile=/var/log/privoxy/stdout.log
EOF

# Socks5 server
mkdir -p /var/log/socks5/
cat <<EOF >/etc/supervisor/conf.d/socks5.conf
[program:socks5]
command=/usr/local/bin/socks5
autostart=true
autorestart=true
stderr_logfile=/var/log/socks5/stderr.log
stdout_logfile=/var/log/socks5/stdout.log
EOF

# Automatic fix dns
cat <<EOF >/usr/local/bin/fixdns.sh
#!/bin/bash
set -x
while true; do
  sleep 5
  dns=\$(jq -r '.DNS[0]' /opt/apps/com.volcengine.feilian/files/vpn.conf 2>/dev/null)
  [ -z "\$dns" ] && continue
  grep -q "\$dns" /etc/resolv.conf && continue
  echo "nameserver \${dns}" >/etc/resolv.conf
done
EOF
chmod +x /usr/local/bin/fixdns.sh
mkdir -p /var/log/fixdns/
cat <<EOF >/etc/supervisor/conf.d/fixdns.conf
[program:fixdns]
command=/usr/local/bin/fixdns.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/fixdns/stderr.log
stdout_logfile=/var/log/fixdns/stdout.log
EOF

if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then
  wget -q -O corplink.deb https://cdn.isealsuite.com/linux/FeiLian_Linux_arm64_v3.0.24_r5980_d44583.deb
else
  wget -q -O corplink.deb https://cdn.isealsuite.com/linux/FeiLian_Linux_amd64_v3.0.24_r5980_6ebb49.deb
fi
apt install ./corplink.deb -y
rm corplink.deb
cp /usr/share/applications/corplink.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/corplink.desktop
