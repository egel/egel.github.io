FROM node:22-alpine3.21

# make sure to use specyfic verson of yarn from docs
RUN yarn --version
RUN yarn set version 3.2.4
RUN yarn --version

RUN apk update
RUN apk add --no-cache git
RUN rm -rf /var/cache/apk/*

WORKDIR /app
COPY . .

# install root packages
#
# INFO: DO NOT INSTALL ON LOCALHOST BEFORE BUILD WITH DOCKER
#       as there are some problems with cached preinstalled packages
RUN yarn

# the docs require some packages from packages/react-icons
# and pull git repositories with icons
WORKDIR /app/packages/react-icons
RUN ls -al
RUN yarn fetch
RUN ls -al
RUN yarn build

# change dir to docs and build documentation
WORKDIR /app/packages/preview-astro
RUN ls -al

EXPOSE 8080
CMD ["yarn", "start", "--port", "8080", "--host"]
