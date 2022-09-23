#!/bin/sh

VERSION=`cat VERSION | xargs`

pkgname="nnn_"$VERSION"_amd64"

apt update
apt install -y wget

url="https://github.com/jarun/nnn/releases/download/v$VERSION/nnn-musl-static-$VERSION.x86_64.tar.gz"
wget -q --show-progress -O nnn.tgz "$url"

mkdir -p $pkgname/usr/local/bin
tar -xvf "nnn.tgz" -C $pkgname/usr/local/bin --no-same-owner
mv $pkgname/usr/local/bin/nnn-musl-static $pkgname/usr/local/bin/nnn
rm nnn.tgz

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: nnn
Version: $VERSION
Architecture: amd64
Maintainer: nnn@example.com
Description: The unorthodox terminal file manager
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname

if [ -n "$GITHUB_ENV" ]; then
  echo "PKG_TAG=$pkgname"           >> $GITHUB_ENV
  echo "PKG_PATH=nnn/$pkgname.deb" >> $GITHUB_ENV
fi
