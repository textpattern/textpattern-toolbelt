#!/bin/sh

#/*
# * Textpattern Content Management System
# * https://textpattern.com/
# *
# * Copyright (C) 2025 The Textpattern Development Team
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

#/*
# * DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED
# *
# * This file was used to create a Textpattern release using the
# * now-defunct Google Code platform. Refer to https://textpattern.com/
# * for guidance on current development processes.
# */


if [ $# -lt 1 ]; then
	echo 1>&2 Usage: $0 '<version> [svn-repos]'
	exit 127
fi

VER=$1
TMPDIR=`mktemp -d`
REPOS=http://textpattern.googlecode.com/svn/development/4.x/

if [ $# -eq 2 ]; then
	REPOS=$2
fi

svn export $REPOS $TMPDIR/textpattern-$VER
rm textpattern-$VER.tar.gz
rm textpattern-$VER.zip
#tar czvf textpattern-$VER.tar.gz -C $TMPDIR textpattern-$VER
tar cvf - -C $TMPDIR textpattern-$VER | gzip -c > textpattern-$VER.tar.gz
OLDDIR=`pwd`
cd $TMPDIR
zip  -r $OLDDIR/textpattern-$VER.zip textpattern-$VER --exclude textpattern-$VER/sites/\*
cd $OLDDIR
