# Developer Toolbelt for Textpattern CMS

A collection of tools which help to develop [Textpattern CMS](https://textpattern.com/).

## Contributing

Please see the [Contributing documentation](https://docs.textpattern.io/development/contributing) for details on how to get involved with the project.

## Legal

Licensed under the [GPLv2 license](https://github.com/textpattern/textpattern/blob/master/LICENSE.txt).

## Textpattern release build process

When it comes time to bundle up a development version for release, the following process should be followed to ensure smooth continued development.

#### Notes

* Semantic versioning is adopted with major.minor.patch standards.
* Development code is suffixed `-dev`.
* Beta code is suffixed `-beta`, `-beta.2`, `-beta.3`, ...
* Any reference to `x.y.z` below refers to the version number and may be suffixed as mentioned.

### Step 1

From the dev branch, create a `release-x.y.z` branch for the new version:

```
git checkout -b release-x.y.z dev
```

### Step 2

Update HISTORY.txt and write an announcement for the blog, forum, and the mailinglist txp-announce@ (don't post yet).

3. Update version number in README.txt / README.md and theme mainfests.

4. Check for files containing Windows line-endings (`\r\n`) and convert those to Unix-style. Prevents false 'modified files' alarms for uploads done in FTP ASCII mode.

5. Because upgrade scripts don't run on new installs, make sure the contents of the `setup` directory is completely in sync with all that's done in the /update scripts. Most of this is handled automatically but any per-user prefs or values injected form the setup process may need to be added by hand.

6. Commit all changes with commit message:

```
HISTORY and version numbers for x.y.z
```

7. Edit `/textpattern/index.php` to bump version number. **Most importantly:**

Release type | Note
------------ | ----
Stable | Set `$txp_is_dev` to `false`, then commit.
Beta | Leave `$txp_is_dev` at `true`, then commit.

8. Run `checksums.php` from textpattern-toolbelt and commit:

```php
php /path/to/textpattern-toolbelt/release/checksums.php /path/to/dev/textpattern rebuild
```

9. Copy the entire bundle to a local directory and test. Things to look for:

   1. New installation/setup works.
   2. Upgrade from (populated) recent versions works.
   3. Multi-site installations work.
   4. Automated installations work.
   5. Version numbers are reported correctly throughout.
   6. The High Diagnostics panel reports everything correctly.
   7. Public tags provide expected output.
   8. Runs on as manay versions of PHP, MySQL (or off-brand equivalents), Apache, Nginx.
   9. Left over files that need deleting.

Fix anything that doesn't work, and commit changes to the `release-x.y.z` branch. Run checksums again if required and commit.

10. Merge to master:

```bash
git checkout master
git merge release-x.y.z
git push
```

11. Run build script. It will build two package files in a temporary location and report where that is. Supply a second argument if you wish to override this destination.

```bash
cd /path/to/repo
/path/to/textpattern-toolbelt/release/txp-gitdist.sh x.y.z
```

12. Verify packages have been built correctly. Unzip them to check.

13. Prepare a release for vx.y.z on GitHub, and attach packages. A tag will be created. Use `git pull` to bring the new tag down to your local repo.

14. Generate SHA256 checksums for the download package(s) (using CLI or an online tool). Copy for later use.

15. Upload packages to textpattern.com website. Ensure they comply with the semantic filename versioning rules.

For each uploaded file, select the appropriate file category:

```
Current release (Zip format)
Current release (Gzip format)
Current beta release (Zip format)
Current beta release (Gzip format)
```

Make sure the `Title` and `Description` fields are filled out correctly (see previous files for examples of this).

16. Remove the category assignment from previous uploads of a beta / stable releases. Note you can have a stable release and a beta release at the same time, but it's good housekeeping to remove old categories from previous releases. Everything is built automatically based on these category assignments.

17. When writing the corresponding article, use the shortcode as follows:

```html
notextile. <txp::media_file filename="textpattern-x.y.z.zip" sha256="a868c05fc37108f2bb5e878cfbcdc61a82ce2646c4676cccb8105a6c6277be7a" />
<txp::media_file filename="textpattern-x.y.z.tar.gz" sha256="77b12daf91a9a2762f9df7b410c43d05e7ab7a12e32614f534f49b910b3ec303" />
```

18. Add a section to the 'Get started' article when a beta is available (remove it from here at the end of the beta cycle but leave it in its dedicated article for posterity).

19. Prepare for ongoing development:

```bash
git checkout release-x.y.z
```

20. Edit `/textpattern/index.php` to bump version number to next minor release. Ensure it has `-dev` suffix.

21. Set `$txp_is_dev` to `true` if it was previously `false`, then commit.

22. Merge release to dev so any changes in the release are recorded:

```bash
git checkout dev
git merge release-x.y.z
git push
```

23. Delete release branch as it has served its purpose.

```bash
git branch -d release-x.y.z
```

24. You might have to use `-D` switch if the branch deletion complains it's 'unmerged': that's because we just modified it ready for returning to dev. It depends if the release branch was pushed to the central repo or not. If so:

```bash
git push origin —-delete release-x.y.z
```

25. Post announcements to forum / twitter / relevant social media.

26. Search through all textpattern.com articles to update any outdated version numbers (in case articles were written in advance or features got moved between versions, or reference the download itself).

27. Light cigar and wait for the fallout. Sleep.
