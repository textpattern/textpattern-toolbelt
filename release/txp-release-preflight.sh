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
# * along with Textpattern. If not, see <https://www.gnu.org/licenses/>.
# */
echo -e '=> Checking `git`...'
GIT_VERSION="$(git --version)"
if [ "$GIT_VERSION" != "command not found" ]; then
	echo -e '`git` found'
else
	echo -e '`git` NOT found'
fi

echo -e '\n=> Checking gzip...'
GZIP_VERSION="$(gzip -V)"
if [ "$GZIP_VERSION" != "command not found" ]; then
	echo -e '`gzip` found'
else
	echo -e '`gzip` NOT found'
fi

echo -e '\n=> Checking php...'
PHP_VERSION="$(php -v)"
if [ "$PHP_VERSION" != "command not found" ]; then
	echo -e '`php` found'
else
	echo -e '`php` NOT found'
fi

echo -e '\n=> Checking shasum...'
SHASUM_VERSION="$(shasum -v)"
if [ "$SHASUM_VERSION" != "command not found" ]; then
	echo -e '`shasum` found'
else
	echo -e '`shasum` NOT found'
fi

echo -e '\n=> Checking tar...'
TAR_VERSION="$(tar --version)"
if [ "$TAR_VERSION" != "command not found" ]; then
	echo -e '`tar` found'
else
	echo -e '`tar` NOT found'
fi

echo -e '\n=> Checking xz...'
XZ_VERSION="$(xz --version)"
if [ "$XZ_VERSION" != "command not found" ]; then
	echo -e '`xz` found'
else
	echo -e '`xz` NOT found'
fi

echo -e '\n=> Checking zip...'
ZIP_VERSION="$(zip -v)"
if [ "$ZIP_VERSION" != "command not found" ]; then
	echo -e '`zip` found'
else
	echo -e '`zip` NOT found'
fi

