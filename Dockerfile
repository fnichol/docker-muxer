# muxer/base
#
# VERSION 0.1.0

FROM ubuntu:12.04
MAINTAINER Fletcher Nichol "fnichol@nichol.ca"

RUN apt-get update

RUN locale-gen en_US en_US.UTF-8

RUN apt-get install -y autoconf bison build-essential curl git emacs less man-db mercurial nano netcat-openbsd telnet tree vim

RUN apt-get install -y openssh-server && mkdir -p /var/run/sshd && rm -f /etc/ssh/ssh_host_*

RUN apt-get install -y sudo && echo '%muxer ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/muxer && chmod 0440 /etc/sudoers.d/muxer

RUN groupadd muxer
RUN useradd -d /home/muxer -g muxer -m -s /bin/bash muxer && passwd --lock muxer && chmod 0700 /home/muxer

ENV TMUX_VERSION 1.9a
RUN apt-get install -y libevent-dev libncurses5-dev gcc make && \
  curl -L -o /tmp/tmux.tar.gz http://downloads.sourceforge.net/tmux/tmux-${TMUX_VERSION}.tar.gz && \
  mkdir -p /tmp/tmux && \
  cd /tmp/tmux && \
  tar xfz /tmp/tmux.tar.gz --strip-components=1 && \
  ./configure && \
  make && \
  make install && \
  ln -snf /usr/local/bin/tmux /usr/bin/tmux && \
  rm -rf /tmp/tmux.tar.gz /tmp/tmux

RUN apt-get -y autoremove

ADD profile_d_muxer.sh /etc/profile.d/zzz_muxer.sh
ADD sshd_config /etc/ssh/sshd_config
ADD tmux.conf /etc/tmux.conf
ADD muxer-init /sbin/muxer-init

EXPOSE 22
ENTRYPOINT ["/sbin/muxer-init"]
CMD ["-e"]
