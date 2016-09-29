#!/bin/sh

#/*
# * Textpattern Content Management System
# * http://textpattern.com
# *
# * Copyright (C) 2005 Dean Allen
# * Copyright (C) 2016 The Textpattern Development Team
# *
# * This file is part of Textpattern.
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
# * along with Textpattern. If not, see <http://www.gnu.org/licenses/>.
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

rm textpattern-$VER.tar.gz
rm textpattern-$VER.zip
rm textpattern-$VER/composer.json
rm textpattern-$VER/.gitignore
rm textpattern-$VER/images/.gitignore
rm textpattern-$VER/textpattern/.gitignore
rm textpattern-$VER/textpattern/tmp/.gitignore
rm textpattern-$VER/phpcs.xml
rm textpattern-$VER/.phpstorm.meta.php
rm textpattern-$VER/README.md

tar cvf - -C $DESTDIR textpattern-$VER | gzip -c > textpattern-$VER.tar.gz

zip -r textpattern-$VER.zip textpattern-$VER --exclude textpattern-$VER/sites/\*

cd $OLDDIR

echo Textpattern v$VER built in $DESTDIR
