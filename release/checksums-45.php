<?php

/*
 * Textpattern Content Management System
 * https://textpattern.com/
 *
 * Copyright (C) 2005 Dean Allen
 * Copyright (C) 2017 The Textpattern Development Team
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
require_once(txpath.'/include/txp_diag.php');


function get_info() {
	global $files;

	$out = array();
   foreach ($files as $f) {
		$md5 = md5_file(txpath . $f);
      $lines = @file(txpath . $f);
      $rev = '';
      if ($lines) {
         foreach ($lines as $line) {
            if (preg_match('/^\$'.'LastChangedRevision: (\w+) \$/', $line, $match)) {
               $rev = $match[1];
					break;
            }
         }
      }

		$out[] = "$f" . cs. 'r'.$rev.' ('.$md5.')';
   }
	return $out;
}

echo join("\n", get_info())."\n";
