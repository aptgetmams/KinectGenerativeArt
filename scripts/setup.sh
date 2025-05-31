#!/bin/bash

REPO_DIR="$HOME/KinectGenerativeArt"

# Clonage manuel de libfreenect si absent
if [ ! -d "$REPO_DIR/libfreenect" ]; then
    git clone https://github.com/OpenKinect/libfreenect.git "$REPO_DIR/libfreenect"
fi

# Dépôts manquants critiques
sudo apt update && sudo apt install -y \
    libusb-1.0-0-dev \
    libturbojpeg0-dev \
    libglfw3-dev \
    gcc-arm-linux-gnueabihf

# Compilation principale avec cache
cd "$REPO_DIR/libfreenect" || exit 1

# Configuration Cmake optimisée pour ARM
mkdir -p build && cd build
cmake \
  -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
  -DENABLE_CXX11=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_OPENNI2_DRIVER=OFF ..

make -j$(nproc)
[ $? -ne 0 ] && echo "Échec compilation libfreenect!" && exit 1
sudo make install

# Installation bindings Python
cd ../wrappers/python || exit 1
CFLAGS="-I$REPO_DIR/libfreenect/include -I/usr/include/libusb-1.0" \
LDFLAGS="-L/usr/lib/arm-linux-gnueabihf -L/usr/local/lib" \
sudo python3 setup.py install

# Gestion udev
if [ -f "../platform/linux/udev/90-kinect.rules" ]; then
    sudo cp "../platform/linux/udev/90-kinect.rules" /etc/udev/rules.d/
    sudo udevadm control --reload-rules
fi

# Configuration Python
cd "$REPO_DIR"
cat << EOF > requirements.txt
numpy==1.22.3
pygame==2.1.2
opencv-python-headless==4.5.5.64
EOF

sudo pip3 install -r requirements.txt

echo "Installation validée! Branchez la Kinect et redémarrez."
