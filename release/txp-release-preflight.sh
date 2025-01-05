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
echo "Checking bzip2..."
BZIP2_VERSION="$(bzip2 --v)"
if [ "$BZIP2_VERSION" != "command not found" ]; then
	echo "bzip2 found"
else
	echo "bzip2 NOT found"
fi

echo "Checking git..."
GIT_VERSION="$(git --version)"
if [ "$GIT_VERSION" != "command not found" ]; then
	echo "git found"
else
	echo "git NOT found"
fi

echo "Checking gzip..."
GZIP_VERSION="$(gzip -V)"
if [ "$GZIP_VERSION" != "command not found" ]; then
	echo "gzip found"
else
	echo "gzip NOT found"
fi

echo "Checking php.."
PHP_VERSION="$(php -V)"
if [ "$PHP_VERSION" != "command not found" ]; then
	echo "php found"
else
	echo "php NOT found"
fi

echo "Checking shasum..."
SHASUM_VERSION="$(shasum -v)"
if [ "$SHASUM_VERSION" != "command not found" ]; then
	echo "shasum found"
else
	echo "shasum NOT found"
fi

echo "Checking tar..."
TAR_VERSION="$(tar --version)"
if [ "$TAR_VERSION" != "command not found" ]; then
	echo "tar found"
else
	echo "tar NOT found"
fi

echo "Checking xz..."
XZ_VERSION="$(xz --version)"
if [ "$XZ_VERSION" != "command not found" ]; then
	echo "xz found"
else
	echo "xz NOT found"
fi

echo "Checking zip..."
ZIP_VERSION="$(zip -v)"
if [ "$ZIP_VERSION" != "command not found" ]; then
	echo "zip found"
else
	echo "zip NOT found"
fi

