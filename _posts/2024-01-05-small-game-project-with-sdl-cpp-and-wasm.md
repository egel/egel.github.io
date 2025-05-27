---
layout: post
title: Small game project with SDL2 and WASM
tags: [macos, game, sdl2, wasm, cmake, terminal]
---

I wanted to try learn more about creating games. project where I could learn about SDL2 and WASM.

My main platform is macOS, although one of decisions was to make it easy developing on all other platforms.

Features:

-   simple & very lightweight
-   be able to develop on all major platforms (macOS, Windows, Linux)
-   cross compatibility on all major platforms: macOS, Windows, Linux, and mobile platforms iOS & Android

## Where to start?

## Encountered Problems

I tired at least 3 dozen of tutorials how to set up cmake on macOS (arm) and no surprise nothing worked as expected.

After few hours later, I finally got build done, but when running there was problem with linking:

```
→ ./Snake
dyld[84987]: Library not loaded: @rpath/SDL2.framework/Versions/A/SDL2
  Referenced from: <683DE147-61FA-3A61-B1BA-3245D1EB3298> /Users/<MY_USER>/privatespace/github.com/egel/snake-sdl3/Snake
  Reason: no LC_RPATH's found
[1]    84987 abort      ./Snake
```

According to [info from the web](https://sarunw.com/posts/how-to-fix-dyld-library-not-loaded-error/) the problem is the macOS environment has change over last years, and they introduced nice and convenient feature of using dynamic library linker use while running game (for developer convenience).

## creating simple game frame

## packing this to WASM

Install [`imagemagic`][weblink-imagemagic] on your computer (it's free and available on all platforms). If you like my editing, especially the `heic` type of images, you may need to install an additional library called [`libheif`][weblink-libheif-macos]. For other platforms use [alternative][weblink-libheif-alternative].

```bash
brew install libheif imagemagick
```

Now you just need to specify a directory where your images are stored and execute the command:

```bash
magick mogrify -format jpg -quality 60 *.HEIC
```

<div class="alert alert-info" role="alert">
    <p>Pay attention to the case sensitivity of the letters in the image extension, as it may be different than in my command.</p>
    <p>You can also use instead full of <code>magick mogrify ...</code>, just <code>mogrify ...</code> because after the installation of imagemagic all its sub-programs should be available for you directly in the command line.</p>
</div>

Yay! A few seconds later all images are converted and they're ready for upload. Thanks, that's all 🤘. Have fun further exploring imagemagic secrets. It's definitely extremely helpful software.

[weblink-imagemagic]: https://imagemagick.org/
[weblink-libheif-macos]: https://www.libde265.org/
[weblink-libheif-alternative]: https://github.com/strukturag/libheif
