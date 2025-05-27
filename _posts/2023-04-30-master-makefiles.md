---
layout: post
title: Mastering makefiles
tags: [macos, linux, profession]
---

```
PGHOST=localhost
PGPORT=5432
PGPASS=postgres
PGUSER=postgres
PGDBNAME=course
migrate_testdata:
	PGPASSWORD=${PGPASS} psql -h ${PGHOST} -p ${PGPORT} -U ${PGUSER} -f ./scripts/db-init-testdata.sql ${PGDBNAME}
```

```
migrate_testdata:
                |- "(" char will use variable from environment that is running on
                ▼
	PGPASSWORD=$(PGPASS) psql -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) -f ./scripts/db-init-testdata.sql $(PGDBNAME)
```

[weblink-imagemagic]: https://imagemagick.org/
[weblink-libheif-macos]: https://www.libde265.org/
[weblink-libheif-alternative]: https://github.com/strukturag/libheif
