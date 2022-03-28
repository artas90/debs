#!/bin/sh

VERSION="0.29.0"

pkgname="fzf_"$VERSION"_amd64"

apt update
apt install -y wget

url="https://github.com/junegunn/fzf/releases/download/$VERSION/fzf-$VERSION-linux_amd64.tar.gz"
wget -q --show-progress -O fzf.tgz "$url"

mkdir -p $pkgname/usr/local/bin
tar -xvf "fzf.tgz" -C $pkgname/usr/local/bin --no-same-owner
rm fzf.tgz

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: fzf
Version: $VERSION
Architecture: amd64
Maintainer: fzf@example.com
Description: A command-line fuzzy finder
EOF

dpkg-deb --build $pkgname
rm -r $pkgname
