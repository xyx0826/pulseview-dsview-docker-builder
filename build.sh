#!/usr/bin/bash

docker build -t sr-builder .

mkdir -p ./output/sr ./output/ds ./output/appimage

docker run -it \
  --device /dev/fuse \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --mount type=bind,source="$(pwd)"/dependencies/,target=/dependencies/,readonly \
  --mount type=bind,source="$(pwd)"/output/sr/,target=/root/sr/ \
  --mount type=bind,source="$(pwd)"/output/ds/,target=/root/ds/ \
  --mount type=bind,source="$(pwd)"/output/appimage/,target=/appimage/ \
  sr-builder

echo "Build complete. Things to check:"
echo "  1. Change owner and group of build artifacts"
echo "  2. Add udev rules for DreamSourceLab devices"

