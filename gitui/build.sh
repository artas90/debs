#!/bin/sh

VERSION=`cat VERSION | xargs`

pkgname="gitui_"$VERSION"_amd64"

apt update
apt install -y wget

url="https://github.com/extrawurst/gitui/releases/download/v$VERSION/gitui-linux-musl.tar.gz"
wget -q --show-progress -O gitui.tgz "$url"

mkdir -p $pkgname/usr/local/bin
tar -xvf "gitui.tgz" -C $pkgname/usr/local/bin --no-same-owner
rm gitui.tgz

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: gitui
Version: $VERSION
Architecture: amd64
Maintainer: gitui@example.com
Description: Blazing fast terminal-ui for git written in rust
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname

if [ -n "$GITHUB_ENV" ]; then
  echo "PKG_TAG=$pkgname"            >> $GITHUB_ENV
  echo "PKG_PATH=gitui/$pkgname.deb" >> $GITHUB_ENV
fi
