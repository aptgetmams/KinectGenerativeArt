#!/bin/bash

# Configurer le sous-module si nécessaire
if [ ! -d "libfreenect" ]; then
    echo "Téléchargement de libfreenect..."
    git submodule init
    git submodule update
fi

# Installer les dépendances
sudo apt update
sudo apt install -y \
    cmake \
    libusb-1.0-0-dev \
    libturbojpeg0-dev \
    python3-dev \
    python3-pip \
    python3-numpy

# Compiler libfreenect
cd libfreenect
mkdir -p build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_FAKENECT=ON
make -j$(nproc)
sudo make install

# Installer les bindings Python
cd ../wrappers/python
sudo python3 setup.py install
cd ../../..

# Configurer les règles udev
if [ -f "libfreenect/platform/linux/udev/90-kinect.rules" ]; then
    sudo cp libfreenect/platform/linux/udev/90-kinect.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules
else
    echo "AVERTISSEMENT: Fichier udev non trouvé!"
fi

# Installer les dépendances Python
if [ -f "requirements.txt" ]; then
    sudo pip3 install -r requirements.txt
else
    echo "ERREUR: Fichier requirements.txt manquant!"
    exit 1
fi

echo "Installation réussie! Redémarrez le système."
