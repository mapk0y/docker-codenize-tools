FROM ruby:alpine

RUN set -ex \
      && apk add --no-cache --virtual .codenize-builddeps \
         build-base \
         libpcap-dev \
         libxml2-dev \
         libxslt-dev \
      && gem install nokogiri -- --use-system-libraries \
      && gem install \
         roadworker \
         piculet \
         kelbim \
         miam \
         eipmap \
         mappru \
         cfdef \
      && runDeps="$( \
           scanelf --needed --nobanner --recursive /usr/local/bundle/gems/ \
             | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
             | sort -u \
             | xargs -r apk info --installed \
             | sort -u \
         )" \
      && apk add --no-cache --virtual .codenize-rundeps $runDeps \
      && apk del .codenize-builddeps

