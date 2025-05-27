---
layout: post
title: Baking fonts for web
tags: [macos, linux, profession]
---

How to do it without online portals that may convert the font but many loose the quality or font later is displayed incorectly.

https://github.com/bramstein/homebrew-webfonttools

```bash
brew tap bramstein/webfonttools
brew install woff2 # for ttf -> woff
brew install sfnt2woffbrew install sfnt2woff # for ttf -> woff

```

brew install sfntly

-   install `sfntly` -> EOT

```bash
woff2_compress Montserrat-ExtraBold.ttf # woff2
sfnt2woff Montserrat-ExtraBold.ttf # woff
```

[weblink-imagemagic]: https://imagemagick.org/
[weblink-libheif-macos]: https://www.libde265.org/
[weblink-libheif-alternative]: https://github.com/strukturag/libheif
