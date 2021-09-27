FROM alpine:3

LABEL org.opencontainers.image.source=https://github.com/nfugal/bastion

RUN apk --update add openssh && rm -f /var/cache/apk/*

RUN cd /etc/ssh && ssh-keygen -A

RUN rm /etc/ssh/sshd_config

RUN chmod a+r /etc/ssh/ssh_*

RUN adduser -D dev && passwd -d dev && mkdir /home/dev/.ssh && chown dev:nogroup /home/dev/.ssh && chmod 700 /home/dev/.ssh

VOLUME /home/dev/.ssh

#ADD harden.sh /usr/bin/harden.sh

#RUN chmod 700 /usr/bin/harden.sh && /usr/bin/harden.sh

USER dev

CMD ["/usr/sbin/sshd", "-D", "-e"]
