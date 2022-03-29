#!/bin/sh

VERSION="v1.20.3"

short_version=`echo $VERSION | cut -c 2-`
pkgname="deno_"$short_version"_amd64"

apt update
apt install -y wget unzip

url="https://github.com/denoland/deno/releases/download/$VERSION/deno-x86_64-unknown-linux-gnu.zip"
wget -q --show-progress -O deno.zip "$url"

mkdir -p $pkgname/usr/local/bin
unzip "deno.zip" -d $pkgname/usr/local/bin
rm deno.zip

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: deno
Version: $short_version
Architecture: amd64
Maintainer: deno@example.com
Description: A modern runtime for JavaScript and TypeScript
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname
