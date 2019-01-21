FROM ruby:alpine

COPY Gemfile Gemfile.lock /
RUN set -ex \
      && apk add --no-cache --virtual .codenize-builddeps \
         build-base \
         libpcap-dev \
         libxml2-dev \
         libxslt-dev \
      && bundle config build.nokogiri --use-system-libraries \
      && bundle install \
      && runDeps="$( \
           scanelf --needed --nobanner --recursive /usr/local/bundle/gems/ \
             | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
             | sort -u \
             | xargs -r apk info --installed \
             | sort -u \
         )" \
      && apk add --no-cache --virtual .codenize-rundeps $runDeps \
      && apk del .codenize-builddeps

