FROM python:2-alpine

ENV REDASH_VERSION=5.0.1

RUN wget https://github.com/getredash/redash/archive/v${REDASH_VERSION}.tar.gz -O redash.tar.gz -q \
    && tar xzf redash.tar.gz \
    && rm -f redash.tar.gz \
    && mv redash-${REDASH_VERSION} /app

WORKDIR /app

RUN apk add --no-cache libpq libffi

RUN apk add --no-cache --virtual .build-deps \
      gcc libressl-dev postgresql-dev libffi-dev musl-dev nodejs npm git \
    && sed -i -e 's/cryptography==2.0.2/cryptography==2.3/' requirements.txt \
    && pip install -r requirements.txt --no-cache-dir \
    && npm install && npm run build && rm -rf node_modules \
    && apk del .build-deps

ADD entrypoint.sh /

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["sh"]
