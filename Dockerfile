FROM registry.cn-qingdao.aliyuncs.com/ttmama/docker-alpine-php-swoole:latest
RUN apk add --no-cache bash git vim jpeg-dev freetype-dev
RUN docker-php-ext-install pdo_mysql

#####################################
# gd:
#####################################

# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/include \
        --with-freetype-dir=/usr/include && \
    docker-php-ext-install gd

#####################################
# PHP REDIS EXTENSION FOR PHP 7.0 & ZIP
#####################################
USER root
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS linux-headers \
&& pecl install -o -f redis \
&& docker-php-ext-enable redis \
&& pecl install zip-1.13.5 \
&& docker-php-ext-enable zip \		
&& rm -rf /tmp/pear \	
&& apk del .phpize-deps
	
#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer