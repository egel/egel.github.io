---
layout: post
title: Crafting great project base
tags: [git]
---

It is not common to start new project every day. This process happening less often then joing other project codebase. Therefore is vital for the project success to make the

I know about this trick for a long time but finally found some time to share it with you.

## Story

Once I had to send a couple of pictures via e-mail (there were about 20 images). I am aware there are more efficient and smarter options to share images with other person, although sometimes the other side demands it to be an accually e-mail. 🙈🤷‍♂️

I decide to reduce the size, pack it and send it. I realized that images are stored in a strange Apple extension called `*.heic`, so this is not a desired extension that someone on the other side would like to see. Furthermore, the original images were big (3-5MB) and I really don't want to end up with manually resizing and saving all images with desired extension.

Fortunately, there is a brilliant program called [imagemagic][weblink-imagemagic] which saves my ass a thousand times - and btw it's actually now a group of different programs, but never mind.

With this tool, you can in a good well spirit of automation convert all images from HEIC to more popular JPEG and reduce the size (quality), so they can fit in a standard email size.

## How-to

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
