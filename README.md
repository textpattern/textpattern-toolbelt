# Developer Toolbelt for Textpattern CMS

A collection of tools which help to develop [Textpattern CMS](https://textpattern.com/).

## Contributing

Please see the [Contributing documentation](https://docs.textpattern.com/development/contributing) for details on how to get involved with the project.

## Legal

Licensed under the [GPLv2 license](https://github.com/textpattern/textpattern/blob/main/LICENSE.txt).

## Textpattern release build process

To prepare a development version of Textpattern for stable (production) release, this process should be followed to ensure smooth continued development.

#### Notes

* Semantic versioning is adopted with major.minor.patch standards.
* Development code is suffixed `-dev`.
* Beta releases are suffixed `-beta`, `-beta.2`, `-beta.3`, ...
* Release candidates are suffixed `-rc1`, `-rc2`, `-rc3`, ...
* Any reference to `x.y.z` below refers to the version number and may be suffixed as mentioned.

### Preflight requirements

[WIP]

* local instance of PHP (`php -v`)
* know the intended next release version for resetting the repo after launch

### Step 0: Ensure everything is up-to-date

On GitHub, update `HISTORY.txt` with final added / changed / fixed release note information (but not the release date just yet) and merge to other branch(es) where appropriate.

On your local repo, ensure _all_ branches (i.e. `main`, `dev`, and any feature branches) - are up-to-date by doing this for each one:

```bash
git checkout branch-name
git pull
```

### Step 1: Create release branch based on feature branch

Navigate to the branch from which you wish to make a release, and create a `release-x.y.z` branch for the new version:

```bash
git checkout dev
```

_or_: (if a feature branch):

```bash
git checkout x.y.z
```

then: (for either of the above branch types):

```bash
git checkout -b release-x.y.z
```

### Step 2: Update history

Update `HISTORY.txt` to tag the release with a date stamp.

### Step 3: Set version numbers for all but `textpattern/index.php`

Update version numbers in:
* `README.txt`
* `package.json`
* `README.md` (if possible: might need to be done afterwards, if the file download links have yet to be created).
* The `version` preference value in `textpattern/vendors/Textpattern/DB/Data/core.prefs`.
* The `textpattern.version` value in `textpattern/textpattern.js`.
* Theme manifests:
  * `textpattern/setup/themes/four-point-eight/manifest.json`
  * `textpattern/setup/themes/zero/manifest.json`

### Step 4: Ensure Unix line endings

Check for files containing Windows line-endings (`\r\n`) and convert those to Unix-style. This prevents false 'modified files' alarms for uploads done in FTP ASCII mode.

### Step 5: Verify setup/update scripts match

Because upgrade scripts don't run on new installs, make sure the contents of the `/setup` directory is completely in sync with all that's done in the `/update` scripts. Most of this is handled automatically but any per-user prefs or values injected from the setup process may need to be added by hand.

Also verify that multi-site files such as `.htaccess`, `.htaccess-dist` and `css.php` are up-to-date with their root counterparts.

### Step 6: Commit history and versions

Commit all changes with a commit message of the format `HISTORY and version numbers for x.y.z`.

### Step 7: Bump official version

Edit `textpattern/index.php` to bump main version number.

**Most importantly:**

Release type | Note
------------ | ----
Stable | Set `$txp_is_dev` to `false`, then commit.
Beta | Leave `$txp_is_dev` at `true`, then commit.

### Step 8: Update checksums

Run `checksums.php` from `textpattern-toolbelt` and point it at the `textpattern` directory inside your working branch (not the root):

```php
php /path/to/textpattern-toolbelt/release/checksums.php /path/to/repo/textpattern rebuild
```

Optionally commit with message such as `Checksums for x.y.z`. You may wish to skip this commit if you're confident there are going to be no issues with the release. This is because:

* If there are no issues from the next step, there will be no files with changes upon which to hang the 'this is x.y.z' commit, so you may wish to defer (or skip) committing until after testing.
* If you do find issues, you can commit the current state including checksums, fix / test / commit with atomic commits as usual, then rerun checksums and commit as a final 'This is x.y.z', as mentioned in the next step. 

### Step 9: Test!

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

### Step 10: Merge to the main repo

Merge to `main`:

```bash
git checkout main
git merge release-x.y.z
git push
```

### Step 11: Build the archives

Run the build script. It will build two packaged archive files with corresponding SHA256 checksum files in a temporary location and report where that is. Supply a second argument if you wish to override this destination.

```bash
cd /path/to/repo
/path/to/textpattern-toolbelt/release/txp-gitdist.sh x.y.z
```

### Step 12: Verify archives

Verify archives have been built correctly. Decompress them to check.

### Step 13: Build release on GitHub

Prepare a release for version `x.y.z` on GitHub:
* Set the tag to just the vanilla version number `x.y.z` along with any required `-beta` or `-rc` suffix.
* Ensure the target select box is `main`.
* Use the same tag name for the release Title, but prefix it with a lower case `v`.
* Attach archives and SHA256 checksums.
* If it's a beta or release candidate, ensure the `Pre-release` checkbox is set.

Use `git pull` to bring the new tag down to your local repo's `main` branch.

### Step 14: Add archives to textpattern.com

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

### Step 15: Adjust archive category assignment

Remove the category assignment from previous uploads of a beta / stable releases. Note you can have a stable release and a beta release at the same time, but it's good housekeeping to remove old categories from previous releases. Everything is built automatically based on these category assignments.

### Step 16: Finalise the release blog article

When writing the corresponding article, use the shortcode as follows:

```html
notextile. <txp::media_file filename="textpattern-x.y.z.zip" />
<txp::media_file filename="textpattern-x.y.z.tar.gz" />
```

### Step 17: Update orientation information

Add a section to the 'Get started' article when a beta is available (remove it from here at the end of the beta cycle but leave it in its dedicated article for posterity).

Update the release notes link in 'Get started with Textpattern' to point to the announcement blog post.

### Step 18: Prepare for next version

Prepare for ongoing development:

```bash
git checkout release-x.y.z
```

### Step 19: Set version numbers for next version

Edit the following files to bump version number to next intended release. Ensure they have `-dev` suffix. If this release is a beta or release candidate, it's okay to revert the version number to the same `x.y.z-dev` it was before.

* `/textpattern/index.php`
* `/textpattern/textpattern.js`
* `package.json`

### Step 20: Set `dev` and commit next version

Set `$txp_is_dev` to `true` if it was previously `false`. Commit regardless to ensure version change is applied, using a suitable commit message of the format 'Back to dev'.

### Step 21: Merge release back into dev

Merge release to `dev` so any changes in the release are recorded:

```bash
git checkout dev
git merge release-x.y.z
git push
```

### Step 22: Tidy up branches

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

### Step 23: Tell everyone

Post announcements and gratitude to blog / forum / Twitter / relevant social media.

### Step 24: Update links to latest version in docs, etc

Search through all `textpattern.com` articles to update any outdated version numbers (in case articles were written in advance or features got moved between versions, or reference the download itself).

Update version in `rpc.textpattern.com` (Extensions -> TXP Version).

### Step 25: Relax

Light cigar, pour brandy and wait for the fallout. Sleep if appropriate.
