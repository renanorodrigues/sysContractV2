FROM ruby:3.0-alpine AS base

ENV INSTALL_PATH /app

RUN apk add --update --no-cache curl py-pip \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn

FROM base AS dependencies

RUN apk add --update build-base

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install 

FROM base

WORKDIR $INSTALL_PATH

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY . $INSTALL_PATH

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]