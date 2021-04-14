# SSH bastion via Docker container

## Usage

Create an `authorized_keys` file and add the public keys you wish to use for this bastion. Make the file publicly readable or the user in the docker will not be able to read it.

	chmod a+r authorized_keys

Put the options you want in an `sshd_config` file. Suggested options are in the `sshd_config.bastion` file in this repo.

Change the port to match the one specified in your `sshd_config` then run the following command to start the bastion.

	docker run --name bastion -d --restart=always -v $(pwd)/authorized_keys:/home/dev/.ssh/authorized_keys:ro -v $(pwd)/sshd_config:/etc/ssh/sshd_config:ro -p 9022:9022 nfugal/bastion

I prefer to use the bastion with the [ProxyJump](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump) directive in a client's `.ssh/config` file. Much less typing than specifying things every single time.

## Security

The bastion does not utilize a firewall itself. Take care of that another way, on the Docker host, at the edge, etc.

Users can't do much on the bastion after hardening. If you see a way to improve the hardness, let me know.

## Build the image yourself

You can build the image yourself with the following commands:

	git clone https://github.com/nfugal/bastion.git
	docker build -t nfugal/bastion bastion

With that done, you can use the `docker run` command above.

## Credits

Thanks to [chentmin](https://github.com/chentmin/bastion) for the original work. My version relies heavily on theirs.

This bastion is based on [Alpine Linux v3](https://hub.docker.com/_/alpine/).

Security harden script is based on and modified from [this](https://github.com/gliderlabs/docker-alpine/issues/56#issuecomment-125777140)
