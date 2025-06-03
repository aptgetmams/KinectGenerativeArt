#!/bin/bash
sudo apt update && sudo apt full-upgrade -y 

sudo apt install git cmake build-essential libusb-1.0-0-dev libturbojpeg0-dev

#sudo apt install libusb-1.0-0-dev python3-opencv python3-numpy 
#python3-pyopengl

sudo apt update && sudo apt install -y \
    libusb-1.0-0-dev \
    python3-opencv \
    python3-numpy \
#    python3-pyopengl

sudo apt install -y libusb-1.0-0-dev libgl1-mesa-dev python3-opencv

sudo apt install libopencv-dev python3-dev python3-pybind11 cmake freeglut3-dev libgl1-mesa-dev ninja-build

#sudo apt install -y \ 
#    libopencv-dev \ 
#    python3-dev \ 
#    python3-pybind11 \ 
#    cmake \ 
#    freeglut3-dev \ 
#    libgl1-mesa-dev \ 
#    ninja-build

# Compilation optimisée de libfreenect
git clone https://github.com/OpenKinect/libfreenect
cd libfreenect
mkdir build && cd build
cmake .. -DCMAKE_C_FLAGS="-march=armv7-a -mtune=cortex-a53 -mfpu=neon-fp-armv8"
make -j$(nproc) && sudo make install

# Configuration udev
sudo cp /home/pi/KinectGenerativeArt/libfreenect/platform/linux/udev/51-kinect.rules /etc/udev/rules.d/
sudo cp /home/pi/KinectGenerativeArt/99-kinect.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
