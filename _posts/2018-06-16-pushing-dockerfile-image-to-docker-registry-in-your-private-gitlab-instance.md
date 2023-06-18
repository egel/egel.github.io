---
layout: post
title: Pushing Dockerfile image to docker registry in your private Gitlab instance
published: true
tags: [docker, gitlab, registry, dockerhub]
---

There are several approaches to push your docker image to docker registry instance, although we'll create a file `Dockerfile`, build it, tag it, and afterward send it to our own instance of docker registry. You could also use the same approach for any other registries (e.g: dockerhub, gitlab)

My example will be base on creating a docker image with Node 8 and Chrome browser on the board (I created it for running unit test against chrome headless).

> Important part is to create an account in your docker instance with valid access to pushing & pulling images.
>
> You also need to login to your docker registry. The example login would look like:
>
> ```bash
> docker login docker.example-domain.com:4567
> ```

### Creating a Dockerfile

Create a desired `Dockerfile` image. I used simple Node8 with `yarn`.

> I used a custom name for the Dockerfile which is `Dockerfile.node_8` only to present how to also use it with a custom name. If you just use the default name `Dockerfile` then you don't have to specify a characteristic `--file` flag.

```dockerfile
FROM node:8

# Use this path as the main working directory
WORKDIR /usr/src/app/client

COPY package.json ./
COPY yarn.lock ./

EXPOSE 8080
CMD yarn && yarn run start
```

### Build and push the image to the registry

Secondly, to build the `Dockerfile` image and tag it you have to use command:

```bash
docker build --tag my-private-node-8:latest ~/workspace/directory-with-dockerfile-inside/
```

Next, check if the image works as you expected via:

```bash
docker run --interactive --tag my-private-node-8:latest /bin/bash
```

Later, re-tag the image with the name that will be visible on your docker hub. For example, your docker hub is available at URL `docker.example-domain.com:4567`, then you have to create an image and add the version of this image.

```bash
docker tag my-private-node-8:latest docker.example-domain.com:4567/my-private-node-8:1.0.0
```

> Note: If you have multiple versions like: 0.1.0, 0.8.1, ..., etc. It's a good practice to increase the version and update also the `:latest` tag regarding new version your last created image.

The last step. Push this new tagged image to the docker registry:

```bash
docker push docker.example-domain.com:4567/my-private-node-8:1.0.0
```

or create a new image with tag directly from your `Dockerfile`. The `.` at the very end of the command is important.

```bash
docker build --file ./Dockerfile.node_8 -t docker.example-domain.com:4567/my-private-node-8:1.0.0 .
```

In the end, you should have your new image in the registry and everyone else who can have access to your Gitlab project can use this container.

### Test the created image

To test if everything working, you can run and examine the image if everything working as desired.

```bash
docker exec -it docker.example-domain.com:4567/my-private-node-8:1.0.0 /bin/bash
```
