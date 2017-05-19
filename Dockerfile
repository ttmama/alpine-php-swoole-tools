FROM registry.cn-qingdao.aliyuncs.com/ttmama/docker-alpine-php-swoole:latest
RUN apk add --no-cache bash git vim jpeg freetype
RUN docker-php-ext-install pdo_mysql

#####################################
# gd:
#####################################

# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/lib && \
    docker-php-ext-install gd


#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer