# Developer Toolbelt for Textpattern CMS

A collection of tools which help to develop [Textpattern CMS](https://textpattern.com/).

## Contributing

Please see the [Contributing documentation](https://docs.textpattern.com/development/contributing) for details on how to get involved with the project.

## Legal

Licensed under the [GPLv2 license](https://github.com/textpattern/textpattern/blob/main/LICENSE.txt).

## Textpattern release build process

When it comes time to bundle up a development version for release, the following process should be followed to ensure smooth continued development.

#### Notes

* Semantic versioning is adopted with major.minor.patch standards.
* Development code is suffixed `-dev`.
* Beta releases are suffixed `-beta`, `-beta.2`, `-beta.3`, ...
* Release candidates are suffixed `-rc1`, `-rc2`, `-rc3`, ...
* Any reference to `x.y.z` below refers to the version number and may be suffixed as mentioned.

### Step 1

Hop to the branch from which you wish to make a release, and create a `release-x.y.z` branch for the new version:

```
git checkout dev
git checkout -b release-x.y.z
```

### Step 2

Update `HISTORY.txt` with final release notes, tag release with date stamp.

### Step 3

Update version numbers in:
* `README.txt`
* `package.json`
* `README.md` (if possible: might need to be done afterwards, if the file download links have yet to be created).
* The `version` pref val in `textpattern/vendors/Textpattern/DB/Data/core.prefs`.
* The `textpattern.version` `value in textpattern.js`.
* Theme manifests.

### Step 4

Check for files containing Windows line-endings (`\r\n`) and convert those to Unix-style. This prevents false 'modified files' alarms for uploads done in FTP ASCII mode.

### Step 5

Because upgrade scripts don't run on new installs, make sure the contents of the `/setup` directory is completely in sync with all that's done in the `/update` scripts. Most of this is handled automatically but any per-user prefs or values injected from the setup process may need to be added by hand.

Also verify that multi-site files such as `.htaccess`, `.htaccess-dist` and `css.php` are up-to-date with their root counterparts.

### Step 6

Commit all changes with commit message such as `HISTORY and version numbers for x.y.z`.

### Step 7

Edit `/textpattern/index.php` to bump main version number.

**Most importantly:**

Release type | Note
------------ | ----
Stable | Set `$txp_is_dev` to `false`, then commit.
Beta | Leave `$txp_is_dev` at `true`, then commit.

### Step 8

Run `checksums.php` from `textpattern-toolbelt`:

```php
php /path/to/textpattern-toolbelt/release/checksums.php /path/to/dev/textpattern rebuild
```
Commit with message such as `Checksums for x.y.z`.

### Step 9

Copy the entire bundle to a local directory and test. Things to look for:

1. New installation/setup works.
2. Upgrade from (populated) recent versions works.
3. Multi-site installations work.
4. Automated installations work.
5. Version numbers are reported correctly throughout.
6. The High Diagnostics panel reports everything correctly.
7. Public tags provide expected output.
8. Runs on as many versions of PHP, MySQL (or off-brand equivalents), Apache, Nginx.
9. Interface UI strings are all assigned English labels.
10. Left over files that need deleting.

Fix anything that doesn't work, and commit changes to the `release-x.y.z` branch. Run checksums again if required and commit with message such as `This is x.y.z`.

### Step 10

Merge to `main`:

```bash
git checkout main
git merge release-x.y.z
git push
```

### Step 11

Run build script. It will build two package files with corresponding SHA256 checksum files in a temporary location and report where that is. Supply a second argument if you wish to override this destination.

```bash
cd /path/to/repo
/path/to/textpattern-toolbelt/release/txp-gitdist.sh x.y.z
```

### Step 12

Verify packages have been built correctly. Decompress them to check.

### Step 13

Prepare a release for version x.y.z on GitHub:
* Set the tag to just the vanilla version number `x.y.z` along with any required `-beta` or `-rc` suffix.
* Ensure the target select box is `main`.
* Use the same tag name for the release Title, but prefix it with a lower case `v`.
* Attach packages and SHA256 checksums.
* If it's a beta or release candidate, ensure the `Pre-release` checkbox is set.

Use `git pull` to bring the new tag down to your local repo's `main` branch.

### Step 14

Upload packages to textpattern.com website. Ensure they comply with the semantic filename versioning rules.

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

### Step 15

Remove the category assignment from previous uploads of a beta / stable releases. Note you can have a stable release and a beta release at the same time, but it's good housekeeping to remove old categories from previous releases. Everything is built automatically based on these category assignments.

### Step 16

When writing the corresponding article, use the shortcode as follows:

```html
notextile. <txp::media_file filename="textpattern-x.y.z.zip" />
<txp::media_file filename="textpattern-x.y.z.tar.gz" />
```

### Step 17

Add a section to the 'Get started' article when a beta is available (remove it from here at the end of the beta cycle but leave it in its dedicated article for posterity).

### Step 18

Prepare for ongoing development:

```bash
git checkout release-x.y.z
```

### Step 19

Edit the following files to bump version number to next release. Ensure they have `-dev` suffix. If this release is a beta or release candidate, it's okay to revert the version number to the same `x.y.z-dev` it was before.

* `/textpattern/index.php`
* `/textpattern/textpattern.js`
* `package.json`

### Step 20

Set `$txp_is_dev` to `true` if it was previously `false`. Commit regardless to ensure version change is applied.

### Step 21

Merge release to `dev` so any changes in the release are recorded:

```bash
git checkout dev
git merge release-x.y.z
git push
```

### Step 22

Delete release branch as it has served its purpose.

```bash
git branch -d release-x.y.z
```

You might have to use `-D` switch if the branch deletion complains it's 'unmerged': that's because we just modified it ready for returning to `dev`. It depends if the release branch was pushed to the central repo or not. If so:

```bash
git push origin —-delete release-x.y.z
```

### Step 23

Post announcements to blog / forum / twitter / relevant social media.

### Step 24

Search through all textpattern.com articles to update any outdated version numbers (in case articles were written in advance or features got moved between versions, or reference the download itself).

### Step 25

Light cigar and wait for the fallout. Sleep.
