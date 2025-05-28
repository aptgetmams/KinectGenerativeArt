#!/bin/bash

### Mise à jour du système
sudo apt update
sudo apt full-upgrade -y

### Installation des dépendances C/C++
sudo apt install -y \
    cmake \
    libusb-1.0-0-dev \
    libxmu-dev \
    libxi-dev \
    freeglut3-dev \
    libglfw3-dev \
    libturbojpeg0-dev \
    libudev-dev \
    python3-dev \
    python3-pip \
    python3-numpy

### Compilation de libfreenect
cd libfreenect
mkdir -p build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_FAKENECT=OFF -DBUILD_C_SYNC=ON -DBUILD_PYTHON3=ON
make
sudo make install
cd ../wrappers/python
sudo python3 setup.py install
cd ../../../

### Règles udev
sudo cp libfreenect/platform/linux/udev/90-kinect.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules

### Installation des dépendances Python
sudo pip3 install -r requirements.txt

echo "Installation réussie! Redémarrez le système."
