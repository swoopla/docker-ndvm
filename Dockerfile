FROM node:alpine as src

ENV SRC_URL=https://codeload.github.com/NDVM/NDVM/zip/master

RUN wget ${SRC_URL} --output /tmp/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    sed -i -e 's/^\(var html5Player =\) false/\1 true/' /tmp/NDVM-master/server/server.js

FROM node:alpine

LABEL MAINTAINER "Swoopla <p.vibet@gmail.com>"

COPY --from=src /tmp/NDVM-master/ /srv

RUN apk add ffmpeg sqlite

EXPOSE 7519

VOLUME ["/mnt", "/srv/data/cache", "/srv/data/db"]

WORKDIR /srv/server

CMD ["node", "server.js", "nobrowser"]

