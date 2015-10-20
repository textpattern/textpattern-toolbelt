<?php

/*
 * Textpattern Content Management System
 * http://textpattern.com
 *
 * Copyright (C) 2005 Dean Allen
 * Copyright (C) 2015 The Textpattern Development Team
 *
 * This file is part of Textpattern.
 *
 * Textpattern is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, version 2.
 *
 * Textpattern is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Textpattern. If not, see <http://www.gnu.org/licenses/>.
 */

define('txpinterface', 'cli');

if (php_sapi_name() !== 'cli')
	die('command line only');

if (empty($argv[1]))
	die("usage: {$argv[0]} <txpath>\n");

define('txpath', rtrim(realpath($argv[1]), '/'));
define('n', "\n");

$event = '';
$prefs['enable_xmlrpc_server'] = true;
require_once(txpath.'/lib/constants.php');
require_once(txpath.'/lib/txplib_misc.php');

foreach (check_file_integrity(INTEGRITY_MD5) as $file => $md5) {
	echo "$file: $md5".n;
}
