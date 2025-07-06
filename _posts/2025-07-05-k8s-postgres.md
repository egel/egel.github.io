---
layout: post
title: Create PostgreSQL with pgAdmin4 in kubernetes
published: true
tags: [k8s, kubernetes]
# feature-img: "assets/img/feature/pexels-fatih-turan-63325184-8777703.jpg"
---

Assumptions

- have configured and running cluster with access to `kubectl`
- creating postgres for sample `jupiter` namespace. Replace it with some other namespace of your
  preferences
- I intentionally choose names that differs from each other so there is no much repetition with
  understanding of them
- `k` command stands for kubectl
- Postgres Credentials:
  - user: `postgres` (if you use different user name, please remember to add role, or will get error: `FATAL:  role " " does not exist` on your instances)
  - password: `super-secret-pass`
  - db: `testdb`

TIP: if you use `alias k=kubectl` this may not work if you want to `watch` some sommands:

```sh
$ which kubectl
/usr/bin/kubectl

$ ln -sf /usr/bin/kubectl /usr/local/bin/k
```

### Create namespace

```sh
k create ns jupiter
```

### Create postgres Secrets

- replace namespace, user and password with
- for getting secure password you can use `openssl rand -base64 12`. of course adjust the length to your needs

```sh
k -n jupiter create secret generic postgres-secret --from-literal pg_user=postgres --from-literal pg_pass=super-secret-pass --dry-run=client -oyaml > postgres-secret.yaml

# examin if all is correct
cat postgres-secret.yaml

# apply
k create -f postgres-secret.yaml
```

### Create postgres ConfigMap

```sh
k -n jupiter create configmap postgres-configmap --from-literal=pg_db=testdb --dry-run=client -oyaml > postgres-configmap.yaml

k create -f postgres-configmap.yaml
```

### Create service

As we want to test connection to our service locally therefore we use `NodePort` service. If you need something else consider `ClusterIP` or `LoadBalance` instead.

```

```

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: postgres
  name: postgres-svc
spec:
  ports:
  - name: "5432"
    port: 5432
    protocol: TCP
    targetPort: 5432
    nodePort: 31010
  selector:
    app: postgres
  type: NodePort
status:
  loadBalancer: {}
```

### Create StatefulSet

```
```

--- 

Please do not use `kind: Deployment` as Postgres replication as you might easily find **wrong setup in some popular online tutorials like [How to Deploy Postgres to Kubernetes Cluster][weblink-digitalocean-postgres-setup] (Published on January 19, 2024) by [hitjethva](https://www.digitalocean.com/community/users/hitjethva) and [Anish Singh Walia](https://www.digitalocean.com/community/users/asinghwalia)**. 

It's not designed to serve stateful applications like PostgreSQL with simple deployment kind. As when the pod dies the data will also die so it may cause some troubles with replication.


To properly server pods with connection pool we should add pg-pool service but currently for simplicity I will omit this.


### Test logging to postgres

```sh
# remind password
$ k get secrets postgres-secret -ojsonpath={.data.pg_pass} | base64 -d

$ k exec postgres-0 -it -- psql -U postgres

$ k exec postgres-0 -it -- psql -U postgres
Password:
psql (17.5 (Debian 17.5-1.pgdg120+1))
Type "help" for help.

testdb=#
```

## Create pgAdmin4

Create secrets

```sh
k -n jupiter create secret generic pgadmin-secret --from-literal pgadmin_default_email=johndoe@example.com --from-literal pgadmin_default_pass=super-secret-pass --dry-run=client -oyaml > pgadmin4-secret.yaml

k create -f pgadmin4-secret.yaml
```

Create deployment

```

```

## Resources:

- <https://refine.dev/blog/postgres-on-kubernetes/#deploying-postgresql-using-configmaps-and-secrets>
- <https://www.postgresql.org/docs/17/libpq-envars.html>

[weblink-digitalocean-postgres-setup]: https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
[weblink-devopscube-postgres]: https://devopscube.com/deploy-postgresql-statefulset/#pg-pool-for-postgres
[weblink-wiki-hex]: https://en.wikipedia.org/wiki/Hexadecimal
[weblink-wiki-hsl]: https://en.wikipedia.org/wiki/HSL_and_HSV
[weblink-dockerhub-postgres]: https://hub.docker.com/_/postgres/
[weblink-devto-pgadmin]: https://dev.to/dbazhenov/running-pgadmin-to-manage-a-postgresql-cluster-in-kubernetes-616
[weblink-so-postgresql-role-doesnt-exist]: https://stackoverflow.com/questions/8092086/create-postgresql-role-user-if-it-doesnt-exist
[weblink-so-create-init-script]: https://stackoverflow.com/questions/26598738/how-to-create-user-database-in-script-for-docker-postgres
[weblink-so-fix-pgadmin4-port-and-volume]: https://stackoverflow.com/questions/64223555/pgadmin4-on-kubernetes-saving-users-and-settings-in-a-volume
[]

[img-node-module-joke]: {{ site.baseurl }}/assets/posts/building-offline-docs/node_modules-heaviest-object-universe.jpg
