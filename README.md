# Minimal Linux Docker container for use as an SSH bastion

## Usage

Create an `authorized_keys` file with all public keys that can connect to this bastion. Make the file publicly readable or the user in the docker will not have the permission to read it.

	chmod a+r authorized_keys

Put the options you want in a `sshd_config` file. Suggested options for a bastion are in the `sshd_config.bastion` file in this repo

Change the port to match the one specified in your `sshd_config` then run the following command to start the bastion. 

	docker run --name bastion -d --restart=always -v $(pwd)/authorized_keys:/home/dev/.ssh/authorized_keys:ro -v $(pwd)/sshd_config:/etc/ssh/sshd_config:ro -p 9022:9022 nfugal/bastion

I prefer to use the bastion with the [ProxyJump](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump) directive in a client's `.ssh/config` file. Much less typing than specifying things every single time.

## Security

The bastion does not utilize a firewall itself. Take care of that another way, on the host, at the edge, etc.

Users can't do much on the bastion after hardening. I'm happy to incorporate suggestions for making this better.

## To build the image yourself

Run the following commands to build the docker image before running `docker run`

	git clone https://github.com/nfugal/bastion.git
	docker build -t nfugal/bastion bastion

## Credits

Thanks to [chentmin](https://github.com/chentmin/bastion) for the original work.

This bastion is based on [Alpine](https://hub.docker.com/_/alpine/) Linux 3.

Security harden script is modified based on [this](https://github.com/gliderlabs/docker-alpine/issues/56#issuecomment-125777140)
