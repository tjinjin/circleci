#!/bin/sh
set -xe

if [ -e $HOME/cache/centos-sshd.tar ] && $(md5sum --status --quiet --check $HOME/cache/dockerfile.digest)
then
  docker load < $HOME/cache/centos-sshd.tar
else
  mkdir -p $HOME/cache
  docker build -t docker/centos-sshd .
  md5sum Dockerfile  > $HOME/cache/dockerfile.digest
  docker save docker/centos-sshd > $HOME/cache/centos-sshd.tar
fi

docker info
