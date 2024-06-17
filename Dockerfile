# Dockerfile for building PulseView and/or DSView.
# Prerequisites: mounts and settings in build.sh

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install build dependencies

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
  > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && \
  # AppImage
  apt-get install -y rename libfuse2 && \
  # sigrok-util: https://github.com/sigrokproject/sigrok-util/blob/master/cross-compile/linux/README
  apt-get install -y bash gcc make cmake git wget unzip pkg-config autoconf libtool sdcc && \
  # libsigrok: https://sigrok.org/wiki/Building#Build_requirements
  apt-get install -y g++ libglib2.0-dev libzip-dev libusb-1.0-0-dev libftdi1-dev doxygen python3-dev libglibmm-2.4-dev && \
  # PulseView: https://sigrok.org/gitweb/?p=pulseview.git;a=blob;f=INSTALL
  apt-get install -y qtbase5-dev qttools5-dev qttools5-dev-tools libqt5svg5-dev libboost-system-dev libboost-filesystem-dev libboost-serialization-dev libboost-test-dev && \
  # DSView: https://github.com/DreamSourceLab/DSView/blob/master/INSTALL
  apt-get install -y libfftw3-dev

# Download AppImageKit and strip architecture suffix

ARG APPIMAGEKIT_RELEASES_DOWNLOAD=https://github.com/AppImage/AppImageKit/releases/download/13

RUN mkdir -p $HOME/AppImageKit/build/out/
RUN \
  wget $APPIMAGEKIT_RELEASES_DOWNLOAD/appimagetool-x86_64.AppImage -P $HOME/AppImageKit/build/out/ && \
  wget $APPIMAGEKIT_RELEASES_DOWNLOAD/AppRun-x86_64 -P $HOME/AppImageKit/build/out/ && \
  wget $APPIMAGEKIT_RELEASES_DOWNLOAD/runtime-x86_64 -P $HOME/AppImageKit/build/out/
RUN rename "s/-x86_64.*//" $HOME/AppImageKit/build/out/*
RUN chmod u+x $HOME/AppImageKit/build/out/*

# Pull sigrok-util for build scripts

RUN git clone git://sigrok.org/sigrok-util

WORKDIR /sigrok-util/cross-compile/linux/
RUN sed -i "s/PARALLEL=\"-j [0-9]*\"/PARALLEL=\"-j $(nproc --all)\"/" ./sigrok-cross-linux # Update thread count

WORKDIR /sigrok-util/cross-compile/appimage/
RUN sed -i "s/PYVER=3\.5/PYVER=3\.10/" ./sigrok-native-appimage # Update Python version

# Pull DSView

WORKDIR /
RUN git clone https://github.com/DreamSourceLab/DSView.git

ENTRYPOINT bash /dependencies/build.sh
