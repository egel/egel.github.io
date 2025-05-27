---
layout: post
title: Publishing private package with your gitlab registry
category: Diary
tags: [gitlab, npm, npm-package]
---

There is a moment in frontend software development that is good to finally create own separate
package for part of your fuctionality (or when you duplicate code mulitple times).

In this small article we will look on the process of publishing and using the newly published
package in your application.

There will be 2 parts of this article. In first part we will look how to publish an existing package
to your private gitlab instance and what are generally best practices during the process.

In 2nd part we will use this newly created package in your application with some tips what problems
you may encounter while daily development.

Let's start!

## Part 1: Pushing package to private Gitlab npm registry

I imagine you have already some simple npm library created with important functionality you want to

Sometime it is important to clean local npm cache especially when you upload and update new package
version.

```bash
npm cache clean --force
```

## Part 2: using package in other project

## solution 1

gitlab >= 16.6

```bash
#!/bin/bash

CI_JOB_TOKEN=<here is gitlab token>
CI_SERVER_HOST=gitlab.synaos.com
CI_PROJECT_ID=341

_PACKAGE_NAME='@synaos/data'
_PACKAGE_VERSION='1.0.0'

curl --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    "https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages?order_by=version&sort=desc&package_name=${_PACKAGE_NAME}&package_version=${_PACKAGE_VERSION}" > registry_package_list.json
echo ""
# jq '. | length' registry_package_list.json
jq '.' registry_package_list.json

_REGISTRY_PACKAGE_ID=$(jq --raw-output -c '.[0].id' registry_package_list.json)
echo ""
echo  ">>${_REGISTRY_PACKAGE_ID}"

exit 1
curl --request DELETE \
    --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    "https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/${_REGISTRY_PACKAGE_ID}"
```

## solution 2

gitlab < 16.6

```bash
#!/bin/bash

CI_JOB_TOKEN=<here is gitlab token>
CI_SERVER_HOST=gitlab.synaos.com
CI_PROJECT_ID=341

_PACKAGE_NAME='@synaos/data'

# curl --verbose --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" "https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages?order_by=version&sort=desc" > registry_package_list.json
# echo ""
#cat registry_package_list.json
cat registry_package_list.json
#_REGISTRY_PACKAGE_ID=$(jq -r --arg PACKAGE_NAME "${_PACKAGE_NAME}" 'recurse(.[]?) | objects | select(.name=="$PACKAGE_NAME")' registry_package_list.json)
# echo -n $_PACKAGE_NAME
echo ""
echo ""
jq --raw-output --arg pn "$_PACKAGE_NAME" -c 'recurse(.[]?) | objects | select(.name != null) | select(.name | contains($pn)) | .id' registry_package_list.json
exit 1

echo ""
echo  ">>${_REGISTRY_PACKAGE_ID}"

curl --verbose --request DELETE --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" "https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/${_REGISTRY_PACKAGE_ID}"
```
