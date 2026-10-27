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

The link workflow whitelist is a substring match. Two entries matched no current catalog URL and were removed. `263bb0f74818` was an OpenNutriTracker screenshot replaced in upstream `#1901`. `linphone.org` was the old GitLab host; Linphone's source is now `BelledonneCommunications/linphone-iphone`. The 17 Medium CDN screenshots and the FTC Scorer Giphy file that the remaining tokens cover returned an image on GET the same day.

Generated list links point at `llceejll/open-source-ios-apps`. `suggested_by` values and screenshot files hosted under `dkhamsing/open-source-ios-apps` stay as they are. The footer still credits the original author.

License display is commented out in `.github/osia_convert.rb`, and `suggested_by` is not rendered, so correcting either field leaves the generated lists unchanged. `suggested_by` is optional. Star Wars had `license` set to `mit` and `suggested_by` set to `apache-2.0`. That `suggested_by` string was written in the 22 November 2021 add, and it is a license id, not a person. The repository `LICENSE` is Apache-2.0, so the license field is now `apache-2.0` and `suggested_by` is removed. Do not invent a suggester.

The converter matches `swift` with `tags.include? 'swift'`, which does not match a comma-joined string. GitTime was the only entry with a comma inside a tag (`swift, reactorkit, rxswift`). The repository languages include Swift, and its description names ReactorKit, RxSwift, and Moya, so that tag is now `swift`, `reactorkit`, and `rxswift`, with `moya` and `archive` kept. GitTime is archived, so `ARCHIVE.md` did not change. Tags that contain a space and no comma, such as `flickr api`, stay as one tag.

On 27 October 2026, GitHub's detected license was compared with every GitHub `source`. A missing license, or a license of `other`, was filled only when the detected key is one of the schema values and is not `other`. That filled 83 entries, including the three list files in `dkhamsing/open-source-ios-apps` (`cc0-1.0`). A specific catalog license was left in place when GitHub reported `other`. `fossasia/open-event-organizer-ios` still resolves to `fossasia/eventyay-exhibition`, so that entry did not take the exhibition repository's license. `eupl-1.2` and `0bsd` are outside the schema enum and were not written. License text is not rendered, so the generated lists stayed the same.

A specific catalog license was corrected when the repository `LICENSE` file opens with that other license and GitHub reports the same key. That corrected 53 entries. Judge the file by its opening lines. The Mozilla Public License text mentions the GPL later in the file, and that mention is not the project's license. DNSCloak and Nio open with MPL 2.0. SIP Calculator opens with GPL 2.

On 27 October 2026, a missing `stars` field was filled when the `source` is a GitHub repository root and the repository exists. That filled 40 entries. Those entries kept a missing `updated` field. A new push timestamp ranks the app above entries whose stored dates are older snapshots, and `LATEST.md` “Most recently updated” then lists the newly stamped apps first. Both `stars` and `updated` were replaced when a source move had left the previous repository’s metadata: the star count differs by 10 or more, one of the two fields is missing, or the calendar day differs and the star count differs by 5 or more. That replaced 11 entries (Savings Assistant, NaughtyKeyboard, Locative, That Movie With, my41, Hedgewars, SwiftTextClock, Helio Workstation, Linphone, ConfFriends, Fivey). A repository with 0 stars stays at 0. The converter prints a star badge only when the count is greater than 0. A source that points at a file or directory inside a repository does not take that repository’s star count.

Pomelo’s `updated` value was `2024-12-4 7:16 UTC`. That string is 4 December 2024 at 07:16:00 UTC, and the field is now `2024-12-04 07:16:00 UTC`. GitLab’s later `last_activity_at` was left unused, because that clock includes activity other than the commit the catalog recorded.

`date_added` was filled only when the commit that added the project omitted it and a neighboring entry from that day already uses a calendar date. Wei Wallet is `May 31 2018` (commit `6e2c9cc9`, 31 May 2018). AltStore and OctoPod are `Sep 29 2019` (commits `ac0718a4` and `f2095d34`, 29 September 2019). Those dates sit outside the thirty newest additions, so `LATEST.md` stays the same. The four entries tagged `list` stay without `date_added`.

A repeated tag was removed when the same string appeared twice on one project. fudge had `archive` twice. DumpertTV had `cloudkit` twice. Conduck had `swiftui` twice. `top shelf` stays one tag.

On 27 October 2026 the generated lists were matched to catalog sources. Every active source is in `README.md`, and every archived source is in `ARCHIVE.md`. The extra links in those files are the category jump list and the footer contact lines. The 46 missing GitHub repositories still return 404, and `3003h/Eros-FE` still returns 451. The 21 `http://` URLs still fail the certificate check when requested over HTTPS. Fifteen active repository roots are stored with 0 stars. Paint Anytime, MirrorNotes, Calorie, and Anchor now have 1 star on GitHub. A one-star change is below the threshold for replacing a stored count, so those fields stayed 0.

Project objects in `contents.json` are not indented the same way. Some openers use six spaces or a tab, and some closers put a tab between `}` and the comma. An edit has to walk to the `{` and `}` lines of that object. Matching a fixed four-space closer writes the next project’s stars into the previous project.

Do not run `.github/deploy.sh`, `.github/osia_update_github.rb`, `.github/osia_update_lic.rb`, or `.github/osia_update_history.rb`. The GitHub updater rewrites the whole file and refreshes every star count and push time.

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

Category descriptions follow that rule too. SpriteKit now uses `developer.apple.com/documentation/spritekit` (HTTP 301 from `/reference/spritekit`, title “SpriteKit”). ResearchKit now uses `https://www.researchandcare.org/` (HTTP 301 from `apple.com/researchkit/`, title “ResearchKit & CareKit”). Xamarin now uses `https://dotnet.microsoft.com/en-us/apps/xamarin` (HTTP 301 from `xamarin.com`, title “Mobile development with Xamarin”). Realm now uses the Atlas Device SDK deprecation page that `realm.io` opens. `cocos2d.org` fails the TLS handshake, and the HTTP page is a WHOIS notice, so that link stayed.

Left in place after a browser GET: Habitica (`/static/home` returns 200), Kodi, Catrobat, TousAntiCovid, Thunderbird, and Autheris (Cloudflare 403), Strongbox (empty 202), Emission (the Berkeley host's certificate fails and the page is Berkeley Architecture Research, not the travel app), and Bean Juice (the studio work page is a 404). The latest-additions heading in `.github/osia_convert.rb` was `Lastest`; generated `LATEST.md` now says `Latest`.

## Screenshots

`ARCHIVE.md` lists titles and sources only, so a dead archived screenshot stays invisible until `contents.json` is checked. On 27 October 2026, 1,275 unique archived screenshots were requested. 284 returned 404. A screenshot URL was replaced only when the same file on the catalogued source, or the same filename after a branch move, returned an image. That covers NaughtyKeyboard, SwiftTextClock, Sol (`master` to `main`), 360 VR Player (`Example/Screenshot/PlayDemo.gif`), and the `opensourceios` repositories already used as `source` for Keinex, Retriever, LunarCore, Showio, CZInstagram, AccountBook, AR Plastic Ocean, notGIF, Wordflick, and AppleWatchFaces. Apple CDN (`mzstatic.com`) 404s and screenshots whose repository is gone were left.

The same day, 63 archived homepages were checked. Task Coach, Bitrise, the 花灰 tweet (`twitter.com` to `x.com` with the same status id), and Status (`status.im` to `status.app`) now use the page the old URL redirects to. These stayed: Dash for iOS redirects to the macOS product page, BoardBank's domain is now a personal résumé, TriangleDraw's domain is an unrelated page, and the Ireland COVID Tracker redirect returns 404. A later check the same day found `projectm.sourceforge.net` returning HTTP 302 to `https://github.com/projectM-visualizer/projectm`, whose description is “projectM - Cross-platform Music Visualization Library.” The homepage now uses that repository. The SourceForge project page still returns 200 with the title “projectM download,” so the source stays there. Of 528 unique App Store links, 165 return 404 and none redirect to a different app id. Checked again on 27 October 2026: all 528 are still on `apps.apple.com`, every URL has an app id, and none follow a redirect to a different id.

When HTTPS fails the certificate check and the same path over HTTP returns the page or image, the entry uses HTTP. That covers Swab (`http://swabthe.com/`, title still the creative-ad blocker), the PropertyCross thumbnails, BrewMobile `8_small.png`, and 16 Apple CDN screenshots. The Bread screenshot on `is2.mzstatic.com` was the last HTTPS URL in the catalog whose certificate check failed and whose HTTP path returned `image/jpeg`. BrewMobile `9_small.png` stays on HTTPS because HTTP returns 403. Emission and Bean Juice stay, because the pages served after ignoring the certificate are not those apps. The iOS 10 Day by Day demo gif now points at `App_Demo.gif` in `ScottLogic/iOS10-day-by-day`.

The 21 `http://` URLs still in the catalog were requested again over HTTPS. Twenty still fail the certificate check (curl 60). Molecules fails the handshake (curl 35). Those entries stay on HTTP.

The 249 archived `aN.mzstatic.com` screenshots that returned `404 application/json` were requested again at low concurrency and still return that 404. Rewriting the host to `isN-ssl.mzstatic.com` returns 403 HTML, so those URLs stayed. Other `aN.mzstatic.com` URLs in the catalog still return `200 image/jpeg`.

A later pass requested all 1,055 `mzstatic.com` screenshots. Compass and TKeyboard return HTTP 410, and the same path on `isN-ssl.mzstatic.com` is 403 HTML. Open States uses `s3.mzstatic.com` and that URL returns `404 application/json`; the `is3-ssl` copy of the path is 403 HTML. Those three stayed. Timeouts against `isN-ssl.mzstatic.com` at six-way concurrency were the client: each of those URLs returned `image/jpeg` on a single retry, including ChatSecure.

The remaining non-Apple archived screenshot failures were searched in each live source repository for the same filename. None of those files are present. AppleWatchProductHunt has `sc1.png`, `sc2.png`, and `sc3.png`. iStockcheck has `Screenshot.png`. PGPro has Fastlane screenshots with different names. Those URLs stayed.

MoodSnap’s screenshot URL had a trailing `)`. With that character the GitHub asset returns 404. Without it, the same asset returns HTTP 302 to `image/jpeg` (JFIF, 166,363 bytes). The parenthesis is removed and the asset URL is unchanged.

A HEAD request to `github.com/.../assets/` and `user-attachments` URLs often returns 403. GET follows the redirect and returns the image. Those URLs stay. `user-images.githubusercontent.com` and `cloud.githubusercontent.com` samples return the image on GET.

Two more GitHub screenshot paths return 404 after the default branch redirect. `atrinh0/covid19` removed `images/graphs.png` in commit `484ab79bdb` on 12 November 2022. Delta Chat removed `docs/images/screenshot_chat_view.png` and `docs/images/screenshot_chat_list.png` in 2025. Those commits delete the files. They do not rename them, so the catalog URLs stay.

A GitHub `blob` screenshot URL without `?raw=true` returns the HTML file page. On 27 October 2026, 52 of those URLs returned `text/html`. The same URL with `?raw=true` returned the file: 50 as `image/*`, and two GIFs (`Swift-Gif` `demo.gif` and Food2Fork `list_detail_demo.gif`) as `application/octet-stream` with a `GIF89a` header. Those fields now include `?raw=true`. Migraine Log’s three GitLab screenshots used `/-/blob/` and returned HTML. The same path with `/-/raw/` returns `image/png`. Those fields now use `/-/raw/`.

The same day, 461 unique `raw.githubusercontent.com`, GitLab `/-/raw/`, Bitbucket, and Codeberg screenshot URLs were requested. 454 returned an image. Seven returned 404 on repositories that are already gone: Eros-FE, Beers, RaceMe, RxCurrency, and Crystal Clipboard. `status.im/img/teaser-image.png` redirects to the Status homepage, and the same path on `status.app` is 404, so that URL stayed.

A later GET of every `github.com` screenshot followed redirects. 662 of 677 returned an image. GitHub drops `?raw=true` when it redirects `/blob/master/` to `/blob/main/`, and the HTML page that remains is not the image. Loose Leaf `collapse-stack.gif` and the two iOSDesignPatternSamples files (`app.gif`, `diff.png`) now use `/blob/main/` with `?raw=true`. That URL returns the image (`GIF89a` or PNG). Orgro and VisionProVacuumDemo screenshot assets are `video/mp4` and stayed, because that upload is the file the URL names. The other ten 404s are deleted files or missing repositories and stayed.

On 27 October 2026, three screenshot URLs were requested and the response followed a redirect to the same image. WordPress now uses `https://mobiledotblog.wordpress.com/wp-content/uploads/2019/10/690x0w.jpg` (JPEG, 161,525 bytes). ASCII Art Generator now uses `https://ijoshsmith.com/wp-content/uploads/2015/04/ascii_kermit.png` (PNG, 557,885 bytes). 4clock now uses the Medium `v2/resize:fit:600` URL for the same image id (PNG, 40,945 bytes). `status.im/img/teaser-image.png` still redirects to the Status homepage, so that URL stayed.

A later pass followed redirects for active screenshots outside Apple’s CDN and GitHub release assets, then for archived screenshots of the same kind. A redirect from `github.com/.../blob/` or `/raw/` to `raw.githubusercontent.com` for the same owner, repository, and file is GitHub’s image host. Those URLs stay. Ten archived screenshots redirect because the repository moved, and the catalog `source` is already that repository. The same path on the new owner returns the same bytes: CCC `dark.gif`, OpenSesame `Images/All.png`, both Wunderschnell screenshots, both Calvin and Hobbes Comic Viewer previews, Todo Combine SwiftUI `demo.png` and `demo.gif`, and both TheReservist marketing images. Those fields now use the new owner. iStockcheck’s lock-screen file still 404s after `stockcheck` redirects to `iStockCheck`, so that URL stayed.

Paws used `https://www.appcoda.com/wp-content/uploads/2015/04/paws-demo-animation.png`, which returns 404 HTML. The same article, “Building an Instagram-Like App with Parse and Swift”, now serves that filename at `https://www.appcoda.com/content/images/wordpress/2015/04/paws-demo-animation.png` (`image/png`, 63,820 bytes). The screenshot field uses that path.

## Pull requests

The cloud agent can push branches. Opening a pull request still fails. Checked again on 27 October 2026 at 2:51 PM Toronto. Upstream `master` was still `28722ee0`, and this branch already contains it. `jordanch14-create` was still not a collaborator, and there were 0 open pull requests. `POST /pulls` at 2:19 PM Toronto was still 403 and asked for `pull_requests=write`. The link check for the description trim, run `40552027108`, completed success at 1:37 PM Toronto the same day. The link check for the license and tag notes, run `40552775880`, completed success at 1:41 PM Toronto. The link check for the filled licenses, run `40553976653`, completed success at 1:49 PM Toronto. The link check for the license-file corrections, run `40554721744`, completed success at 1:54 PM Toronto. The link check for the star counts, run `40556498460`, completed success at 2:05 PM Toronto. The link check for Pomelo’s timestamp, run `40556917404`, completed success at 2:07 PM Toronto. The link check for the screenshot redirects, run `40559549077`, completed success at 2:25 PM Toronto. The link check for the projectM homepage, run `40560583548`, completed success at 2:31 PM Toronto. The link check for the screenshot owner redirects, run `40561779846`, completed success at 2:39 PM Toronto. The link check for the add dates, run `40563192668`, completed success at 2:49 PM Toronto. The link check for the repeated tags, run `40563917225`, failed at 2:53 PM Toronto on two temporary responses: `https://open.getfind.app/assets/Find.jpg` returned 503, and `https://ahnafmahmud.com/apps/Homepage/screenshot-ipad.png` returned 520. A later GET of each URL returned the image (JPEG, 1,393,784 bytes, and PNG, 712,709 bytes). Those fields stayed. The link check for that note, run `40564256986`, completed success at 2:55 PM Toronto. Checked again at 3:08 PM Toronto. `jordanch14-create` was still not a collaborator, open pull requests were 0, and upstream `master` was still `28722ee0`.

- `POST /repos/llceejll/open-source-ios-apps/pulls` returns 403 and requires `pull_requests=write`.
- Cursor's pull-request action returns `must be a collaborator`.
- The repository is public, issues are enabled, and `pull_request_creation_policy` is `all`.
- The only collaborator is `llceejll` (admin). `jordanch14-create` and `cursor` are not collaborators.
- `cursor[bot]` can create an issue. The same token cannot edit, comment on, or close an issue.
- https://github.com/llceejll/open-source-ios-apps/issues/3 asks the admin to invite `jordanch14-create` with Write and to set the Cursor GitHub App's Pull requests permission to Read and write.
- https://github.com/llceejll/open-source-ios-apps/issues/2 is an empty probe from that check. This token cannot close it.

Do not open another issue for the same request, and do not work around a refused pull request by calling `POST /pulls`. The branch to review is `cursor/sync-upstream-catalog-1c12`.
