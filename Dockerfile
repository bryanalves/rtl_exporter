FROM debian:10

MAINTAINER Bryan Alves <bryanalves@gmail.com>

RUN apt-get update && \
  apt-get install -y git \
  golang \
  libtool \
  libusb-1.0-0-dev \
  librtlsdr-dev \
  rtl-sdr \
  build-essential \
  autoconf \
  cmake \
  pkg-config

RUN git clone https://github.com/merbanan/rtl_433.git

RUN cd rtl_433/ && \
  mkdir build &&  \
  cd build &&  \
  cmake .. &&  \
  make &&  \
  make install

RUN go get github.com/bemasher/rtlamr

RUN apt-get install -y ruby ruby-dev && gem install mqtt sinatra puma prometheus-client

ADD main.rb /

CMD ["ruby", "main.rb"]
