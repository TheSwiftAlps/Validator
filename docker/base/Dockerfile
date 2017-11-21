FROM phusion/baseimage:0.9.22
MAINTAINER Adrian Kosmaczewski <learn@akosma.training>

CMD ["/sbin/my_init"]

# Default packages for a sane development environment
USER root
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y zsh tmux sudo
RUN apt-get install -y zip man tree entr tzdata
RUN apt-get install -y wget curl vim
RUN apt-get install -y build-essential gdb sqlite3
RUN apt-get install -y git mercurial subversion

# Change timezone
RUN echo Europe/Stockholm >/etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# Change default shell
RUN chsh -s /usr/bin/zsh
RUN locale-gen en_US.UTF-8

# Create a "developer" user
RUN adduser --gecos '' --shell /usr/bin/zsh developer
RUN adduser developer sudo
RUN echo 'developer:developer' | chpasswd
RUN chown -R developer.developer $HOME
ENV HOME /home/developer
WORKDIR $HOME

# Install oh-my-zsh
# Thanks to http://stackoverflow.com/a/30731731/133764 !
USER developer
RUN git config --global user.name "Swift Alps Developer"
RUN git config --global user.email "developer@theswiftalps.com"
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN echo 'set-option -g default-shell /usr/bin/zsh' > /home/developer/.tmux.conf

