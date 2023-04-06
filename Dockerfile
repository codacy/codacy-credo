ARG elixir_version

FROM elixir:1.10.4-alpine as builder
LABEL Codacy <team@codacy.com>
ENV MIX_ENV=prod
WORKDIR /tmp/build
ADD . /tmp/build
# Build & install deps
RUN mix do local.hex --force, local.rebar --force
RUN mix deps.get
RUN mix deps.compile
RUN mix release

FROM alpine:3.17.3
LABEL Codacy <team@codacy.com>
RUN apk add --update openssl bash && \
    rm -rf /var/cache/*/*
# Copy Codacy Docs
ADD docs /docs
COPY --from=builder /tmp/build/_build/prod/rel/codacy_credo /opt/app/codacy_credo/
# Configure user
RUN adduser -u 2004 -D docker

COPY .credo.default.exs /opt/app/codacy_credo/.credo.exs

# create configuration folder, required by codacy_credo
RUN mkdir /opt/app/configuration

RUN ["chown", "-R", "docker:docker", "/docs"]
RUN ["chown", "-R", "docker:docker", "/opt/app"]
USER docker
ENTRYPOINT [ "/opt/app/codacy_credo/bin/codacy_credo", "start"]
