myip="10.20.165.21"
protocol="https"
ETCD_DISCOVERY_URL="https://discovery.etcd.io/9d5ff9a89c39c63b40f3d28201520d34"
cert_dir="/etc/kubernetes/certs"

cat > /etc/etcd/etcd.conf <<EOF
ETCD_NAME="$myip"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="$protocol://$myip:2379,http://127.0.0.1:2379"
ETCD_LISTEN_PEER_URLS="$protocol://$myip:2380"
ETCD_ADVERTISE_CLIENT_URLS="$protocol://$myip:2379,http://127.0.0.1:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="$protocol://$myip:2380"
ETCD_DISCOVERY="$ETCD_DISCOVERY_URL"
ETCD_CA_FILE=$cert_dir/ca.crt
ETCD_TRUSTED_CA_FILE=$cert_dir/ca.crt
ETCD_CERT_FILE=$cert_dir/server.crt
ETCD_KEY_FILE=$cert_dir/server.key
ETCD_CLIENT_CERT_AUTH=true
ETCD_PEER_CA_FILE=$cert_dir/ca.crt
ETCD_PEER_TRUSTED_CA_FILE=$cert_dir/ca.crt
ETCD_PEER_CERT_FILE=$cert_dir/server.crt
ETCD_PEER_KEY_FILE=$cert_dir/server.key
ETCD_PEER_CLIENT_CERT_AUTH=true
EOF


