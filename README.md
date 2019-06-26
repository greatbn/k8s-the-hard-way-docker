#### Install Kubernetes the hard way with Docker

I will install Kubernetes with docker that means every service of k8s will run inside docker container.

I use docker-compose for simple provision and manage docker containers.


##### Requirements

- Installed Docker: https://docs.docker.com/install/

- Installed Docker-compose: https://github.com/docker/compose/releases

- Installed CFSSL in Master Node

```
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

```
##### Generate Cert for Master Node 

##### Generate Cert for Worker Node

##### Copy Cert to Worker Node

##### Run Control Node

##### Run Worker Node
