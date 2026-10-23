#!/usr/bin/env bash
set -Eeuo pipefail
(( EUID == 0 )) || { echo 'Jalankan sudo bash setup.sh'; exit 1; }
HERE="$(cd "$(dirname "$0")" && pwd)"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl openssl nmap tcpdump tshark wireshark-common ca-certificates python3
sed -i '/[[:space:]]arsip.sibertaruna.my.id$/d' /etc/hosts
printf '%s %s\n' '192.168.36.214' 'arsip.sibertaruna.my.id' >> /etc/hosts
install -m 755 "$HERE/validate.sh" /usr/local/bin/sslctf-validate
cat > /usr/local/bin/sslctf-info <<'INFO'
#!/usr/bin/env bash
echo 'WEB-04 | Portal Arsip Dokumen'
echo 'Target arsip.sibertaruna.my.id (192.168.36.214); Kali 192.168.36.229'
echo 'Username dummy: arsip_demo_04'
echo 'Password dummy: Simulasi-04!'
echo 'Urutan: capture HTTP -> login HTTP -> evaluasi flag 1-2 -> instalasi HTTPS Lighttpd -> scan TLS -> hardening -> capture HTTPS -> validasi flag 3-10.'
echo 'Evidence: ~/sslctf-evidence/before.pcap, after.pcap, nmap-tls.txt'
INFO
chmod +x /usr/local/bin/sslctf-info
install -d -m 755 /etc/sslctf
echo '04' > /etc/sslctf/lab
echo 'Instalasi Kali selesai. Sebagai USER biasa: mkdir -p ~/sslctf-evidence; sslctf-info'
