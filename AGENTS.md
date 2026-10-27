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

## Homepages

Update a `homepage` when a GET follows a redirect to the same product, or when the project names a replacement and the old host is dead. A 403 that returns a Cloudflare challenge, an empty 202, or a certificate error on a page that is no longer the catalogued app stays unchanged.

Applied on 27 October 2026: HealthSync to `healthysync.app`, Tutanota to `tuta.com`, Expo to `expo.dev`, Proton Mail to `proton.me/mail`, kDrive to `/en/ksuite/kdrive`, Fud AI to `www.fud-ai.app`, Miataru from the forbidden `/ios/` path to `miataru.com`, and Nightguard from `www.nightscout.info` to `nightscout.github.io`. `nightscout.info` redirects to `nightcoutfoundation.org`, which does not resolve. The Nightscout README calls `nightscout.github.io` the current documentation and `nightscout.info` the older docs.

A later check the same day requested every active homepage and every active source outside GitHub. StarPlane and the Overcast drawer animation now use the `x.com` status URL that `twitter.com` returns with HTTP 301 and the same status id. Migraine Log now uses `https://migrainelog.zerodogg.org/en` (HTTP 302, title “Migraine Log”). NoteGen now uses `https://notegen.top/en` (HTTP 307; the page still brands NoteGen and links the `codexu/note-gen` repository). Zulip returned 502 once and 200 on the next request, so `https://zulip.com` stayed. The footer contact `twitter.com/dkhamsing` and the `@opensourceios` badge still 301 to the same accounts on `x.com`. Those credit links stay on `twitter.com`.

Description links follow the same redirect rule. Designer News (`www.designernews.co` HTTP 308 to `designernews.co`, title “Designer News”), Invoice Ninja (`www.invoiceninja.com` HTTP 301 to `invoiceninja.com`, title “Invoice Ninja”), and Earth View (`earthview.withgoogle.com` HTTP 301 to the Chrome Web Store listing “Earth View from Google Earth”, contact `earth-view@google.com`) now use the page the old URL opens. `punkapi.dev` is a different project, so the Beers description stays on `punkapi.com`. `libgen.rs` timed out and stayed.

Left in place after a browser GET: Habitica (`/static/home` returns 200), Kodi, Catrobat, TousAntiCovid, Thunderbird, and Autheris (Cloudflare 403), Strongbox (empty 202), Emission (the Berkeley host's certificate fails and the page is Berkeley Architecture Research, not the travel app), and Bean Juice (the studio work page is a 404). The latest-additions heading in `.github/osia_convert.rb` was `Lastest`; generated `LATEST.md` now says `Latest`.

## Screenshots

`ARCHIVE.md` lists titles and sources only, so a dead archived screenshot stays invisible until `contents.json` is checked. On 27 October 2026, 1,275 unique archived screenshots were requested. 284 returned 404. A screenshot URL was replaced only when the same file on the catalogued source, or the same filename after a branch move, returned an image. That covers NaughtyKeyboard, SwiftTextClock, Sol (`master` to `main`), 360 VR Player (`Example/Screenshot/PlayDemo.gif`), and the `opensourceios` repositories already used as `source` for Keinex, Retriever, LunarCore, Showio, CZInstagram, AccountBook, AR Plastic Ocean, notGIF, Wordflick, and AppleWatchFaces. Apple CDN (`mzstatic.com`) 404s and screenshots whose repository is gone were left.

The same day, 63 archived homepages were checked. Task Coach, Bitrise, the 花灰 tweet (`twitter.com` to `x.com` with the same status id), and Status (`status.im` to `status.app`) now use the page the old URL redirects to. These stayed: Dash for iOS redirects to the macOS product page, BoardBank's domain is now a personal résumé, TriangleDraw's domain is an unrelated page, and the Ireland COVID Tracker redirect returns 404. Of 528 unique App Store links, 165 return 404 and none redirect to a different app id.

When HTTPS fails the certificate check and the same path over HTTP returns the page or image, the entry uses HTTP. That covers Swab (`http://swabthe.com/`, title still the creative-ad blocker), the PropertyCross thumbnails, BrewMobile `8_small.png`, and 16 Apple CDN screenshots. The Bread screenshot on `is2.mzstatic.com` was the last HTTPS URL in the catalog whose certificate check failed and whose HTTP path returned `image/jpeg`. BrewMobile `9_small.png` stays on HTTPS because HTTP returns 403. Emission and Bean Juice stay, because the pages served after ignoring the certificate are not those apps. The iOS 10 Day by Day demo gif now points at `App_Demo.gif` in `ScottLogic/iOS10-day-by-day`.

The 249 archived `aN.mzstatic.com` screenshots that returned `404 application/json` were requested again at low concurrency and still return that 404. Rewriting the host to `isN-ssl.mzstatic.com` returns 403 HTML, so those URLs stayed. Other `aN.mzstatic.com` URLs in the catalog still return `200 image/jpeg`.

The remaining non-Apple archived screenshot failures were searched in each live source repository for the same filename. None of those files are present. AppleWatchProductHunt has `sc1.png`, `sc2.png`, and `sc3.png`. iStockcheck has `Screenshot.png`. PGPro has Fastlane screenshots with different names. Those URLs stayed.

MoodSnap’s screenshot URL had a trailing `)`. With that character the GitHub asset returns 404. Without it, the same asset returns HTTP 302 to `image/jpeg` (JFIF, 166,363 bytes). The parenthesis is removed and the asset URL is unchanged.

## Pull requests

The cloud agent can push branches. Opening a pull request still fails. Checked again on 27 October 2026 at 12:43 PM Toronto. Upstream `master` was still `28722ee0`, and this branch already contains it. `jordanch14-create` was still not a collaborator.

- `POST /repos/llceejll/open-source-ios-apps/pulls` returns 403 and requires `pull_requests=write`.
- Cursor's pull-request action returns `must be a collaborator`.
- The repository is public, issues are enabled, and `pull_request_creation_policy` is `all`.
- The only collaborator is `llceejll` (admin). `jordanch14-create` and `cursor` are not collaborators.
- `cursor[bot]` can create an issue. The same token cannot edit, comment on, or close an issue.
- https://github.com/llceejll/open-source-ios-apps/issues/3 asks the admin to invite `jordanch14-create` with Write and to set the Cursor GitHub App's Pull requests permission to Read and write.
- https://github.com/llceejll/open-source-ios-apps/issues/2 is an empty probe from that check. This token cannot close it.

Do not open another issue for the same request, and do not work around a refused pull request by calling `POST /pulls`. The branch to review is `cursor/sync-upstream-catalog-1c12`.
