#!/bin/sh

# docker run -it --rm -v `pwd`:/app -w /app ubuntu:20.04 bash 
#     /app/build.sh

VERSION="23.05"
UBUNTU_REL="focal"

# -- prepare -- -- --

pkgname="hx-"$VERSION"."$UBUNTU_REL".amd64"
pkgroot="/tmp/app/$pkgname"

mkdir -p $pkgroot/opt/hx $pkgroot/usr/local/bin

cd /tmp/app

# -- install deps -- -- --

apt update && apt install -y build-essential curl git

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
source "$HOME/.cargo/env"
rustup toolchain install stable --profile minimal

# -- build app -- -- --

git clone https://github.com/helix-editor/helix && cd helix && git checkout $VERSION

cargo install --path helix-term --locked

# -- copy files -- -- --

cd $pkgroot

cp $HOME/.cargo/bin/hx opt/hx
chmod +x opt/hx/hx
ln -sfv /opt/hx/hx usr/local/bin/hx

cp -r ../helix/runtime opt/hx
rm -rf opt/hx/runtime/grammars/sources

cp -r ../helix/contrib opt/hx

# -- make deb -- -- --

cd /tmp/app

mkdir -p $pkgname/DEBIAN

cat > $pkgname/DEBIAN/control <<EOF
Package: hx
Version: $VERSION
Architecture: amd64
Maintainer: hx@example.com
Description: A post-modern modal text editor
EOF

dpkg-deb --build $pkgname

cp /tmp/app/$pkgname.deb /app/$pkgname.deb

# if [ -n "$GITHUB_ENV" ]; then
#   echo "PKG_TAG=$pkgname"           >> $GITHUB_ENV
#   echo "PKG_PATH=nvim/$pkgname.deb" >> $GITHUB_ENV
# fi

# -- misc -- -- --
'
  docker run -it -e "TERM=xterm-256color" --rm -v `pwd`:/app -w /app ubuntu:20.04 bash  

  apt update && apt install -y curl
  mkdir -p ~/.config/helix
  dotfiles="https://raw.githubusercontent.com/artas90/dotfiles"
  curl $dotfiles/main/configs/other/helix/config.toml > ~/.config/helix/config.toml
  hx ~/.config/helix/config.toml
'
