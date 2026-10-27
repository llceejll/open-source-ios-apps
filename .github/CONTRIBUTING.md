To contribute to `open-source-ios-apps`, update the **contents.json** file (this will generate the README).

A new entry should update **contents.json** with this format:

```js
{
            "title": "Name of the app",
            "category-ids": ["Category id"],
            "description": "What this app does",
            "source": "Link to source, usually GitHub",
            "itunes": "Link to App Store",
            "screenshots": ["https://example.com/image.png"],
            "date_added": "Aug 6 2016",
            "suggested_by": "@github_username"
}
```

:tada:

## Validate your change

Install the locked Ruby dependencies:

```sh
gem install bundler -v 4.0.23
bundle install
```

Then validate the catalog and regenerate the derived lists:

```sh
bundle exec validate-schema .github/schema.json contents.json
bundle exec ruby .github/osia_validate_categories.rb
SOURCE_DATE_EPOCH="$(git log -1 --format=%ct -- contents.json)" \
  TZ=UTC bundle exec ruby .github/osia_convert.rb
```

Commit changes to `contents.json` before the generated Markdown files so the
`SOURCE_DATE_EPOCH` value records the catalog update date. Do not edit
`README.md`, `APPSTORE.md`, `ARCHIVE.md`, or `LATEST.md` by hand.

For more information, please read https://github.com/dkhamsing/open-source-ios-apps/wiki
