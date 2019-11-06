export DEBIAN_FRONTEND=noninteractive
# Startup commands for host-c
sudo apt-get update
sudo apt -y install docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo docker pull dustnic82/nginx-test
sudo docker run -d -p 80:80 dustnic82/nginx-test

sudo ip a add 192.168.6.10/23 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 10.0.0.0/30 via 192.168.6.1     
sudo ip route add 192.168.0.0/21 via 192.168.6.1  
