#!/bin/bash
sudo apt update && sudo apt install -y \
    libusb-1.0-0-dev \
    python3-opencv \
    python3-numpy \
    python3-pyopengl

# Compilation optimisée de libfreenect
git clone https://github.com/OpenKinect/libfreenect
cd libfreenect
mkdir build && cd build
cmake .. -DCMAKE_C_FLAGS="-march=armv7-a -mtune=cortex-a53 -mfpu=neon-fp-armv8"
make -j$(nproc) && sudo make install

# Configuration udev
sudo cp ../99-kinect.rules /etc/udev/rules.d/
sudo udevadm control --reload
