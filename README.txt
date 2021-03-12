Create server config:

main dir = tinc

mkdir tinc/netname/hosts

touch tinc/netname/tinc.conf
cat <<EOT >> tinc/netname/tinc.conf
Name = server
AddressFamily = ipv4
Interface = tun0
EOT

touch tinc/netname/hosts/server
cat <<EOT >> tinc/netname/hosts/server
Address = 1.2.3.4
Subnet = 10.0.0.1/32
EOT

sudo tincd -n netname -K4096 # generate public/private keys (use docker to do this) default locations
docker run --rm -it -v $PWD/tinc/netname:/etc/tinc/netname -w /etc/tinc/netname hallbregg/tinc:latest tincd -n netname -K4096

touch tinc/netname/tinc-up
cat <<EOT >> tinc/netname/tinc-up
#!/bin/sh
ip link set $INTERFACE up
ip addr add 10.0.0.1/32 dev $INTERFACE
ip route add 10.0.0.0/24 dev $INTERFACE
EOT


touch tinc/netname/tinc-down
cat <<EOT >> tinc/netname/tinc-down
#!/bin/sh
ip route del 10.0.0.0/24 dev $INTERFACE
ip addr del 10.0.0.1/32 dev $INTERFACE
ip link set $INTERFACE down

sudo chmod 755 tinc/netname/tinc-*

sudo ufw allow 655



Create client configuration:

main dir = tinc

mkdir tinc/netname/hosts

touch tinc/netname/tinc.conf
cat <<EOT >> tinc/netname/tinc.conf
Name = client
AddressFamily = ipv4
Interface = tun0
ConnectTo = server
EOT

touch tinc/netname/hosts/client
cat <<EOT >> tinc/netname/hosts/client
Subnet = 10.0.0.2/32
EOT

sudo tincd -n netname -K4096 # generate public/private keys (use docker to do this) default locations

touch tinc/netname/tinc-up
cat <<EOT >> tinc/netname/tinc-up
#!/bin/sh
ip link set $INTERFACE up
ip addr add 10.0.0.2/32 dev $INTERFACE
ip route add 10.0.0.0/24 dev $INTERFACE
EOT


touch tinc/netname/tinc-down
cat <<EOT >> tinc/netname/tinc-down
#!/bin/sh
ip route del 10.0.0.0/24 dev $INTERFACE
ip addr del 10.0.0.2/32 dev $INTERFACE
ip link set $INTERFACE down

sudo chmod 755 tinc/netname/tinc-*

sudo ufw allow 655

Copy hosts:

Share hosts folder between all parts. Each part should have the same hosts folder. (Each part may change for eg. server's address etc if needed)


Start:
	First server then clients:
		sudo tincd -n netname -D -d3

