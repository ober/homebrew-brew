from gerbil/base:ubuntu

MAINTAINER gerbil@cons.io

ARG squid

ENV https_proxy=https://${squid}:3128
ENV http_proxy=http://${squid}:3128

RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN cd /root && git clone http://github.com/gambit/gambit
RUN cd /root && git clone http://github.com/vyzo/gerbil

RUN cd /root/gambit && ./configure --prefix=/usr/local/gambit --enable-single-host --enable-c-opt --enable-gcc-opts --enable-multiple-versions --enable-openssl --enable-default-runtime-options=f8,-8,t8 --enable-poll
RUN cd /root/gambit && make -j4
RUN cd /root/gambit && make install

#RUN find /usr/local/gambit/ -ls
ENV PATH "/usr/local/gambit/v4.8.9/bin:$PATH"
RUN cd /root/gerbil/src && ./build.sh stage0
RUN cd /root/gerbil/src && ./build.sh stage1
RUN sed -i -e 's/mysql #f/mysql #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/leveldb #f/leveldb #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/lmdb #f/lmdb #t/g' /root/gerbil/src/std/build-features.ss
RUN cd /root/gerbil/src && ./build.sh stdlib
RUN cd /root/gerbil/src && ./build.sh lang
RUN cd /root/gerbil/src && ./build.sh tools
RUN cd /root/gerbil/src && ./build.sh tags

CMD /root/gerbil/bin/gxi
