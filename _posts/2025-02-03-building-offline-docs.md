---
layout: post
title: Building offline docs
published: true
tags: [macos, docker, nginx, npm, yarn]
---

In the last month, I had a serious problem with my internet connection for few weeks. When it was lost for a few days, I immediately started appreciating every downloaded kilobyte. Therefore, while using my mobile carrier, I've been forced to find a solution for myself in order not to consume all of my remaining bandwidth at once.

The biggest problem was how to use documentation from services in offline mode. Many of them are usually easily available online, so normally we don't think about that at all.

The situation I'd been put into encouraged me to find a fast solution. I started by finding all the documentation for the services I needed and putting it into lists, so I had everything I actually needed to download.

Promptly, I reached the place with the nearest stable internet connection and downloaded all of the repository files that I wanted, with the plan to compile them and serve them myself on my local machine using portable containers.

The sample list you can find below:

-   jsdocs ([jsdoc.github.io][weblink-jsdoc-github-io])
-   [tailwind][weblink-tailwind-github] for [v3](https://v3.tailwindcss.com/) (and in meantime come out v4)
-   [material UI][weblink-material-ui-github]
-   [react-icons][weblink-react-icons]
-   [react-hook-form][weblink-react-hook-form]
-   [SVGOGM][weblink-svgomg] a missing GUI for [svgo]

As I mentioned before, I started with downloading all of them and testing if I could run them offline. However, the funny thing was, after downloading, I realized that wasn't the end of pulling new things. Usually, the files are just source files without dependencies, so later you need to pull another bunch of dependencies required for the project to start. And to make it even more complex, each project might use a different way of installing its own dependencies. Moreover, some projects have dependencies that have their own dependencies, and then things can get complicated.

After realizing this, I figured out that it would be actually pretty cool if every project documentation had an offline image that could be easily pulled with one click. That would be very helpful for a consumer like me, who finds himself in the situation of being offline for a while.

> Just a side note: Dependencies were one thing, but the most challenging part was to discover a proper way to compile all and build all of those documentations. Each of them has a different way of doing this. I think the most challenging project to compile was the React icons project.

All Docker containers that I created for myself and are ready to use will be found at the end of this article.

## Dockerization process

Let's take a look at the first example with the JS docs, available at [jsdoc.github.io][weblink-jsdoc-github-io]. This repository is actually very simple and easy to dockerize, so I will start with this one as an example. It will be easy to demonstrate how we can achieve our goal.

Also, it's worth mentioning that for creating Dockerfiles (or actually, in the end, Docker images), there are two ways of doing this:

-   The faster way, but less elegant and sometimes faulty - usually done by utilizing a spinning dev server inside the container. Those images are relatively much larger due to containing all of the dependencies required for running the server.
-   The slower way, although producing smaller and more efficient images - by compiling source files and serving them statically with reliable servers like Nginx, for example.

I will start with the first way, also known as the "quick and dirty" method, to get some fast results. Later, I will do another example using a more efficient way of compiling and serving the content with previously mentioned Nginx.

### Big and dirty image

As I mentioned, this way of creating containers is fast, although big and dirty as well. I would not recommend using it in production environments. Usually, the images are very large and inappropriate for end-consumer users. Although, for our purposes to serve documentation locally, it's totally fine.

```bash
cd workspace
git clone git@github.com:jsdoc/jsdoc.github.io.git

cd jsdoc.github.io

# create our own Dockerfile
touch Dockerfile
```

Now that we've pulled the project, we can open a freshly created `Dockerfile` which will help us dockerize our documentation.

```Dockerfile
FROM node:22

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json

RUN npm install
COPY . .

EXPOSE 8080
CMD ["npm", "run", "serve", "--", "--port", "8080"]
```

> PRO TIP: When creating Dockerfiles, I strongly recommend using [hadolint][weblink-hadolint-github] linter. This library will greatly help you enforce best practices for creating great Dockerfiles. Please don't be surprised if many of your current practices are discouraged or rejected – but hey, it's all about creating files that are best for team work and future maintenance, right?

Now build the documentation and start a Docker container on port 9001.

```bash
docker build -f Dockerfile -t jsdoc:latest . && docker run --name jsdoc-offline -p 9001:8080 jsdoc:latest
```

That's all for "the fast and dirty" creation of docker image. Let's jump to the next section of creating more effective Docker image.

### The effective way

Actually, I think it would be even more great to recreate the same documentation using a more effective technique and compare the results together. I'd be most excited about seeing the final sizes of the Docker images. We could also test the performance, although that would be rather an objective test of the servers running under the hood than a measuring of our benefits - a runnable image that we as clients just want to use.

So let's start by recreating the previous solution using a more effective way.

In this process, we usually have a few steps:

1. In the first step, we create a container where we actually pull all dependencies needed for the process of compiling the documentation.
2. The second step involves preparing the final server - small and fast, containing only the necessary programs or libraries to run the compiled files.

As in the previous example, let's create another Docker file `Dockerfile_v2` and start coding.

```Dockerfile
###################################
# build compilation image
###################################
FROM node:22 AS build

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json

RUN npm install

# copy rest of files and build
COPY . .
RUN npm run build
RUN ls -al /app/_site


###################################
# Building final image
###################################
FROM nginx:1-alpine3.20

RUN mkdir -p /usr/share/nginx/html
COPY --from=build /app/_site /usr/share/nginx/html
RUN ls -al /usr/share/nginx/html

COPY nginx-jsdoc.conf /etc/nginx/nginx.conf

EXPOSE 80/tcp

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# vi: ft=dockerfile
```

So here we created the first build compilation where we execute our build. And right after, we're building a final image, and only that last build will be used in the final image.

One thing that we still need to add, and is still missing from the configuration? Do you see what's missing? Yes, it's our new Nginx configuration without which our server wouldn't be able to serve our content properly.

Let's create the last `nginx-jsdoc.conf` file. The full configuration can also be found below.

```nginx
user nginx;
worker_processes auto;

events {
    worker_connections  1024;
}

http {
    include mime.types;

    # remove nginx version from server header
    server_tokens off;

    access_log /dev/stdout;
    error_log /dev/stdout info;

    # opt file nginx async filehandling
    sendfile on;
    keepalive_timeout  65;

    server {
        listen 80 default_server;

        # location of static files to serve
        root /usr/share/nginx/html;

        location / {
            try_files $uri $uri/ $uri.html $uri/index.html /index.html =404;
        }
    }
}
```

All done together and now we can get into the last part, the build of the final Docker image.

```bash
docker rm jsdoc-offline; docker build -f Dockerfile_v2 -t jsdoc:latest . && docker run --name jsdoc-offline --rm -p 9002:80 jsdoc:latest
```

## Comparing images

So now let's compare what we actually gain from using a bit more complex way rather than the fast and dirty method. I am actually quite curious if you can estimate what will be the size of both images without knowing it yet.

But let's not prolong this, and the final results you can find below for my local builds (M3).

{% raw %}

```bash
→ docker images jsdoc-dirty:latest --format "{{.Repository}}:{{.Tag}} -> {{.Size}}"

jsdoc-dirty:latest -> 1.85GB

→ docker images jsdoc:latest --format "{{.Repository}}:{{.Tag}} -> {{.Size}}"

jsdoc:latest -> 77.6MB
```

{% endraw %}

As you can see, the fast and dirty image is quite big, and to be precise it is 2.384% larger than the more efficient version. So now you see why the efficient way is much better for end customers like us, especially when downloading bandwidth matters the most.

The results could be quite shocking for those who might not have realized before how big a dev server can be - especially those who run on npm and node_modules (I apologize, I couldn't rest).

![node_modules][img-node-module-joke]

Thank you for your time, staying with me and reading until the very end. Hope you find this enjoyable. See you until the next one.

[img-node-module-joke]: {{ site.baseurl }}/assets/posts/building-offline-docs/node_modules-heaviest-object-universe.jpg
[weblink-hadolint-github]: https://github.com/hadolint/hadolint
[weblink-jsdoc-github-io]: https://github.com/jsdoc/jsdoc.github.io
[weblink-tailwind-github]: https://github.com/tailwindlabs/tailwindcss
[weblink-react-icons]: https://react-icons.github.io/react-icons/
[weblink-svgomg]: https://jakearchibald.github.io/svgomg/
[weblink-react-hook-form]: https://react-hook-form.com/
[weblink-material-ui-github]: https://github.com/mui/material-ui
