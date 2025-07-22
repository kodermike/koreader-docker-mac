#FROM koreader/koappimage:latest
FROM ubuntu:latest
USER root
ENV TZ=America/Los_Angeles \
  DEBIAN_FRONTEND=noninteractive
RUN apt-get update

# install the necessary x packages
RUN apt-get -y install \
  -y xvfb
#-y x11vnc xvfb

# install the bare minimum build tools
RUN apt-get -y install autoconf automake build-essential ca-certificates cmake \
  gcc-multilib git libsdl2-2.0-0 libtool libtool-bin meson nasm ninja-build \
  patch perl pkg-config unzip wget

RUN apt-get -y install ccache gettext lua-check p7zip-full

USER ko
WORKDIR /home/ko

