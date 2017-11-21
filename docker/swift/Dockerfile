FROM akosma/base
MAINTAINER Adrian Kosmaczewski <learn@akosma.training>

USER root
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y clang libicu-dev libcurl4-openssl-dev libxml2 libpython2.7

USER developer
RUN wget https://swift.org/builds/swift-4.0-release/ubuntu1604/swift-4.0-RELEASE/swift-4.0-RELEASE-ubuntu16.04.tar.gz
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
RUN tar xzf swift-4.0-RELEASE-ubuntu16.04.tar.gz
RUN rm swift-4.0-RELEASE-ubuntu16.04.tar.gz
ENV PATH=$HOME/swift-4.0-RELEASE-ubuntu16.04/usr/bin/:"${PATH}"

