#!/bin/sh

VERSION="v0.20.1"

short_version=`echo $VERSION | cut -c 2-`
pkgname="gitui_"$short_version"_amd64"

apt update
apt install -y wget

url="https://github.com/extrawurst/gitui/releases/download/$VERSION/gitui-linux-musl.tar.gz"
wget -q --show-progress -O gitui.tgz "$url"

mkdir -p $pkgname/usr/local/bin
tar -xvf "gitui.tgz" -C $pkgname/usr/local/bin --no-same-owner
rm gitui.tgz

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: gitui
Version: $short_version
Architecture: amd64
Maintainer: gitui@example.com
Description: Blazing fast terminal-ui for git written in rust
EOF

dpkg-deb --build $pkgname
