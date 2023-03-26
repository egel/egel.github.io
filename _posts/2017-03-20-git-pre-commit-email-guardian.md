---
layout: post
title: Git pre-commit E-mail blocker
category: Diary
tags: [git, terminal]
date: 2017-03-20 11:22:00
summary: Presenting a simple solution that allows only selected git users to commit in local copy of repository.
---

Since quite a while Git exists in the big market of software development. Many users using it on the daily basis as a standard way of committing their work for an employer and it also became the de facto standard way of developing in the Open Source world.

I also enjoying using Git, but after some time I discovered that my way of working with Git especially when I need to commit many different parts for multiple employers then the git user management problem begins.

Nowadays, almost all the time I have at least 2 local Git users (user that you define in `~/.gitconfig` file and please don't confuse it with Gitlab, Github nor other user accounts). Whatever you'll commit the user data written in `~/.gitconfig` it'll appear in your git logs.

Usually, employers don't care, although some of them require a specific company credential while communicating with their repositories, so I figured out, that I can have multiple local git users in the same file, however activate only single one when I need it.

```config
# ~/.gitconfig

[include]
  # For user, email, ect.
  ; path = ~/.gitconfig.local   # colon make this configuration inactive
  path = ~/.gitconfig.local_work
```

```config
# Sample of private configuration
# ~/.gitconfig.local

[user]
    name = John Doe
    email = firstname.lastname@example.com

[github]
    user = githubUsername
```

```config
# Public work configuration
# ~/.gitconfig.local_work

[user]
    name = Maciej Sypień
    email = firstname.lastname@workmail.com
```

This simple solution gives me an opportunity to have multiple Git local users with different credentials hidden into files `~/.gitconfig.local_<company>`. So I can use it for my personal accounts or for some specific credentials required by employers - the field of usage is almost endless.

To give some more real live example, when I want to switch between different users ( I'm doing something for my personal stuff at weekend and on Monday morning start using the same laptop to begin my work as an employer of company ABC) then I just comment line with `~/.gitconfig.local` and uncomment (enable) specific configuration for work `~/.gitconfig.local_work`.

Although "hey, no one is infallible, and many times I do a commit as a wrong user to the repository that I shouldn't commit (i.e.: using my personal e-mail address when I commit to employer's repository where I should use company's one). Therefore, since a while, I wondered about:

> "How to disable some not authorized git users to commit in selected local repositories".

There are so many ways how to achieve this trivial task, but I've decided to use Git's hooks feature and I wrote a simple program, which checks locally enabled Git user's e-mail before committing to the repository.

This simple solution may save a lot of your time (and potential interactive rebase to revert it) especially when the real user (you) have multiple Git accounts - for example when you're a freelancer (or project manager) and you need to commit to multiple projects with completely different Git credentials for some reasons.

So what might be some solution to this problem?

### Solution

Below I present some solution and how to implement it using simple `pre-commit` hook script that is available in any Git version higher than v1.8.4.

<script src="https://gist.github.com/egel/ca14ecaf73f2f1370942e650676c8368.js"></script>

What does it do? Basically before each commit (`git commit -m "whatever"`) then Git runs its hooks (if they're defined) and program checks what e-mail addresses are valid for this repository and allow or reject users with small information, that only a specific group of e-mails are allowed to commit in this repository.

#### Installation

Save above snippet save as `.git/hooks/pre-commit` into your Git repository and **don't forget to make the file executable** via `chmod +x .git/hooks/pre-commit`. In the final step, modify the list of e-mail addresses and that's it.

I only hope that now you become much happier Git user then you ware before. Enjoy using this simple pre-commit e-mail guardian :)

[github]: https://github.com
