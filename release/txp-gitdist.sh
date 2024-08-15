#!/bin/sh

#/*
# * Textpattern Content Management System
# * https://textpattern.com/
# *
# * Copyright (C) 2020 The Textpattern Development Team
# *
# * Textpattern is free software; you can redistribute it and/or
# * modify it under the terms of the GNU General Public License
# * as published by the Free Software Foundation, version 2.
# *
# * Textpattern is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with Textpattern. If not, see <https://www.gnu.org/licenses/>.
# */

if [ $# -lt 1 ]; then
    echo 1>&2 Usage: $0 '<version> [dest-dir] [repo-dir]'
    echo 1>&2 ' dest-dir defaults to a temporary location, repo-dir to the current directory.';
    exit 127
fi

VER=$1
DESTDIR=`mktemp -d "${TMPDIR:-/tmp}/txp.XXXXXXXXX"`
OLDDIR=`pwd`
REPODIR=$OLDDIR

if [ $# -eq 2 ]; then
    DESTDIR=$2
fi

if [ $# -eq 3 ]; then
    DESTDIR=$2
    REPODIR=$3
fi

cd $REPODIR

# Export repo to destination -- trailing slash is important!
git checkout-index -a -f --prefix=$DESTDIR/textpattern-$VER/

cd $DESTDIR

# Tidy and remove development helper files.
rm textpattern-$VER.tar.gz
rm textpattern-$VER.zip
rm textpattern-$VER.tar.gz.SHA256SUM
rm textpattern-$VER.zip.SHA256SUM
rm textpattern-$VER/.gitattributes
rm textpattern-$VER/.phpstorm.meta.php
rm textpattern-$VER/CODE_OF_CONDUCT.md
rm textpattern-$VER/composer.json
rm textpattern-$VER/composer.lock
rm textpattern-$VER/CONTRIBUTING.md
rm textpattern-$VER/package.json
rm textpattern-$VER/phpcs.xml
rm textpattern-$VER/README.md
rm textpattern-$VER/SECURITY.md
rm -rf textpattern-$VER/.github
find . -name '.gitignore' -type f -delete
find . -name '.DS_Store' -type f -delete

# Tidy and remove vendor furniture.
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/.editorconfig
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/COMMITMENT
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/README.md
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/SECURITY.md
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/VERSION
rm textpattern-$VER/textpattern/vendors/phpmailer/phpmailer/composer.json

# Bundle up.
tar cvf - -C $DESTDIR textpattern-$VER | gzip -c9 > textpattern-$VER.tar.gz
echo '=> Testing textpattern-'$VER'.tar.gz integrity...'
if gzip -t textpattern-$VER.tar.gz; then
    echo '=> textpattern-'$VER'.tar.gz passed `gzip -t` integrity test. Calculating SHA256 checksum...' \
    && shasum -a 256 -b textpattern-$VER.tar.gz > textpattern-$VER.tar.gz.SHA256SUM \
    && echo '=> SHA256 for textpattern-'$VER'.tar.gz: '$(cat textpattern-$VER.tar.gz.SHA256SUM) \
    && echo '=> Checking textpattern-'$VER'.tar.gz against textpattern-'$VER'.tar.gz.SHA256SUM...' \
    && shasum -a 256 -c textpattern-"$VER".tar.gz.SHA256SUM textpattern-$VER.tar.gz
else 
    echo '=> textpattern-$VER.tar.gz failed `gzip -t` integrity test.'
fi

zip --symlinks -r -9 textpattern-$VER.zip textpattern-$VER --exclude textpattern-$VER/sites/\*
echo '=> Testing textpattern-'$VER'.zip integrity...'
if unzip -t textpattern-$VER.zip; then
    echo '=> textpattern-'$VER'.zip passed `unzip -t` integrity test. Calculating SHA256 checksum...' \
    && shasum -a 256 -b textpattern-$VER.zip > textpattern-$VER.zip.SHA256SUM \
    && echo '=> SHA256 for textpattern-'$VER'.zip: '$(cat textpattern-$VER.zip.SHA256SUM) \
    && echo '=> Checking textpattern-'$VER'.zip against textpattern-'$VER'.zip.SHA256SUM...' \
    && shasum -a 256 -c textpattern-"$VER".zip.SHA256SUM textpattern-$VER.zip
else 
    echo '=> textpattern-$VER.zip failed `unzip -t` integrity test.'
fi

cd $OLDDIR

echo Textpattern v$VER built in $DESTDIR
