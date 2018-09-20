# Deploy to Heroku

## Install Add-ons
- Heroku Postgres
- Heroku Redis

## Deploy
``` console
$ heroku container:push --recursive
$ heroku container:release web
$ heroku container:release worker
```
