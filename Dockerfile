FROM fluent/fluentd

LABEL maintainer="UPTECH SERVICOS EM TECNOLOGIA DA INFORMACAO LTDA <root@uptech.com.br>"
LABEL version="1.0.0"

USER root

RUN apk add --no-cache --update --virtual .build-deps \
    build-base ruby-dev && gem install fluent-plugin-mongo fluent-plugin-multiprocess && \
    gem sources --clear-all && apk del .build-deps && \
    rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY rootfs /

RUN chmod +x /bin/entrypoint.sh