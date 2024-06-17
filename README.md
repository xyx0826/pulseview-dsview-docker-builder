# Docker container for building PulseView and DSView

This repository contains a Dockerfile and scripts for building PulseView and
DSView for Linux.
[PulseView](https://sigrok.org/wiki/PulseView) is a digital logic analyzer GUI
based on Sigrok.
[DSView](https://github.com/DreamSourceLab/DSView) is a fork of PulseView for
DreamSourceLab logic analyzer products, maintained by the same company.

This setup builds PulseView and DSView binaries, then uses [sigrok-util](https://sigrok.org/gitweb/?p=sigrok-util.git;a=summary) to package both programs using AppImage.

## Usage

You must have Docker installed and set up.
Clone the repository and execute `./build.sh` to build.
Build output is placed under the `output` directory.

