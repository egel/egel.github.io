---
layout: post
title: The annoying popup for accepting incoming network connections
category: Development
tags: [golang, development]
date: 2018-06-16 11:22:00
---

If you're a Golang developer and you're using Mac OSX as your daily programming battle-station with IDEA IntelliJ editor, then for sure you've noticed this annoying popup for incoming connection when you compile your go app (if you by default blocking all unwanted connections).

![Do you want the application "__go_build_main_go" to accept incoming network connections?][img-do-you-want-accept-incoming-connections]

There is only one word for this if you see this 100 times a day and even when adding it to the Firewall exceptions didn't work - it's called "frustration".

But Hey! - **there is a really simple way to get rid off this annoying popup** each time you build your app.

The only thing you have to do is to set `localhost` to your server's hostname. This is important because otherwise, OSX treats any connection as a hostile connection (especially when you up intentionally).

So in summary, for local development, you have to set `host` and give a `port`. E.g.: `localhost:8000`.

To have a simple example where you can easily get where to apply it in to your program:

```go
http.ListenAndServe("localhost:" + strconv.Itoa(port), router))
```

So, finally, you can say an ultimate "bye, bye" to this annoying notification 🙂

<div class="alert alert-success">
<p><b>Do you want the application "__go_build_main_go" to accept incoming network connections?</b><br/>
Clicking Deny may limit the application's behavior. This setting can be changed in the Firewall pane of Security & Privacy preferences.</p>
</div>

[img-do-you-want-accept-incoming-connections]: {{ site.baseurl }}/assets/posts/accept-incomming-network-connections/do-you-want-accept-incoming-connections.png
