---
layout: post
title: Git pre-push guardian
category: Self improvement
tags: [git, terminal]
---

Recently I wondered how to improve my workflow with Git. I came across the Web and found some article which pointed on Git hooks that were introduced since version 1.8.2.

This cool feature allows you to execute some code before (or after) some actions made in Git. 
My team and I have decided, that we will complete our tasks in "feature branches" (that is the de-facto standard workflow in Git), and to do it so, we've marked our main branches: `master`, `stage` and `develop` as
protected once. That means, only users with master access or greater (for the repository), can push directly to this branches. I've got that privilege but switching between many branches, fetching, pulling, pushing, fetching, pulling - those all actions may confuse a mind for a few seconds.

Then I realize if there's any available option to warning important actions (like push force to master) on those protected branches. Few minutes of searching and puff... Git hooks came in on the stage.

## Guardian script
With some examples on the web and also with Git documentation, I wrote a simple Git **pre-push** script which checks in which branch you are currently in and it will ask you "Are you intend to push?" to those protected branches.

The full script is available below:
<script src="https://gist.github.com/egel/2058f19cf78df84ade741b7a77a38006.js"></script>

### Implemented features:
-   Array with protected branches (easy to maintain)
-   Base terminal colors to improve visibility
-   Question that only works when confirming with return key (this is the time to think about if you want to perform this action)
-   Default value of question set to `No`
-   Message of committed action

### Things which may be improved in future:
-   Download list of protected branches direct from repository
-   Add support for some popular flags like: `--force`

## How to use it?
You need to copy this into your git project. There you should have a `.git/hooks` directory (if not you have probably your Git older then v1.8.2). Then save above file as `.git/hooks/pre-push`.

> Don't forget to add executive permissions to this file with `chmod +x pre-push`.

Now every time you'll push to one of your `protected_branches` listed inside the file, Git will ask you if that was your intended action. For every Git masters, this little trick can save a day ;)

  [1]: http://technology.blurtit.com/114838/what-is-a-basic-difference-between-a-notepad-and-microsoft-word
  [gist-pre-push]: https://gist.github.com/egel/2058f19cf78df84ade741b7a77a38006

