# docker-redash-base
Unofficial Docker images for the Redash project.

## Difference from official image
- Minimal
  - The image size is half as compared with the official image
  - Based on Alpine Linux
  - No custom data source packages are installed
- Heroku support
  - `PORT` environment variable is available

## Setup

### Add additional packages
This image contains only minimal packages.
So you need to install additional packages to connect to some data sources.

For example, when connecting to Hive, you need to install `pyhive` as follows.

``` Dockerfile
FROM hoto17296/redash-base

RUN pip install pyhive
```

``` console
$ docker build . -t redash
```

### Create tables
``` console
$ docker run --rm -it \
    -e REDASH_DATABASE_URL=postgres://username:password@hostname:port/database \
    -e REDASH_REDIS_URL=redis://username:password@hostname:port/database \
    redash manage database create_tables
```

## Run
``` console
$ docker run --rm -d \
    -p 5000:5000 \
    -e REDASH_DATABASE_URL=postgres://username:password@hostname:port/database \
    -e REDASH_REDIS_URL=redis://username:password@hostname:port/database \
    redash (server|scheduler|worker)
```

## Environment variables
To support Heroku, `PORT` environment variable is available.

| key | default value |
|---|---|
| `PORT` | `5000` |
| `REDASH_DATABASE_URL` | `postgresql:///postgres` |
| `REDASH_REDIS_URL` | `redis://localhost:6379/0` |

For more environments, see: https://github.com/getredash/redash/blob/master/redash/settings/__init__.py
