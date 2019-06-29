
if [ -z "${myip}" ]; then
	myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
fi

protocol="https"
ETCD_DISCOVERY_URL="https://discovery.etcd.io/1ad09a306ba12df345df766b4b7e1feb"
cert_dir="/etc/kubernetes/certs"

mkdir -p /etc/etcd/

cat > /etc/etcd/etcd.sh <<EOF
export ETCD_NAME="$myip"
export ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
export ETCD_LISTEN_CLIENT_URLS="$protocol://$myip:2379,http://127.0.0.1:2379"
export ETCD_LISTEN_PEER_URLS="$protocol://$myip:2380"
export ETCD_ADVERTISE_CLIENT_URLS="$protocol://$myip:2379,http://127.0.0.1:2379"
export ETCD_INITIAL_ADVERTISE_PEER_URLS="$protocol://$myip:2380"
export ETCD_DISCOVERY="$ETCD_DISCOVERY_URL"
export ETCD_CA_FILE=$cert_dir/ca.crt
export ETCD_TRUSTED_CA_FILE=$cert_dir/ca.crt
export ETCD_CERT_FILE=$cert_dir/server.crt
export ETCD_KEY_FILE=$cert_dir/server.key
export ETCD_CLIENT_CERT_AUTH=true
export ETCD_PEER_CA_FILE=$cert_dir/ca.crt
export ETCD_PEER_TRUSTED_CA_FILE=$cert_dir/ca.crt
export ETCD_PEER_CERT_FILE=$cert_dir/server.crt
export ETCD_PEER_KEY_FILE=$cert_dir/server.key
export ETCD_PEER_CLIENT_CERT_AUTH=true
etcd
EOF


