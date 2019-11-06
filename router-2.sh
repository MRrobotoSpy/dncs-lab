# Startup commands for router-2:

sudo sysctl -w net.ipv4.ip_forward=1

sudo ip a add 10.0.0.2/30  dev enp0s9
sudo ip link set dev enp0s9 up

sudo ip a add 192.168.6.1/23 dev enp0s8
sudo ip link set dev enp0s8 up


sudo ip route add 192.168.0.0/22 via 10.0.0.1
