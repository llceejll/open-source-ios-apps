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

Do not run `.github/deploy.sh`.

GitHub Actions link and schema workflows use Ruby 3.3, matching `.github/workflows/pr-approved.yml`. That workflow force-pushes generated markdown to `master` after convert.

## Moved sources

Change a `source` when the old URL redirects to the new repository, or when the destination description is the same project as the catalog entry. Confirmed moves include GitHub account renames, `master` to `main`, the Hedgewars GitHub mirror, and the WWDC22 page for the removed SwiftUI navigation article. Leave `opensourceios/*` mirrors as they are; they are unofficial forks and were not applied.

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
