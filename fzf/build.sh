#!/bin/sh

VERSION=`cat VERSION | xargs`

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

if [ -n "$GITHUB_ENV" ]; then
  echo "PKG_TAG=$pkgname"           >> $GITHUB_ENV
  echo "PKG_PATH=fzf/$pkgname.deb" >> $GITHUB_ENV
fi
