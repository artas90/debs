#!/bin/sh

VERSION=`cat VERSION | xargs`

pkgname="deno_"$VERSION"_amd64"

apt update
apt install -y wget unzip

url="https://github.com/denoland/deno/releases/download/v$VERSION/deno-x86_64-unknown-linux-gnu.zip"
wget -q --show-progress -O deno.zip "$url"

mkdir -p $pkgname/usr/local/bin
unzip "deno.zip" -d $pkgname/usr/local/bin
rm deno.zip

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: deno
Version: $VERSION
Architecture: amd64
Maintainer: deno@example.com
Description: A modern runtime for JavaScript and TypeScript
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname

if [ -n "$GITHUB_ENV" ]; then
  echo "PKG_TAG=$pkgname"           >> $GITHUB_ENV
  echo "PKG_PATH=deno/$pkgname.deb" >> $GITHUB_ENV
fi
