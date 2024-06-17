#!/usr/bin/bash

# This is the build script from within the container.

COLOR='\033[1;32m'
NC='\033[0m'

# Compile PulseView and package AppImage
# echo -e "${COLOR}build.sh: Building PulseView${NC}"
# cd /sigrok-util/cross-compile/linux/ && \
#   ./sigrok-cross-linux
# echo -e "${COLOR}build.sh: Packaging PulseView${NC}"
# cd /sigrok-util/cross-compile/appimage && \
#   ./sigrok-native-appimage

# Compile DSView
echo -e "${COLOR}build.sh: Building DSView${NC}"
cd /DSView && \
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/ds -DCMAKE_SYSTEM_NAME=Linux . && \
  make -j$(nproc --all) install

# Copy DSView desktop file to the path expected by AppImage script
mkdir -p $HOME/ds/share/applications/ && \
  cp /usr/share/applications/dsview.desktop $HOME/ds/share/applications/com.dreamsourcelab.DSView.desktop

# Patch sigrok-util to package DSView AppImage
echo -e "${COLOR}build.sh: Packaging DSView${NC}"
cd /sigrok-util/cross-compile/appimage/ && \
  git apply /dependencies/dsview-native-appimage.patch && \
  ./sigrok-native-appimage
  
# Copy out AppImage artifacts
cp ./out/* /appimage/
echo -e "${COLOR}build.sh: All done${NC}"

