# SSH bastion via Docker container

## Usage

Create an `authorized_keys` file and add the public keys you wish to use for this bastion. Make the file publicly readable or the user in the bastion container will not be able to read it.

```shell
chmod a+r authorized_keys
```

Put the options you want in an `sshd_config` file. Suggested options are in the `sshd_config.bastion` [file in this repo](https://github.com/nfugal/bastion/blob/master/sshd_config.bastion).

Change the port to match the one specified in your `sshd_config` then run the following command to start the bastion.

```shell
docker run --name bastion -d \
   --restart=unless-stopped \
   -v /some/path/you/like/authorized_keys:/home/dev/.ssh/authorized_keys:ro \
   -v /some/path/you/like/sshd_config:/etc/ssh/sshd_config:ro \
   -p 9022:9022 \
 ghcr.io/nfugal/bastion

```

Or you can deploy the bastion using `docker-compose`:

```yaml
---
version: "3.7"

services:
  bastion:
    container_name: bastion
    image: ghcr.io/nfugal/bastion:latest
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "200k"
        max-file: "10"
    ports:
      - 9022:9022
    volumes:
      - /some/path/you/like/authorized_keys:/home/dev/.ssh/authorized_keys:ro
      - /some/path/you/like/sshd_config:/etc/ssh/sshd_config:ro
```

I prefer to use the bastion with the [ProxyJump](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump) directive in a client's `~/.ssh/config` file. Much less typing than specifying things every single time you connect to a target host.

For example, placing the following in a client's `~/.ssh/config` would allow accessing `targetmachine1` through the bastion with a simple `ssh targetmachine1`, rather than the longer and more tedious to type `ssh -J dev@bastion.local.lan:9022 user@targetmachine1`. You can specify multiple target hosts, and many other things, in a client's `~/.ssh/config`

```ssh-config
### bastion host definition
Host bastion
  HostName bastion.local.lan
  Port 9022
  User dev
  AddressFamily inet

### endpoint definitions
Host targetmachine1
  HostName target1
  ProxyJump bastion

Host targetmachine2
  HostName target2
  ProxyJump bastion
```

## Security

The bastion does not utilize a firewall itself. Take care of that another way, on the Docker host, at the edge, etc.


## Build the image yourself

You can build the image yourself with the following commands:

```shell
git clone https://github.com/nfugal/bastion.git
docker build -t <fork-name-of-your-choice>/bastion bastion
```

With that done, you can essentially use the `docker run` command or `docker-compose` file above by simply replacing the image name with your newly built image.

## Credits

Thanks to [chentmin](https://github.com/chentmin/bastion) for the original work. My version relies heavily on their's.

This bastion is based on [Alpine Linux v3](https://hub.docker.com/_/alpine/).

Security harden script is based on and modified from [this](https://github.com/gliderlabs/docker-alpine/issues/56#issuecomment-125777140)
