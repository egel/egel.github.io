---
layout: post
title: Useful terminal commands
published: true
tags: [macos, unix, linux]
---

This post will be different from the others. Instead of presenting a comprehensive tutorial or in-depth explanation, it will function more like a personal repository – a collection of useful programs, terminal commands, and solutions that have worked well for me over time. Think of it as a 'notes to self' section, where I can quickly reference and revisit these gems whenever needed.

## Searching

### Search phrase inside PDF files

> install `pdfgrep`

Search for `<phrase>` in all PDF files (case insensitive, e.g.: `.pdf`, `.PDF`) in the current directory (`.`).

```sh
find . -iname "*.pdf" -exec pdfgrep "<phrase>" {} +
```

## Copying

### Copy all files of a given type to specific directory

Take all `mp4` files from current directory (`.`) and paste into `~/Music`.

```bash
find . -name '*.mp4' -type f | xargs -I '{}' mv '{}' ~/Music
```

## Testing

### Benchmark server effectiveness

> install `wrk`

Spawn 12 threads with 400 simultaneous connections for 10s to `http://127.0.0.1:9000`

```bash
wrk -t12 -c400 -d10s http://127.0.0.1:9000
```
