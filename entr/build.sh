#!/bin/sh

VERSION="5.2"

pkgname="entr_"$VERSION"_amd64"

apt update
apt install -y git build-essential

git clone -b $VERSION https://github.com/eradman/entr.git src
cd src
git checkout $VERSION

./configure
make install
cd ..

mkdir -p $pkgname/usr/local/bin
cp /usr/local/bin/entr $pkgname/usr/local/bin
rm -rf src

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: entr
Version: $VERSION
Architecture: amd64
Maintainer: entr@example.com
Description: Run arbitrary commands when files change 
EOF

dpkg-deb --build $pkgname
rm -r $pkgname
