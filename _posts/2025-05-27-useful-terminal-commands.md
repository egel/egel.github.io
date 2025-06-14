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

## Updating

### Update all git repositories from current path

Take current directory (`.`) and search for all git repositories underneath (not nested) and fetch the latest changes from the origin.

```sh
find . -name .git -type d -prune | xargs -I {} sh -c 'cd {} && cd .. && printf "Repo: %s\n\n" $(realpath) && git fetch'
```

## Testing

### Benchmark server effectiveness

> install `wrk`

Spawn 12 threads with 400 simultaneous connections for 10s to `http://127.0.0.1:9000`

```bash
wrk -t12 -c400 -d10s http://127.0.0.1:9000
```

## Saving

### Saving file with vim without sudo privileges

Imagine situation when you open file, do lot of important work, and then while trying to save the file, your vim tells you: `E45: 'readonly' option is set (add ! to override)`. Next you, try again, and again, and nothing... Then you remember about "force" and check saving with `w!`, but this also not work...

If this is the case you have encounter, try this:

```
:w !sudo tee %
```

- `w` - save
- `!` - execute
- `sudo tee` - programs
- `%` - current buffer

In short: it will save your current file , by wrapping it up with `sudo tee` which enable a proper saving privileges for sudo user.
