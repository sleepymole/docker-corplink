#!/usr/bin/env bash
set -ex

apt update
apt install supervisor privoxy -y
sed -i '/^listen-address/d' /etc/privoxy/config
echo 'listen-address 0.0.0.0:8118' >>/etc/privoxy/config
mkdir -p /var/log/corplink/ /var/log/privoxy/
cat <<EOF >/etc/supervisor/conf.d/corplink.conf
[program:corplink]
command=/opt/Corplink/corplink-service
autostart=true
autorestart=true
stderr_logfile=/var/log/corplink/stderr.log
stdout_logfile=/var/log/corplink/stdout.log
EOF
cat <<EOF >/etc/supervisor/conf.d/privoxy.conf
[program:privoxy]
command=/usr/sbin/privoxy --no-daemon /etc/privoxy/config
autostart=true
autorestart=true
stderr_logfile=/var/log/privoxy/stderr.log
stdout_logfile=/var/log/privoxy/stdout.log
EOF

wget -q -O corplink.deb https://oss-s3.ifeilian.com/linux/FeiLian_Linux_v2.0.9_r615_97b98b.deb
apt install ./corplink.deb -y
rm corplink.deb
cp /usr/share/applications/corplink.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/corplink.desktop
