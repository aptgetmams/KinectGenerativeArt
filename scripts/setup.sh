#!/bin/bash

# Mise à jour du système
sudo apt-get update && sudo apt-get upgrade -y

# Dépendances logicielles
sudo apt-get install -y \
    cmake \
    libusb-1.0-0-dev \
    freeglut3-dev \
    build-essential \
    python3-dev \
    python3-pip \
    python3-numpy \
    libopenblas-dev

# Installation de libfreenect
git clone https://github.com/OpenKinect/libfreenect
cd libfreenect
mkdir build
cd build
cmake .. -DBUILD_PYTHON3=ON
make
sudo make install
cd ../bindings/python
sudo python3 setup.py install

# Règles udev
sudo cp ../../platform/linux/udev/90-kinect.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules

# Installation des dépendances Python
sudo pip3 install -r requirements.txt

echo "Installation terminée! Redémarrez le système."
