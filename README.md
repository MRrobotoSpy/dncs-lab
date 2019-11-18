
### Index
- [DNCS-LAB](#dncs-lab)
- [Requirements](#requirements)
- [How-to](#how-to)
- [Assignment](#assignment)
  - [Design Requirements](#design-requirements)
  - [Tasks](#tasks)
- [Notes and References](#notes-and-references)
- [Design](#design)
- [Vlan](#vlan)
- [IP Device/Ports](#ip-deviceports)
- [Code](#code)
  - [Router-1](#router-1)
  - [Router-2](#router-2)
  - [Switch](#switch)
  - [Host-a](#host-a)
  - [Host-b](#host-b)
  - [Host-c](#host-c)
- [Test](#test)
  - [Key commands](#key-commands)
  - [Example:](#example)
    - [vagrant ssh](#vagrant-ssh)
    - [ping](#ping)
    - [ip address show](#ip-address-show)
    - [curl](#curl)









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


# Vlan 

I set up 2 Virtual-LAN between the router-1 and the switch with the following id: 

| VLAN ID | Subnet ID |
| ------- | --------- |
| 1       | A         |
| 2       | B         |




<br/><br/>




# IP Device/Ports



| Device   | eth1            | eth2        | Subnet |
| -------- | --------------- | ----------- | ------ |
| Router-2 | 192.168.6.1/23  | 10.0.0.2/30 | C-D    |
| Host-a   | 192.168.0.10/23 |             | A      |
| Host-b   | 192.168.3.10/25 |             | B      |
| Host-c   | 192.168.6.10/23 |             | C      |

<br/><br/>




| Device   | eth1.1         | eth1.2         | eth2        | Subnet |
| -------- | -------------- | -------------- | ----------- | ------ |
| Router-1 | 192.168.0.1/23 | 192.168.3.1/25 | 10.0.0.1/30 | A-B-D  |


<br/><br/>
# Code
  
  ## Router-1 
```scala

1|sudo sysctl -w net.ipv4.ip_forward=1

2|sudo ip a add 10.0.0.1/30  dev enp0s9
3|sudo ip link set dev enp0s9 up

4|sudo ip link add link enp0s8 name enp0s8.1 type vlan id 1
5|sudo ip addr add 192.168.0.1/23  dev enp0s8.1
6|sudo ip link set enp0s8.1 up

7|sudo ip link set enp0s8 up

8|sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2
9|sudo ip link set enp0s8.2 up
10|sudo ip addr add 192.168.3.1/25 dev enp0s8.2


11|sudo ip route add 192.168.6.0/23 via 10.0.0.2 
```

 line 1  Enables IP Forwarding (By default any modern Linux distributions will have IP Forwarding disabled.)
 <br/>
 line 2   Assigns the IP address to the interface enp0s9
 <br/>
 line 3  Enables Network Interface enp0s9
 <br/>
 line 4 Creates and link the VLAN 1 to enp0s8.1
 <br/>
 line 5   Assigns the IP address to the interface enp0s8.1
 <br/>
 line 6 Enables Network Interface enp0s8.1
 <br/>
 line 7 Enables Network Interface enp0s8
 <br/>
 line 8   Creates and link the VLAN 2 to enp0s8.2
 <br/>
 line 9   Enables Network Interface enp0s8.2
 <br/>
 line 10    Assigns the IP address to the interface enp0s8.2
 <br/>
 line 11 Set up route to Host-c


 <br/><br/> 
  ## Router-2

```scala
1|sudo sysctl -w net.ipv4.ip_forward=1

2|sudo ip a add 10.0.0.2/30  dev enp0s9
3|sudo ip link set dev enp0s9 up

4|sudo ip a add 192.168.6.1/23 dev enp0s8
5|sudo ip link set dev enp0s8 up


6|sudo ip route add 192.168.0.0/22 via 10.0.0.1

```

 line 1  Enables IP Forwarding (By default any modern Linux distributions will have IP Forwarding disabled.)
 <br/>
 line 2   Assigns the IP address to the interface enp0s9
 <br/>
 line 3  Enables Network Interface enp0s9
 <br/>
 line 4  Assigns the IP address to the interface enp0s8
 <br/>
 line 5  Enables Network Interface enp0s8
 <br/>
 line 6 Set up route to Host-a and Host-b



 <br/><br/>

  ## Switch
```scala
1|export DEBIAN_FRONTEND=noninteractive
2|apt-get update
3|apt-get install -y tcpdump
4|apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common



5|sudo ovs-vsctl add-br switch   
6|sudo ovs-vsctl add-port switch enp0s8
7|sudo ovs-vsctl add-port switch enp0s9 tag=1
8|sudo ovs-vsctl add-port switch enp0s10 tag=2

9|sudo ip link set dev enp0s8 up
10|sudo ip link set dev enp0s9 up
11|sudo ip link set dev enp0s10 up

```

line 1 to 4 install library and get update
 <br/>
 line 5 Creates a bridge in the switch database
 <br/>
 line 6 Binds an interface (physical or virtual) to a bridge
 <br/>
 line 7 Converts port to an access port on VLAN 1
 <br/>
 line 8 Converts port to an access port on VLAN 2
 <br/>
 line 9 Enables Network Interface enp0s8
 <br/>
 line 10 Enables Network Interface enp0s9
<br/>
 line 11 Enables Network Interface enp0s10



 <br/><br/>
  ## Host-a
```scala
1| sudo ip a add 192.168.0.10/23  dev enp0s8
2| sudo ip link set dev enp0s8 up
3| sudo ip route add 192.168.0.0/21 via 192.168.0.1 
4| sudo ip route add 10.0.0.0/30 via 192.168.0.1    
```
 line 1 Assigns the IP address to the interface enp0s8
 <br/>
 line 2 Enables Network Interface enp0s8
 <br/>
 line 3 Adds a new route to all hosts including itˈself 
 <br/>
 line 4 Adds a new route to routers 



 <br/><br/> 
  ## Host-b
```scala
1|sudo ip a add 192.168.3.10/25 dev enp0s8
2|sudo ip link set dev enp0s8 up
3|sudo ip route add 192.168.0.0/21 via 192.168.3.1  
4|sudo ip route add 10.0.0.0/30 via 192.168.3.1    
```

 line 1 Assigns the IP address to the interface enp0s8
 <br/>
 line 2 Enables Network Interface enp0s8
 <br/>
 line 3 Adds a new route to all hosts including itˈself 
 <br/>
 line 4 Adds a new route to routers 





 <br/><br/>
  ## Host-c
```scala
1|sudo apt-get update
2|sudo apt -y install docker.io
3|sudo systemctl start docker
4|sudo systemctl enable docker

5|sudo docker pull dustnic82/nginx-test
6|sudo docker run -d -p 80:80 dustnic82/nginx-test

7|sudo ip a add 192.168.6.10/23 dev enp0s8
8|sudo ip link set dev enp0s8 up
9|sudo ip route add 10.0.0.0/30 via 192.168.6.1     
10|sudo ip route add 192.168.0.0/21 via 192.168.6.1  
```
line 1 installs the updates
 <br/>
line 2 installs docker.io 
 <br/>
line 3 starts docker
 <br/>
line 4 enables docker
 <br/>
line 5 pulls the docker image dustnic82/nginx-test 
 <br/>
line 6 run the image dustnic82/nginx-test
 <br/>
line 7 Assigns the IP address to the interface enp0s8
 <br/>
line 8 Enables Network Interface enp0s8
 <br/>
line 9 Adds a new route to routers 
 <br/>
line 10 Adds a new route to all hosts including itˈself 
  <br/>
Note:
 <br/>
In the Vagrantfile i had to increase the virtual memory from 256 to 512 in order to install docker.io

# Test
## Key commands 
- vagrant up ( To boot the project)
- vagrant shh <device> (To switch to the desired machine)
- ping <port> (To test the connection between 2 machines)
- ip address show (show all IP addresses associated)
- curl <port> (To test the docker)


## Example: 


### vagrant ssh 

This will SSH into a running Vagrant machine and give you access to a shell.



```scala
vagrant ssh host-a

Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-66-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Nov 18 11:04:28 UTC 2019

  System load:  0.11              Processes:             87
  Usage of /:   10.0% of 9.63GB   Users logged in:       0
  Memory usage: 49%               IP address for enp0s3: 10.0.2.15
  Swap usage:   0%                IP address for enp0s8: 192.168.0.10


0 packages can be updated.
0 updates are security updates.
```

vagrant@host-a:~$ exit 

To logout from the machine




### ping 

Ping is a computer network administration software utility used to test the reachability of a host on an Internet Protocol (IP) network.


```scala
vagrant@host-a:~$ ping 10.0.0.1

PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=1.26 ms
64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=1.04 ms
64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.680 ms
64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.555 ms
^C
--- 10.0.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
```
The output test the reachability of the router-1 from the host-a 


### ip address show 

This option is used to show all IP addresses associated on all network devices.

```scala
vagrant@host-a:~$ ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:c7:16:cf:84:50 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 84060sec preferred_lft 84060sec
    inet6 fe80::c7:16ff:fecf:8450/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ec:92:1b brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.10/23 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feec:921b/64 scope link
       valid_lft forever preferred_lft forever
```

### curl

To test if the nginx web server is successfully installed and working

```scala
vagrant@host-a:~$ curl 192.168.6.10
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```