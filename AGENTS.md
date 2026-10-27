# Agent notes

Catalog entries live in `contents.json`. Regenerate `README.md`, `APPSTORE.md`, `ARCHIVE.md`, and `LATEST.md` with `ruby .github/osia_convert.rb`. After a clean sync with upstream that command should leave the worktree clean.

Upstream is https://github.com/dkhamsing/open-source-ios-apps. This fork's own commits are the Cloud Agent setup plus later catalog repairs. Merge upstream `master` when bringing the list current, and keep `.cursor/`.

## Checks

Ubuntu 24.04 Ruby 3.2 runs the toolchain. `.cursor/install.sh` is idempotent and installs `parallel` 1.20.1, `json_schema` 0.21.0, and `awesome_bot` 1.20.0. `.cursor/environment.json` sets `"user": "ubuntu"`.

```bash
validate-schema .github/schema.json contents.json
ruby .github/osia_validate_categories.rb
```

Required project fields are `title`, `category-ids`, and `source`. An unknown category or a missing `source` exits 1. Link extraction writes `check-unique.txt`, `check-links.txt`, and `check-info.txt`; `awesome_bot` also writes `ab-results*.json`. Delete those before committing.

On 27 October 2026, `awesome_bot check-unique.txt --allow-ssl --allow 302,429,502` checked 2,106 source and screenshot URLs. The only failure was `https://git.shadowfacts.net/shadowfacts/Tusker`, which the link workflow already whitelists as `shadowfacts`.

Generated list links point at `llceejll/open-source-ios-apps`. `suggested_by` values and screenshot files hosted under `dkhamsing/open-source-ios-apps` stay as they are. The footer still credits the original author.

Do not run `.github/deploy.sh`.

GitHub Actions link and schema workflows use Ruby 3.3, matching `.github/workflows/pr-approved.yml`. That workflow force-pushes generated markdown to `master` after convert.

## Moved sources

Change a `source` when the old URL redirects to the new repository and that repository is still the catalogued project. Confirmed moves include GitHub account renames, `master` to `main`, the Hedgewars GitHub mirror, the WWDC22 page for the removed SwiftUI navigation article, and EX Player (`IGRSoft/exTVPlayer` to `Agnidia/exTVPlayer`).

A GitHub redirect is not enough on its own. `fossasia/open-event-organizer-ios` redirects to `fossasia/eventyay-exhibition`, and that repository is now a Python exhibition plugin, so the iOS organizer entry stays on the old URL.

On 27 October 2026 the GitHub API was checked for every repository `source`. 1,626 names already matched. 45 repository URLs returned 404. Those were left in place, including the `opensourceios/*` mirrors, because a mirror is not the original project. The four `gist.github.com` entries return 200. `https://github.com/3003h/Eros-FE` returns 451.

The same day, the 43 sources outside GitHub were checked with HTTP. Linphone's GitLab host fails the TLS handshake, so that entry now uses `BelledonneCommunications/linphone-iphone`, the official mirror. These stayed on their old URLs: Lister's library page redirects to a 404, SwiftStrike's RealityKit article is 404, `ericasadun.com` does not resolve, and the WWDC 2015 and WWDC 2021 links redirect to broad Apple indexes rather than the original pages. `git.shadowfacts.net` returned 200 on that check and remains on the link-check whitelist because it has failed before.

## Pull requests

The cloud agent can push branches. Opening a pull request still fails. Checked again on 27 October 2026 at 11:53 AM Toronto:

- `POST /repos/llceejll/open-source-ios-apps/pulls` returns 403 and requires `pull_requests=write`.
- Cursor's pull-request action returns `must be a collaborator`.
- The repository is public, issues are enabled, and `pull_request_creation_policy` is `all`.
- The only collaborator is `llceejll` (admin). `jordanch14-create` and `cursor` are not collaborators.
- `cursor[bot]` can create an issue. The same token cannot edit, comment on, or close an issue.
- https://github.com/llceejll/open-source-ios-apps/issues/3 asks the admin to invite `jordanch14-create` with Write and to set the Cursor GitHub App's Pull requests permission to Read and write.
- https://github.com/llceejll/open-source-ios-apps/issues/2 is an empty probe from that check. This token cannot close it.

Do not open another issue for the same request, and do not work around a refused pull request by calling `POST /pulls`. The branch to review is `cursor/sync-upstream-catalog-1c12`.
