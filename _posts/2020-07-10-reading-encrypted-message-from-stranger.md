---
layout: post
title: Reading encrypted message from stranger
published: true
tags: [security, diary, gpg, macos, linux]
---

A few days ago, I've received an e-mail from a stranger with an encrypted message. An e-mail from a stranger is nothing new nowadays, although an&nbsp;encrypted one is at least something worth taking a look at. 

For the first time, I could experience in real life that someone knows how to use encryption, and sends a message to me. From my experience, it's rare to see it if someone sends you an encrypted message, therefore I was motivated to read what this person has to say. 

After searching for some help on how to safely process reading this message further, unfortunately, the ocean of tools and not precise tutorials only get me even more confused, so I thought after figuring all things out, I will summarize this process here.

> *Sidenote*: I noticed that this message has been sent to me ~1y after I published my GPG key on the public servers. I did not publish my GPG key anywhere except my blog and GPG public servers, so I think someone is probably watching for newly published keys in public servers and that's how I have been found.
> 
> Although, if it does not scare you, and you find this interested in how I did it anyway, you can read more about it in  ["The lesson of verifying Git commits"]({% post_url 2019-03-24-the-lesson-of-verifying-git-commits %}). 😉

## Message decryption
Let's say you received an encrypted message and now the question is, **how to read this message**?

It depends on the format you have received it. You can receive the whole e-mail encrypted, or an e-mail with an encrypted message, as I did below. Nevertheless, generally, you should get something that looks like this:


```
-----BEGIN PGP MESSAGE-----

hQIMA+vud8VzRJSmAQ//TEZwWw77MXJMXLds5zTEznJlyuRIIN/DR5xi+Fc/CX4u
FnGdS8lMlczDeQj5u1607HhmB/2MqnzZUlYATA+OLJswX4B2nqdWVo+u4Z+ijjCW
...
...
...
+FC1gpSOnEH9TMGtvW/ogKcAYkbFj4FMhfT+1cfcyEQ=
=c4x/
-----END PGP MESSAGE-----
```

Ok, there is an encrypted message. The best would be to save this message in some text file, like for example `encrypted_message.txt` (as it will be a bit easier to decrypt it in a later step). Additionally, it does not matter which extension you will use to encode your message.

Now, is the time to check if this person who sends us the message has a public key in one of the public PGP servers. So I am checking it, and there is a mystery guy.

```
→ gpg --search-keys matbit@secmail.pro
gpg: data source: http://83.227.87.55:11371
(1)	Hu2020 (Hu <matbit@secmail.pro>) <matbit@secmail.pro>
	  3072 bit RSA key CBFD27BAA73638F2, created: 2020-06-14
Keys 1-1 of 1 for "matbit@secmail.pro".  Enter number(s), N)ext, or Q)uit > s
```
> After I search something about secmail in general, it become more obvious to me that this person just paid for anonymity and an easy pre-configured platform for sending encrypted emails. At this moment I knew that there was something not right - disappointing.

Ok, let's download a public key of our stranger, and read this message.

> Info: 
> 
> Just in case you're wondering how to get **the keyID** of a key in the Command Prompt, (I ran into this :). It's the last 8 characters of your public key, which you could easily get printed by using the following commands.

```
gpg --receive-keys CBFD27BAA73638F2
```


Tada! The message is decrypted and I can finally read it!

``` 
→ gpg --decrypt ~/encrypted_message.txt.gpg
gpg: encrypted with 4096-bit RSA key, ID EBEE77C5734494A6, created 2019-03-17
      "Maciej Sypien <maciejsypien@gmail.com>"

Dear Maciej,
...
```

That's all. Hope you enjoy this small, simple explanation of how to read encrypted emails. Stay secure, and until next time.
