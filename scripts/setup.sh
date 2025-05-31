#!/bin/bash

# Configurer le dépôt principal si nécessaire
REPO_DIR="$HOME/KinectGenerativeArt"
if [ ! -d "$REPO_DIR/libfreenect" ]; then
    echo "Téléchargement de libfreenect..."
    git clone https://github.com/OpenKinect/libfreenect.git "$REPO_DIR/libfreenect"
fi

# Installer les dépendances système
sudo apt update && sudo apt install -y \
    cmake \
    libusb-1.0-0-dev \
    libturbojpeg0-dev \
    python3-dev \
    python3-pip \
    python3-numpy \
    libglfw3-dev

# Compiler libfreenect
cd "$REPO_DIR/libfreenect" || exit 1
mkdir -p build
cd build || exit 1
cmake -DBUILD_EXAMPLES=OFF -DBUILD_FAKENECT=ON ..
if ! make -j$(nproc); then
    echo "Échec de la compilation - Vérifiez les logs"
    exit 1
fi
sudo make install

# Installer les bindings Python
cd ../wrappers/python || exit 1
sudo python3 setup.py install

# Configurer les règles USB
UDEV_RULES="platform/linux/udev/90-kinect.rules"
if [ -f "$UDEV_RULES" ]; then
    sudo cp $UDEV_RULES /etc/udev/rules.d/
    sudo udevadm control --reload-rules
else
    echo "AVERTISSEMENT: Règles udev manquantes - Droits USB nécessaires!"
fi

# Installer les dépendances Python
cd "$REPO_DIR" || exit 1
if [ -f "requirements.txt" ]; then
    sudo pip3 install -r requirements.txt
else
    echo "ERREUR: Fichier requirements.txt manquant!"
    echo "Créez-le avec :"
    echo "pygame==2.1.3" > requirements.txt
    echo "numpy==1.22.4" >> requirements.txt
    exit 1
fi

echo "Installation réussie! Redémarrez avant utilisation."
