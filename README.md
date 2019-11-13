

- [DNCS-LAB](#dncs-lab)
- [Requirements](#requirements)
- [How-to](#how-to)
- [Assignment](#assignment)
  - [Design Requirements](#design-requirements)
  - [Tasks](#tasks)
- [Notes and References](#notes-and-references)
- [Design](#design)
- [IP Device/Ports](#ip-deviceports)
- [Code](#code)
  - [Router-1](#router-1)
  - [Router-2](#router-2)
  - [Switch](#switch)
  - [Host-a](#host-a)
  - [Host-b](#host-b)
  - [Host-c](#host-c)









# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 345 and 75 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 453 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

![Schema](https://github.com/MRrobotoSpy/dncs-lab/blob/master/SchemaProgetto.png)



The network is splitted in 4 parts:

* A : The Subnet  192.168.0.0/23 can cover up to 2<sup>9</sup>-2 = 510 address where the required is 345.
* B : The Subnet  192.168.3.0/25 can cover up to 2<sup>7</sup>-2  = 126 address  where the required is 75.
* C : The Subnet  192.168.6.0/23 can cover up to 2<sup>9</sup>-2  = 510 address where the required is 453.
* D : The Subnet  10.0.0.0/30    can cover up to 2<sup>2</sup>-2  =  2  address where the required is 2.


<br/>


| Subnet ID | Interface                           | Address     | Netmask              | HostMin     | HostMax       | Address requested | Address Provided       | Free Address |
| --------- | ----------------------------------- | ----------- | -------------------- | ----------- | ------------- | ----------------- | ---------------------- | ------------ |
| A         | Host-a (eth1)<br/>Router-1 (eth1.1) | 192.168.0.0 | 255.255.254.0 = 23   | 192.168.0.1 | 192.168.1.254 | 345               | 2<sup>9</sup>-2  = 510 | 165          |
| B         | Host-b (eth1)<br/>Router-1 (eth1.2) | 192.168.3.0 | 255.255.255.128 = 25 | 192.168.3.1 | 192.168.3.126 | 75                | 2<sup>7</sup>-2 = 126  | 51           |
| C         | Host-c (eth1)<br/>Router-2 (eth1)   | 192.168.6.0 | 255.255.254.0 = 23   | 192.168.6.1 | 192.168.7.254 | 453               | 2<sup>9</sup>-2  = 510 | 57           |
| D         | Router-1 (eth2)<br/>Router-2 (eth2) | 10.0.0.0    | 255.255.255.252 = 30 | 10.0.0.1    | 10.0.0.2      | 2                 | 2<sup>2</sup>-2  =  2  | 0            |



<br/><br/><br/>

# IP Device/Ports



| Device   | eth1            | eth2        | Subnet |
| -------- | --------------- | ----------- | ------ |
| Router-2 | 192.168.6.1/23  | 10.0.0.2/30 | C-D    |
| Host-a   | 192.168.0.10/23 |             | A      |
| Host-b   | 192.168.3.10/25 |             | B      |
| Host-c   | 192.168.6.10/23 |             | C      |

<br/><br/><br/>




| Device   | eth1.1         | eth1.2         | eth2        | Subnet |
| -------- | -------------- | -------------- | ----------- | ------ |
| Router-1 | 192.168.0.1/23 | 192.168.3.1/25 | 10.0.0.1/30 | A-B-D  |



# Code
  
  ## Router-1 
```scala

sudo sysctl -w net.ipv4.ip_forward=1

sudo ip a add 10.0.0.1/30  dev enp0s9
sudo ip link set dev enp0s9 up

sudo ip link add link enp0s8 name enp0s8.1 type vlan id 10
sudo ip addr add 192.168.0.1/23  dev enp0s8.1
sudo ip link set enp0s8.1 up

sudo ip link set enp0s8 up

sudo ip link add link enp0s8 name enp0s8.2 type vlan id 20
sudo ip link set enp0s8.2 up
sudo ip addr add 192.168.3.1/25 dev enp0s8.2


sudo ip route add 192.168.6.0/23 via 10.0.0.2 
```


  ## Router-2

```scala
sudo sysctl -w net.ipv4.ip_forward=1

sudo ip a add 10.0.0.2/30  dev enp0s9
sudo ip link set dev enp0s9 up

sudo ip a add 192.168.6.1/23 dev enp0s8
sudo ip link set dev enp0s8 up


sudo ip route add 192.168.0.0/22 via 10.0.0.1

```


  ## Switch
```scala
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common



sudo ovs-vsctl add-br switch   
sudo ovs-vsctl add-port switch enp0s8
sudo ovs-vsctl add-port switch enp0s9 tag=10
sudo ovs-vsctl add-port switch enp0s10 tag=20

sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up
sudo ip link set dev enp0s10 up

```



  ## Host-a
```scala
1| sudo ip a add 192.168.0.10/23  dev enp0s8
2| sudo ip link set dev enp0s8 up
3| sudo ip route add 192.168.0.0/21 via 192.168.0.1 
4| sudo ip route add 10.0.0.0/30 via 192.168.0.1    
```
  ## Host-b
```scala
sudo ip a add 192.168.3.10/25 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.0.0/21 via 192.168.3.1  
sudo ip route add 10.0.0.0/30 via 192.168.3.1    
```



  ## Host-c
```scala
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
```

 









