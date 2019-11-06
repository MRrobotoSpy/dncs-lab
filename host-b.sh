# Startup commands for host-b
sudo ip a add 192.168.3.10/25 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.0.0/21 via 192.168.3.1  
sudo ip route add 10.0.0.0/30 via 192.168.3.1    
