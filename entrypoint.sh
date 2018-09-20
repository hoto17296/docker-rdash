#!/bin/sh

# Heroku Add-ons Support
REDASH_DATABASE_URL=${REDASH_DATABASE_URL:-${DATABASE_URL}}
REDASH_REDIS_URL=${REDASH_REDIS_URL:-${REDIS_URL}}

case $1 in

  create_db)
    /app/manage.py database create_tables
    ;;

  server)
    /usr/local/bin/gunicorn \
      --name redash \
      -b 0.0.0.0:${PORT:-5000} \
      -w ${REDASH_WEB_WORKERS:-4} \
      redash.wsgi:app
    ;;

  worker)
    /usr/local/bin/celery \
      --app=redash.worker \
      -c ${WORKERS_COUNT:-2} \
      -Q ${QUEUES:-queries,scheduled_queries,celery} \
      -l info \
      --maxtasksperchild=10 \
      -O fair \
      worker
    ;;

  scheduler)
    /usr/local/bin/celery \
      --app=redash.worker \
      --beat \
      -c ${WORKERS_COUNT:-1} \
      -Q ${QUEUES:-celery} \
      -l info \
      --maxtasksperchild=10 \
      -O fair \
      worker
    ;;

  *)
    exec $@
    ;;

esac
