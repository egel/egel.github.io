---
layout: post
title: Always create GPG revocation certificate backup
published: true
tags: [security, diary, gpg]
---

## The story behind it

A few days ago I received an encrypted message from a stranger. Unfortunately, I can't read it. I stumble upon a problem, that I forgot my GPG passphrase! Oh, no!

I've searched for potential solutions on the Web and found this nice article [Oh no, I forgot my PGP private key’s passphrase](https://medium.com/@fro_g/oh-no-i-forgot-my-pgp-private-keys-passphrase-6ec1d0228b48) from [Esteban Sastre](https://estebansastre.com/) where he describes his almost identical problem about forgetting GPG passphrase.

But the conclusion from Esteban's article wasn't encouraging because it seems that there is no other way to get a GPG passphrase back after you lose it. Sad. 

I didn't stop searching. Although, unfortunately for me, I only found a couple of other confirmations the hypothesis (of no way to retrieve a password), in the following websites:

- <https://security.stackexchange.com/questions/155336/gpg-gnupg-secret-key-passphrase-recovery-and-or-gnupg-private-keys-v1-d-file-f>
- <https://lists.gnupg.org/pipermail/gnupg-users/2009-February/035601.html>

I still could not stop thinking _"how can I get my passphrase back?_ I thought, maybe I could just write an e-mail to one of PGP server admins, so they can remove my key and I will be able to just create a new pair of keys and the problem would be solved. Quick search and... **No! Officially there is no way to remove a key from public servers without having a passphrase to your key (to create a recovery certificate)**. [Reference link you can find here](https://www.rediris.es/keyserver/remove.html#:~:text=In%20order%20to%20remove%20a,with%20your%20old%20user%20id.).

Aaaaah...! 😤 But I get it, I understand. It's about freedom and security reasons. It makes sense. For the same reason, I also published my key online... 😢 

When frustration went away, I become even more determined to get my lost passphrase back! My key hadn't any expiration date! In other words - this will never be invalid or removed from any key servers! Among the results of "how to get GPG password back", I was only thinking that the only way to get it back, will be through using [John the Reaper](https://www.openwall.com/john/). 
Wait, wait, wait. I'm using a password manager, and this passphrase must somewhere there. I got a one, last try and peek once more into my password manager... I dig deep, through hundreds of entries, and also the history of those entries and... puff! I've fount it! Uff!

The problem was that there was a bug in my password manager (and I think it is still there until today - the publication of this article). The bug is about: when you create a secure note and lock password manager or quit, the note is dropped/erased. It's somehow overwritten by an empty string. The only way to get it back is to take a peek into a history of this note! A nightmare of any users who use password managers! 😱

> Lesson for users with password managers:
>
> Always create new item/entry per each key or passphrase, so the key is easy to search.

> Lesson for GPG users:
>
> Always create your keys with expiration dates and store your GPG passphrase in 2 places. Really, just do it! 

## Create recovery cert

Oh, there was a lot of frustration and irritation in the last couple of paragraphs. Instead of just feeling positive emotions and thrill what's inside I got a package of disappointment that I presented for myself supported by a silly but nasty software bug.    

Ok, but what to do now?

Except for the pieces of advice I posted at the end of the previous section, I would recommend you creating **the recovery certificate** and store it in a safe place. Creating a recovery certificate will allow you to start the process of removing the GPG key from all key servers, in case your passphrase will be lost again. In other words, communicating all other users that this passphrase has been compromised and is no longer valid.

Let's do this. First, list your GPG fingerprints to reveal (you can have much more entries) 

```
gpg --fingerprint
--------------------------------------
pub   rsa4096 2019-03-17 [SC]
      78CA 0E18 1F71 CFD6 F02A  C05E 10BC 01ED A682 7DC8
uid           [ultimate] Maciej Sypien <maciejsypien@gmail.com>
sub   rsa4096 2019-03-17 [E]
```

Create a certificate using your e-mail address:

```
gpg --output ~/revocation-certificate.asc --armor --gen-revoke your@email.com
gpg: Sorry, no terminal at all requested - can't get input
```

What's that? I've made another search for the given error message and [found the problem](https://stackoverflow.com/a/51174117/1977012). As I'm using a macOS and I've configured my [Automatic Git commit signing with GPG on macOS](https://egel.github.io/2019/03/24/the-lesson-of-verifying-git-commits.html), I have to temporally comment `no-tty` in my `~/.gnupg/gpg.conf`.

```
gpg --output ~/revocation-certificate.asc --armor --gen-revoke your@email.com

sec  rsa4096/10BC01EDA6827DC8 2019-03-17 Maciej Sypien <maciejsypien@gmail.com>

Create a revocation certificate for this key? (y/N) y
Please select the reason for the revocation:
  0 = No reason specified
  1 = Key has been compromised
  2 = Key is superseded
  3 = Key is no longer used
  Q = Cancel
(Probably you want to select 1 here)
Your decision? 1
Enter an optional description; end it with an empty line:
>
Reason for revocation: Key has been compromised
(No description given)
Is this okay? (y/N) y
Revocation certificate created.

Please move it to a medium which you can hide away; if Mallory gets
access to this certificate he can use it to make your key unusable.
It is smart to print this certificate and store it away, just in case
your media become unreadable.  But have some caution:  The print system of
your machine might store the data and make it available to others!
```

Now, when you have your key revocation certificate time to secure it in a protected place. I would recommend not putting it in a single place and additionally use 2 different ways to store it: analog (print) and digital (in your password manager).

Using macOS, install a library that helps us to generate a QRCode locally on my machine. 

```bash
brew install qrencode
```

Generating the QRCode is really simple, important is to get a good quality of the output format, therefore I like to use SVG.

```bash
qrencode --output revcert.svg --dpi=600 --size=20 --type=SVG --read-from=~/revocation-certificate.txt # SVG ~10cm
``` 

Now, print it and store it safely.

![thank you]({{ site.baseurl }}/assets/img/thank_you.png)

Links used while writing:

- <https://linuxhint.com/encrypt_decrypt_files_gpg/>
- <https://estebansastre.com/about/>
- <https://medium.com/@fro_g/oh-no-i-forgot-my-pgp-private-keys-passphrase-6ec1d0228b48>
- <https://www.gnupg.org/gph/en/manual/c14.html>
- <https://www.linode.com/docs/security/encryption/gpg-keys-to-send-encrypted-messages/>
- <https://gpgtools.tenderapp.com/kb/gpg-services-faq/how-to-decrypt-and-verify-text-or-files-with-gpg-services>
