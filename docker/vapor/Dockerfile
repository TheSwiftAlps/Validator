FROM akosma/swift
MAINTAINER Adrian Kosmaczewski <learn@akosma.training>

USER root
RUN apt-get -y update
RUN apt-get -y upgrade
RUN wget -q https://repo.vapor.codes/apt/keyring.gpg -O- | apt-key add -
RUN echo "deb https://repo.vapor.codes/apt $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/vapor.list
RUN apt-get update
RUN apt-get install -y vapor
RUN apt-get install libsqlite3-dev

USER developer
RUN vapor new Hello --template=api
WORKDIR $HOME/Hello
RUN vapor build
WORKDIR $HOME

