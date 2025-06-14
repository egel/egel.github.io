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

### Reaching internet connection (macOS)

Sometimes my laptop loose internet connection. Then I usually check reaching sever `8.8.8.8` and when it's back (and I did not notice) I want to be informed by "beep" sound.

```sh
while true; do
  if ping -c 1 8.8.8.8 &> /dev/null; then
    printf "%s %s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" success && afplay /System/Library/Sounds/Funk.aiff
  else
    printf "%s %s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" fail
  fi;
  sleep 5;
done
```

## Saving

### Opening file with vim without sudo privileges

imagine situation when you open file, do lot of work and try saving but it tells you `E45: 'readonly' option is set (add ! to override)`. Trying with `w!` but this also not work. If this is the case, try this:

```
:w !sudo tee %
```

- `w` - save
- `!` - execute
- `sudo tee` - programs
- `%` - current buffer
