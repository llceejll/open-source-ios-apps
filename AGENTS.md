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

The cloud agent can push branches. Opening a pull request still fails: the installation token's accepted permission for `POST /repos/llceejll/open-source-ios-apps/pulls` is `pull_requests=write`, and `ManagePullRequest` returns `must be a collaborator`. The repository is public, issues are enabled, and `pull_request_creation_policy` is `all`. The only collaborator is `llceejll` (admin). `jordanch14-create` and `cursor` are not collaborators. The admin has to invite the Cursor GitHub account with Write, and the Cursor GitHub App needs Pull requests set to Read and write. Do not work around a refused `ManagePullRequest` with `gh` or the REST API.
