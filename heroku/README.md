# Deploy to Heroku

## Install Add-ons
- Heroku Postgres
- Heroku Redis

## Deploy
``` console
$ docker pull hoto17296/redash-base
$ heroku container:push --recursive
$ heroku container:release web worker
```
