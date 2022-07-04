#!/bin/sh

VERSION="v4.5"

short_version=`echo $VERSION | cut -c 2-`
pkgname="nnn_"$short_version"_amd64"

apt update
apt install -y wget

url="https://github.com/jarun/nnn/releases/download/$VERSION/nnn-musl-static-$short_version.x86_64.tar.gz"
wget -q --show-progress -O nnn.tgz "$url"

mkdir -p $pkgname/usr/local/bin
tar -xvf "nnn.tgz" -C $pkgname/usr/local/bin --no-same-owner
mv $pkgname/usr/local/bin/nnn-musl-static $pkgname/usr/local/bin/nnn
rm nnn.tgz

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: nnn
Version: $short_version
Architecture: amd64
Maintainer: nnn@example.com
Description: The unorthodox terminal file manager
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname
