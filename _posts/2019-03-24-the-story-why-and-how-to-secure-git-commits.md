---
layout: post
title: The story why and how to secure your Git commits
published: true
tags: [osx, git, gpg/pgp]
---

When I saw for the first time a commits with the mysterious "Verified" sign and I was told that someone can do this on its own, I wanted to do the same. Yes, I know it's silly. But after a few moments since I was informed about this feature, I start wondering:

> 1. What those verified commits really are for?
> 1. Why I might need to sign my commits with GPG key? I already use SSH private/public keys.

So to answer those questions I google a bit and found this: ["Why would I sign my git commits with a GPG key when I already use an SSH key to authenticate myself when I push?"](https://security.stackexchange.com/a/120725). This post gave me a reasonable answer why we might need to sign commits or at least sign the tags.

Ok, but to the question:

> Why and what for am I need ever need to sign my commits?

So to start from the beginning.

A quote "When you authenticate to Github with your SSH key, that authentication doesn't become part of the repository in any meaningful or lasting way. It causes Github to give you access for the moment, but it doesn't prove anything to anyone who is not Github." - HedgeMage.

The author made a relevant point, which is true. When you log in to any repository (Github, Gitlab, whatever...) you have to have an account, which is used by somebody. Exactly, it doesn't mean that "you" is really you - by having an account it means that you can see/do stuff in this place. Definitely it's not saying that let say, John Doe from Pima County Cemetery, Tucson, Arizona is really the John Doe.

Then comes the SSH. SSH "is a cryptographic network protocol for operating network services securely over an unsecured network." - this is the first line in Wikipedia about what is the SSH. There is no phrase, that it identifies the person who makes a call, it only secures the connection. So... How this relates to the problem of securing the commits?

We have come at last to the plase where the GPG/PGP keys enter. Creation of the aforementioned PGP keys and obligatory making them public in a trusted, available to everyone place, should give to the world a certain assurance that "you is really you" - only the person who has private and the public key can sign the data with that key. Finally the last and IMHO the hardest part of that process, use those keys wherever possible to emphasise that "you is really you", not someone else who is claiming to be you by really good fake authenticity.

![Always sign your commits!]({{ site.baseurl }}/assets/img/sign-your-commits.jpg)

Before we get to section how to secure your work in Git, I want to show you a story why you should sign your commits (especially while being a programmer which the creation of commits as his daily basis) and what might happen when you will not sign them: [A Git Horror Story: Repository Integrity With Signed Commits](https://mikegerwitz.com/2012/05/a-git-horror-story-repository-integrity-with-signed-commits).

## Open sesame!

> Disclaimer: the tutorial presented below has been made for OSX, but it should also be valid for Linux work stations. The idea is completely the same, only the name of some tools to generate keys or 3rd party libs might change.

To secure your commits, you will need:

1. git (user apple Xcode tools or install via brew)
2. gpg (important to use version 2, install via `brew install gnupg`)
3. repository to store public keys (e.g.: Github, Gitlab)

### GPG/PGP key

Let's start with creating your PGP key. You will use it to secure/identify the content has been made by you.

```shell
gpg --full-gen-key
```

You will get few questions to answer (e.g.: name, email, comment, passphrase) which will be stored in your key and visible to everyone (it's not a good place to make jokes there - would you trust the clown 🤡? - me not 😉).

> Note: I never use an empty passphrase and opt for 4096-bit key, so I can recommend you same.

Then we have to get a reference to your key so the git will understand which key he has to take in order to sign each commit. Below command will give them the list of all your public keys in the system, select the one you have entered.

```bash
gpg --list-secret-keys --keyid-format LONG <your-email>
```

Now you can take the GPG key ID to use it in Git. In my case, the key looks like this:

```bash
gpg --list-secret-keys --with-fingerprint --keyid-format LONG john.doe@gmail.com
sec   rsa4096/10BC01EDA6827DC8 2019-03-17 [SC]
      78CA0E181F71CFD6F02AC05E10BC01EDA6827DC8
uid                 [ultimate] Maciej Sypien <john.doe@gmail.com>
ssb   rsa4096/EBEE77C5734494A6 2019-03-17 [E]
```

Use the GPG key ID, in my case, was `10BC01EDA6827DC8`.

Ok, we have got the key, now we need to get your public key to make it public (anywhere, somewhere!).

Below command will store the key to file and save it in your home directory.

```bash
gpg --armor --export <your-email> > ~/public_pgp_key_your_name.asc
```

We will get back later to GPG again in second when we get to the software configuration section.

### Git

Now configuration of your git config file should be set up via below commands:

```bash
git config --global user.signingKey 10BC01EDA6827DC8
git config --global commit.gpgSign true
```

### Repository

Remember the public GPG/PGP key we have created? Now open your repository on GPG/PGP keys section in order to upload your private key and you're almost done.

Now, Git will sign all your commits automatically. Now your content can be with "a reasonable assurance" confirmed that you did this work! Wicked!

### Software configuration

I said before "you're almost done" because, for me, the full tutorial require recommended/explained configuration of the software presented to fully gain from the lesson.

So what we can configure here?

1. For some people might be important to not enter the GPG passphrase every time you make a commit. To do so we have changed some default config. 5184000s == 60 days until the gpg again will ask you again to fill the passphrase (or until you'll restart your machine)

    > It's not recommended to make the cache expiration long, unless you know that this might reduce your security.

    ```ini
    # ~/.gnupg/gpg-agent.conf

    # Set the maximum time a cache entry is valid to n seconds. After this time a cache entry will be expired even if it has been accessed recently or has been set using gpg-preset-passphrase. The default is 2 hours (7200 seconds).
    max-cache-ttl 5184000

    # Set the time a cache entry is valid to n seconds. The default is 600 seconds. Each time a cache entry is accessed, the entry’s timer is reset. To set an entry’s maximum lifetime, use max-cache-ttl. Note that a cached passphrase may not be evicted immediately from memory if no client requests a cache operation. This is due to an internal housekeeping function which is only run every few seconds.
    default-cache-ttl 5184000
    ```

1. Use a secure program to enter your pin/passwords, like e.g.: [`pinentry`](https://www.gnupg.org/related_software/pinentry/index.html).

    In order to install pinentry on OSX use brew:

    ```bash
    brew install pinentry-mac
    ```

    Then add the following configuration to your gpg-agent.

    ```ini
    # ~/.gnupg/gpg-agent.conf

    # Use following program as the PIN entry.
    pinentry-program /usr/local/bin/pinentry-mac
    ```

1. Better GPG configuration

    ```ini
    # This tells gpg to use the gpg-agent
    use-agent

    # Make sure that the TTY (terminal) is never used
    # for any output.
    no-tty

    # Use the sks keyserver pool, instead of one specific server, with secure connections
    keyserver hkps://hkps.pool.sks-keyservers.net

    # Ensure that all keys are refreshed through the keyserver you have selected.
    keyserver-options no-honor-keyserver-url
    ```

Awesome! Now you have a complete overview and good configuration to start working. Have fun and stay secure!
