#!/usr/bin/env bash
set -e

apt-get update
apt-get install -qy --no-install-recommends \
    libatomic1 \
    libicu70 \
    libncurses6 \
    libtomcrypt1 \
    libtommath1 \
    netbase \
    psmisc \
    procps

cd /home/firebird
tar --strip=1 -xf firebird.tar.gz
./install.sh -silent 


#excluindo arquivos
cd /
rm -rf /home/firebird

#criando pasta para fdb seguro
mkdir -p "${PREFIX}/skel/"
mv "${PREFIX}/security5.fdb" "${PREFIX}/skel/security5.fdb"
