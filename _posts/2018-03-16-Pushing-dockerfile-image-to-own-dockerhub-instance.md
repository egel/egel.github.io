---
layout: post
title: Pushing dockerfile image to own docker hub instance
published: true
tags: [docker, dockerhub]
---

There are several ways how to accomplish it, although we'll create a file `Dockerfile`, build & tag it, and afterward send it to our own docker hub instance.

My example will be based on creating docker imager with node 6 and chrome installed (I created it for running unit test against chrome headless).

> Important part is to create an account in your own docker hub instance with valid access to pushing & pulling images.

Create a desired `Dockerfile`.

Secondly, build this image with command:

```bash
docker build --tag node-6-with-chrome:latest ~/workspace/directory-with-dockerfile-inside/
```

Next, check if the image works as you expected via:

```bash
docker run --interactive --tag node-6-with-chrome:latest /bin/bash
```

Later, re-tag the image with the name that will be visible on your docker hub. For example, your docker hub is available via: `docker.example-domain.com:4567` then you have to create a right project and the version of the image.

```bash
docker tag node-6-with-chrome:latest docker.example-domain.com:4567/node-6-with-chrome:1.0.0
```

> Note: If you have multiple versions 0.1.0, 0.8.1 ... etc. It's a good practice to increase the version and update the `:latest` tag as well if the new version that you added is really the latest.

The last step - push new tag name to the docker hub:

```bash
docker push docker.example-domain.com:4567/node-6-with-chrome:1.0.0
```

or create a new image with tag directly from your Dockerfile

```bash
docker build --file ./Dockerfile.node_6_with_chrome -t docker.example-domain.com:4567/wobcom/cssp/node-6-with-chrome:1.0.0 .
```

Finally, we and everyone else who has access to docker hub can use the container.

```bash
docker exec -it docker.example-domain.com:4567/node-6-with-chrome:1.0.0 /bin/bash
```