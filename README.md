# Developer Toolbelt for Textpattern CMS

A collection of tools which help to develop [Textpattern CMS](https://textpattern.com/).

## Contributing

Please see the [Contributing documentation](https://docs.textpattern.com/development/contributing) for details on how to get involved with the project.

## Legal

Licensed under the [GPLv2 license](https://github.com/textpattern/textpattern/blob/main/LICENSE.txt).

## Textpattern release build process

This process prepares a development branch of Textpattern for production release. Follow the steps carefully to ensure a smooth onward journey.

#### Notes

* Semantic versioning is used, with `major.minor.patch` nomenclature.
* Development code is suffixed `-dev`.
* Development code can become a beta release, release candidate and/or production release.
* Beta releases are suffixed `-beta`, `-beta.2`, `-beta.3` and so on.
* Release candidates are suffixed `-rc1`, `-rc2`, `-rc3` and so on.
* References to `x.y.z` below refer to the Textpattern version number and may be suffixed as mentioned.

### Preflight requirements

[WIP]

* Local instance of PHP CLI, `gzip`, `tar` and `zip`.
  * Checks: `php -v`, `gzip -V`, `tar --version` and `zip -v`.
* Know the intended next release version for resetting the repo after launch.
* Know the respective .com file IDs for the `.zip` and `.tar.gz` archives (optional, but saves time later).

### Step 0: Ensure everything is up-to-date

On [textpattern/textpattern](https://github.com/textpattern/textpattern/), update `HISTORY.txt` with final added / changed / fixed release notes, but do not set the release date. Merge to other branch(es) where appropriate.

Locally, ensure _all_ branches (i.e. `main`, `dev`, and any feature branches) are up-to-date:

```bash
git checkout branch-name
git pull
```

### Step 1: Create release branch based on feature branch

Navigate to the branch from which to prepare a release, and create a `release-x.y.z` branch for the new version:

```bash
git checkout dev
```

_or_:

```bash
git checkout x.y.z
```

then:

```bash
git checkout -b release-x.y.z
```

### Step 2: Set version numbers for all but `textpattern/index.php`

Update version number(s) in:

* `README.txt`
* `INSTALL.txt`
* `UPGRADE.txt`
* `package.json`
* `README.md` (if possible: might need to be done afterwards, if the file download links have yet to be created).
* The `version` preference value in `textpattern/vendors/Textpattern/DB/Data/core.prefs`.
* The `textpattern.version` value in `textpattern/textpattern.js`.
* Theme manifests:
  * `textpattern/setup/themes/[default-theme-name]/manifest.json`
  * `textpattern/setup/themes/zero/manifest.json`

### Step 3: Verify setup & update scripts match

Ensure the contents of `textpattern/setup` directory is completely in sync with the `textpattern/update` scripts. Most of this is handled automatically but any per-user prefs or values injected from the setup process may need to be added manually.

Verify that multi-site files such as `.htaccess`, `.htaccess-dist` and `css.php` are up-to-date with their root counterparts.

### Step 4: Commit history and versions

Commit all changes with a commit message of the format `HISTORY and version numbers for x.y.z`.

### Step 5: Update version number

Edit `textpattern/index.php` to update the version number.

**Most importantly:**

Release type | Note
------------ | ----
Stable | Set `$txp_is_dev` to `false`, then commit.
Beta | Leave `$txp_is_dev` at `true`, then commit.

### Step 6: Update checksums

Run `checksums.php` from `textpattern-toolbelt` and point it at the `textpattern` directory inside your working branch (not the root):

```php
php /path/to/textpattern-toolbelt/release/checksums.php /path/to/repo/textpattern rebuild
```

Optionally commit with message such as `Checksums for x.y.z`. You may wish to skip this commit if you're confident there are going to be no issues with the release. This is because:

* If there are no issues from the next step, there will be no files with changes upon which to hang the 'this is x.y.z' commit, so you may wish to defer (or skip) committing until after testing.
* If you do find issues, you can commit the current state including checksums, fix / test / commit with atomic commits as usual, then rerun checksums and commit as a final 'This is x.y.z', as mentioned in the next step.

### Step 7: Test!

Copy the entire bundle to a local directory and test. Things to look for:

1. New installation/setup works.
2. Upgrade from (populated) recent versions works.
3. Multi-site installations work.
4. Automated installations work.
5. Version numbers are reported correctly throughout.
6. The High Diagnostics panel reports everything correctly.
7. Public tags provide expected output.
8. Runs on as many versions of PHP, MySQL (and own-brand equivalents), Apache, Nginx.
9. Interface UI strings are all assigned English labels.
10. Left over files that need deleting.

Fix anything that doesn't work, and commit changes to the `release-x.y.z` branch. Run checksums again if required and commit with message such as `This is x.y.z`.

### Step 8: Update history

Update `HISTORY.txt` to tag the release with a date stamp.

### Step 9: Merge to the main repo

Merge to `main`:

```bash
git checkout main
git merge release-x.y.z
git push
```

### Step 10: Build the archives

Run the build script. It will build two packaged archive files with corresponding SHA256 checksum files in a temporary location and report where that is. Supply a second argument if you wish to override this destination.

```bash
cd /path/to/repo
/path/to/textpattern-toolbelt/release/txp-gitdist.sh x.y.z
```

### Step 11: Verify archives

Verify archives have been built correctly. Decompress them to check.

### Step 12: Build release on GitHub

Prepare a release for version `x.y.z` on GitHub:
* Set the tag to just the vanilla version number `x.y.z` along with any required `-beta` or `-rc` suffix.
* Ensure the target select box is `main`.
* Use the same tag name for the release Title, but prefix it with a lower case `v`.
* Attach archives and SHA256 checksums.
* If it's a beta or release candidate, ensure the `Pre-release` checkbox is set.

Use `git pull` to bring the new tag down to your local repo's `main` branch.

### Step 13: Add archives to textpattern.com

Upload archives to textpattern.com website. Ensure they comply with the semantic filename versioning rules.

For each uploaded file, select the appropriate file category:

```
Current release (Zip format)
Current release (Gzip format)
Current beta release (Zip format)
Current beta release (Gzip format)
```

Make sure the `Title` and `Description` fields are filled out correctly (see previous files for examples of this).
`Title` holds the release version number.
`Description` houses the SHA256 token.

### Step 14: Adjust archive category assignment

Remove the category assignment from previous uploads of a beta / stable releases. Note you can have a stable release and a beta release at the same time, but it's good housekeeping to remove old categories from previous releases. Everything is built automatically based on these category assignments.

### Step 15: Finalise the release blog article

When writing the corresponding article, use the shortcode as follows:

```html
notextile. <txp::media_file filename="textpattern-x.y.z.zip" />
<txp::media_file filename="textpattern-x.y.z.tar.gz" />
```

### Step 16: Update orientation information

Add a section to the 'Get started' article when a beta is available (remove it from here at the end of the beta cycle but leave it in its dedicated article for posterity).

Update the release notes link in 'Get started with Textpattern' to point to the announcement blog post.

### Step 17: Prepare for next version

Prepare for ongoing development:

```bash
git checkout release-x.y.z
```

### Step 18: Set version numbers for next version

Edit the following files to bump version number to next intended release. Ensure they have `-dev` suffix. If this release is a beta or release candidate, it's okay to revert the version number to the same `x.y.z-dev` it was before.

* `package.json`
* `/textpattern/index.php`
* The `version` preference value in `textpattern/vendors/Textpattern/DB/Data/core.prefs`.
* The `textpattern.version` value in `textpattern/textpattern.js`.

### Step 19: Set `dev` and commit next version

Set `$txp_is_dev` to `true` if it was previously `false`. Commit regardless to ensure version change is applied, using a suitable commit message of the format 'Back to dev'.

### Step 20: Merge release back into dev

Merge release to `dev` so any changes in the release are recorded:

```bash
git checkout dev
git merge release-x.y.z
git push
```

### Step 21: Tidy up branches

Delete release branch as it has served its purpose:

```bash
git branch -d release-x.y.z
```

You might have to use `-D` switch if the branch deletion complains it's 'unmerged': that's because we just modified it ready for returning to `dev`. It depends if the release branch was mistakenly pushed to the central repo or not. If so:

```bash
git push origin --delete release-x.y.z
```

If you've just released a feature branch (i.e. patch, not minor/major dev release) then there'll be the old `x.y.z` branch on your local and remote servers. Once you're absolutely sure that the merge back to dev from `release-x.y.z` has completed and pushed to the server successfully, you can remove your local and remote `x.y.z` branches:

```bash
git branch -d x.y.z
git push origin --delete x.y.z
```

### Step 22: Update textpattern.com web server configuration

* note: only for production releases.

The textpattern.com configuration is [here](https://github.com/textpattern/server-config/blob/main/servers/files/trumpet.textpattern.com/etc/nginx/sites-available/www.textpattern.com.conf), search for `#start release vars`.

* set `txpver_1b8835e8` variable to release version in semver format (e.g. `1.2.3`).
* set `$targzid_1b8835e8` to the Textpattern file ID for the .tar.gz archive (e.g `123`).
* set `$zipid_1b8835e8` to the Textpattern file ID for the .zip archive (e.g `124`).
* upload the file to `/etc/nginx/sites-available/www.textpattern.com.conf` (or modify in place).
* restart Nginx (i.e. `sudo systemctl restart nginx`).

Check downloads for the following:

* https://textpattern.com/latest.tar.gz
* https://textpattern.com/latest.zip
* https://textpattern.com/pophelp-download
* https://textpattern.com/textpack-download

### Step 23: Tell everyone

Post announcements and gratitude to blog / forum / Twitter / relevant social media.

### Step 24: Update links to latest version in docs, etc

Search through all `textpattern.com` articles to update any outdated version numbers (in case articles were written in advance or features got moved between versions, or reference the download itself).

Update version in `rpc.textpattern.com` (Extensions -> TXP Version).

### Step 25: Relax

Light cigar, pour brandy and wait for the fallout. Sleep if appropriate.
