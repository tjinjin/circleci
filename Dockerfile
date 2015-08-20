FROM centos:centos7
MAINTAINER tjinjin

# package
RUN yum install -y bzip logrotate make net-tools nfs-utils openssh openssh-clients openssh-server \
    openssl passwd rsync rsyslog sudo tar wget initscripts dbus && \
    yum clean all

## Create user
RUN useradd docker && \
    passwd -f -u docker && \

## Set up SSH
    mkdir -p /home/docker/.ssh && chown docker /home/docker/.ssh && chmod 700 /home/docker/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCo3vfDeOweTffBGtRlEsDcJvEFnA8/lwD+MTwx0uqquXEUa5TiawHJWS2PBuUbEZ3WbLwbp9vJMYIadnOn/wrsm+7XPwSiAHRqng2XjKqz+jXA+vHpjdD2wlbL2aiGsbn17ZfeF8062J3XEgYesNjsQxOPF7BlJM5+O5KRsA57HfVZb6NanSin4PU8NJ2ItRwTeKO5Y+lX30v0JxWIlXslYhp39sqAtG6WG73kxoigUF6uosYJBoYZnrEFKFRaMBZACBSk1cZFICbac762kK+ZjJb4NAtu1CtgwIG3BLyAITYBQKFmVQCW45dpXyOmCzzNQGwz9m2lgq+taK2ZnOnJ tjinjin" > /home/docker/.ssh/authorized_keys && \

    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \

## setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker

## Set up SSHD config
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -ri 's/^UsePAM yes/#UsePAM no/g' /etc/ssh/sshd_config && \

## Pam認証が有効でもログインするための設定
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd

## http://qiita.com/jagaximo/items/c810ebce796d9e5e496e
RUN echo "root:root" | chpasswd
RUN /usr/bin/ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ""
RUN /usr/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""

##
#RUN echo "AddressFamily inet" >> /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/init"]
