---
layout: post
title: Private and local LLM with Ollama
tags: [linux, k8s, llm]
---

In previous articles I setup my local k8s home cluster. Now comes the time to utizize its potential and I wanted to try with setup local & private (this was important) and check usability of some LLM models.

My rig is not especiall Ollama friendly a the requirements depends on used model. Some models require lot more then the others. Therefore in this article I will focus on setup the environment to operate the models and use simple, lightweight `llama3.2:latest` that is design to work with small requirements.

## Requirements

version used at the time of writing

ollama: v3

test connection form your local network, eg from your laptop

```sh
curl http://192.168.178.200:31434/api/generate -d '{ "model": "your_model_name", "prompt": "your_prompt" }'
```

pull model `llama3.2:latest`

[post-home-k8s-cluster]: {{ site.baseurl }}{% link _posts/2024-08-26-home-k8s-cluster.md %}
[post-install-and-configure-debian12]: {{ site.baseurl }}{% link _posts/2025-06-11-complete-guide-to-install-and-configure-debian-12 copy.md %}
[weblink-ollama-llama32]: https://ollama.com/library/llama3.2
