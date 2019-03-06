FROM bitnami/node:10

RUN npm install -g --unsafe-perm=true --allow-root backstopjs gulp-cli

RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub \
  && apt-key add linux_signing_key.pub \
  && wget https://www.dotdeb.org/dotdeb.gpg \
  && apt-key add dotdeb.gpg \
  && rm dotdeb.gpg linux_signing_key.pub \
  && echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list \
  && echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && apt-get -y update && apt-get -y install google-chrome-stable php-cli php-mysql php-mbstring php-xml mysql-client apt-transport-https \
  && apt-get clean
  
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install yarn \
  && apt-get clean
  
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

RUN groupmod -g 999 node && usermod -u 999 -g 999 node

CMD [ "node" ]
