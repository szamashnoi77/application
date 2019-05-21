FROM php:7.2-fpm

LABEL maintainer=""

RUN apt update -q && apt install -yqq \
    gnupg

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
RUN bash -c 'source $HOME/.nvm/nvm.sh && nvm install 8.9.0'

RUN apt update -q && apt upgrade -yqq && apt install -yqq \
    git \
    libmagickwand-dev \
    libmcrypt-dev \
    libssl-dev \
    yarn \
    zip \
    zlib1g-dev libicu-dev g++ && \
    pecl install \
        imagick \
        mcrypt-1.0.1 \
        redis && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        intl && \
    docker-php-ext-enable \
        imagick \
        mcrypt \
        redis


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV PATH=$PATH:/root/.nvm/versions/node/v8.9.0/bin

WORKDIR /usr/share/nginx/

