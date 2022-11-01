#!/bin/sh

# -- install deps -- -- --

apt update
apt install -y wget git apt-transport-https

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
echo 'deb https://apt.kitware.com/ubuntu/ xenial main' | tee /etc/apt/sources.list.d/kitware.list

apt update
apt install -y build-essential cmake unzip pkg-config gettext libtool-bin

# -- get source -- -- --

VERSION=`cat VERSION | xargs`

pkgname="nvim_"$VERSION"_amd64"

url="https://github.com/neovim/neovim/archive/refs/tags/v$VERSION.tar.gz"
wget -q --show-progress -O nvim.tgz "$url"

mkdir -p $pkgname/DEBIAN $pkgname/usr/local
tar -xvf "nvim.tgz" --no-same-owner
rm nvim.tgz

# -- build -- -- --

cd "neovim-$VERSION"
export CMAKE_BUILD_TYPE="RelWithDebInfo"
export CMAKE_INSTALL_PREFIX="/app/$pkgname/usr/local"
export CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/app/$pkgname/usr/local"

make

# ugly fix
fixfile="cmake.deps/cmake/DownloadAndExtractFile.cmake"
sed -i 's#${CMAKE_COMMAND} -E tar xfz#tar --no-same-owner --no-overwrite-dir --touch -xzf#' $fixfile

make
make install

rm -rf "neovim-$VERSION"

cd ..

# -- make deb -- -- --

cat > $pkgname/DEBIAN/control <<EOF
Package: nvim
Version: $VERSION
Architecture: amd64
Maintainer: nvim@example.com
Description: Vim-fork focused on extensibility and usability
EOF

dpkg-deb --build $pkgname
rm -rf $pkgname

if [ -n "$GITHUB_ENV" ]; then
  echo "PKG_TAG=$pkgname"           >> $GITHUB_ENV
  echo "PKG_PATH=nvim/$pkgname.deb" >> $GITHUB_ENV
fi
