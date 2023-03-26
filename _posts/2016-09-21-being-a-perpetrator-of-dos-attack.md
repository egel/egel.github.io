---
layout: post
title: Being a perpetrator of DOS attack
tags: [linux, console, server]
---

Couple of days ago my tiny VPS server served by very famous provider has become an attacker of denial of service. Yes, you've read it right, my tiny VPS was an attacker!

I was mailed by automatic DO (shortcut for company name) mailer, that my server has become an attacker of denial of service and everything what I had inside has been shut down. Seriously!?

The whole, original message:

> Hi there,
>
> We've detected an outgoing Denial of Service attack (http://do.co/21Y1Gc1) originating from your Droplet. Due to the traffic’s harmful nature, your Droplet was taken offline; this means it is not connected to the internet and all hosted sites and services are unreachable. We know that this action is disruptive, but it’s necessary to protect you, our network, and the target of your Droplet’s attack.
>
> You can access your droplet using this console link: _CUT LINK_
>
> Because this means your Droplet has been compromised, you’ll need to back up your data and transfer it to a new Droplet. We have a recovery tool to assist you, but any databases on your Droplet will need to be backed up before we boot your Droplet into the recovery tool because you won’t be able to make the backups afterward.
>
> Specific backup steps vary depending on the database software in use, which is most commonly MySQL. If you’re not sure how http://do.co/1h0uWgm will show you how to back up your databases from MySQL.
>
> Once you have finished backing up your data, the next step is downloading and transferring your data to your new Droplet. Please update this ticket when you’re ready and we’ll configure this Droplet so you can proceed.
>
> If you’ve enabled our backup service or have a snapshot of the Droplet, you can restore directly from that image instead of going through the recovery process. Be aware that this will destroy any changes or additions made to the Droplet since the creation date of the image you use to restore from. If you do this, please update the ticket as we will need to reconfigure networking to get your Droplet back online.
>
> If you don’t need the data from this Droplet, you can destroy this Droplet at your convenience. If you’d like to keep the current IP address, you will need to use our rebuild function. This acts like a clean install of your OS and is currently the only way to ensure you retain your IP. As with restoring from an image, please let us know once you’ve done this.
>
> If you have any further questions, or if we can further assist, please let us know.
>
> Regards,
>
> Trust & Safety
> DigitalOcean Support
>
> Please login to view the ticket:
> https://%DO I will not sponsor your links here!%/support/tickets
>
> Thanks so much,
> DigitalOcean

That was very surprising to me because I only used this VPS mainly for displaying my blog and additionally as a web development sandbox (some basic stuff like Apache, Nginx, PostgreSQL, MySQL, etc.). Nothing harmful.

I lend the cheapest server they've got, 512MB RAM, 1 Core CPU around 2.2GHz with 20GB storage just for having fun with creating something awesome and share it with the community (also with you).

In the latest time when I use DO's VPS, I've tried to set up a private Gitlab instance on this tiny machine and surprisingly I was succeeded. I've set up Gitlab + Apache + MySQL (and a couple of other daemons) and that worked flawlessly with additional drive SWAP around 2GB. But after few days my server has been shut down instantly.

So when the superscripts of DO discovered that, my little server generated heavier traffic (only guessing), then my server has been cut out from connection to the Internet.

The fun part starts with billings because even after shutting down my VPS, I was still charged with full amount - it was not much, but hey, I hire this VPS mainly to have a cheap server with the connection to the Internet! If I wanted a simple server with a similar amount of RAM, I would buy Raspberry PI and connect only to a power adapter without access to the Internet. Buying so small VPS was IMHIO only about having static IP address they give it with and low cost of maintenance.

I was really angry and sad about this situation, but in the end, that’s good, that’s happened to me - I'll change VPS provider much quicker than I thought.
