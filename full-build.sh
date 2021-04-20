#!/usr/bin/env bash

set -e

if [[ -z $PGINSTALL ]]; then
  echo "ERROR: \$PGINSTALL environment variable is empty"
  exit 1
fi

make distclean || true

export PYTHON=/usr/bin/python

CFLAGS="-O0" ./configure --prefix=$PGINSTALL \
    --with-python --enable-tap-tests --enable-cassert --enable-debug \
    --with-perl --with-tcl
#    --with-libxml --with-libxslt --enable-nls \

# This works but generates a lot of warnings on MacOS:
# --with-gssapi --with-ldap

echo '-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-'

make -s -j4 world

echo '-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-'

# Run `make install` before `make check`
# See https://www.postgresql.org/message-id/flat/CAJ7c6TN6QONSsM3%3DGPdp2DtPgFpL1cY%2BtxVwfNREWuYX9V1P%3DQ%40mail.gmail.com
make install
make -j4 check

make install-world
make -j4 check-world
