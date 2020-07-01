FROM kong:2.1-alpine

COPY kong.conf /etc/kong/

COPY kong.yml /usr/local/kong/declarative/

USER root

COPY . /custom-plugins/reedelk-transformer

WORKDIR /custom-plugins/reedelk-transformer

RUN luarocks make

USER kong