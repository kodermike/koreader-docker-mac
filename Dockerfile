FROM koreader/koappimage:latest
USER root
ENV TZ=America/Los_Angeles \
  DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install \
  -y x11vnc xvfb

ADD https://github.com/koreader/koreader/releases/download/v2020.07.1/koreader-appimage-x86_64-linux-gnu-v2020.07.1.AppImage appimage
RUN chmod +x ./appimage
RUN ./appimage --appimage-extract
