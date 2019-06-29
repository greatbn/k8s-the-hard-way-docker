#!/bin/bash

if [ -z "${myip}" ]; then
        myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
fi

cat >  docker-compose.yml <<EOF
version: "2"
services:
  etcd1:
    image: rancher/coreos-etcd:v3.2.24-rancher1
    network_mode: host
    entrypoint: ["sh", "/etc/etcd/etcd.sh"]
    volumes:
      - /etc/etcd/etcd.sh:/etc/etcd/etcd.sh
      - /etc/kubernetes:/etc/kubernetes:z
      - /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt
  kube-apiserver:
    image: gcr.io/google_containers/hyperkube:v1.12.0
    network_mode: host
    entrypoint: ["kube-apiserver",
      "--advertise-address=$myip",
      "--allow-privileged=true",
      "--apiserver-count=3",
      "--audit-log-maxage=30", 
      "--audit-log-maxbackup=3", 
      "--audit-log-maxsize=100",
      "--audit-log-path=/var/log/audit.log",
      "--authorization-mode=Node,RBAC",
      "--bind-address=0.0.0.0",
      "--client-ca-file=/etc/kubernetes/certs/ca.crt",
      "--enable-admission-plugins=Initializers,NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota",
      "--enable-swagger-ui=true",
      "--etcd-cafile=/etc/kubernetes/certs/ca.crt",
      "--etcd-certfile=/etc/kubernetes/certs/server.crt",
      "--etcd-keyfile=/etc/kubernetes/certs/server.key",
      "--etcd-servers=https://$myip:2379",
      "--event-ttl=1h",
      "--experimental-encryption-provider-config=/etc/kubernetes/encryption-config.yaml",
      "--kubelet-certificate-authority=/etc/kubernetes/certs/ca.crt",
      "--kubelet-client-certificate=/etc/kubernetes/certs/server.crt",
      "--kubelet-client-key=/etc/kubernetes/certs/server.key",
      "--kubelet-https=true",
      "--runtime-config=api/all",
      "--service-account-key-file=/etc/kubernetes/certs/service-account.key",
      "--service-cluster-ip-range=10.32.0.0/24",
      "--service-node-port-range=30000-32767",
      "--tls-cert-file=/etc/kubernetes/certs/server.crt",
      "--tls-private-key-file=/etc/kubernetes/certs/server.key",
      "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
      "--v=2"]
    ports:
       - 6443:6443
    volumes:
      - /etc/kubernetes/certs/:/etc/kubernetes/certs/
      - /etc/kubernetes/:/etc/kubernetes/
  kube-controller-manager:
    image: gcr.io/google_containers/hyperkube:v1.12.0
    network_mode: host
    entrypoint: [ "kube-controller-manager",
      "--address=0.0.0.0",
      "--cluster-cidr=10.200.0.0/16",
      "--cluster-name=kubernetes",
      "--kubeconfig=/etc/kubernetes/kube-controller-manager.kubeconfig",
      "--leader-elect=true",
      "--root-ca-file=/etc/kubernetes/certs/ca.crt",
      "--service-account-private-key-file=/etc/kubernetes/certs/service-account.key",
      "--service-cluster-ip-range=10.32.0.0/24",
      "--use-service-account-credentials=true",
      "--v=2"]
    volumes:
      - /etc/kubernetes/certs/:/etc/kubernetes/certs/
      - /etc/kubernetes/:/etc/kubernetes/
  kube-scheduler:
    image: gcr.io/google_containers/hyperkube:v1.12.0
    network_mode: host
    entrypoint: ["kube-scheduler", "--config=/etc/kubernetes/kube-scheduler.yaml", "--v=2"]
    volumes:
     - /etc/kubernetes/certs/:/etc/kubernetes/certs/
     - /etc/kubernetes/:/etc/kubernetes/
EOF
