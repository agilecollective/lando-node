FROM node:carbon-jessie

RUN npm install -g --unsafe-perm=true --allow-root backstopjs gulp-cli

RUN sed -i '/jessie-updates/d' /etc/apt/sources.list  # Now archived

RUN apt-get update -qqy \
  && apt-get -qqy install ca-certificates apt-transport-https \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN curl -L https://packages.sury.org/php/apt.gpg | apt-key add - \
  && echo "deb https://packages.sury.org/php/ jessie main" >> /etc/apt/sources.list.d/php.list \
  && curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable php7.2-cli php7.2-mysql php7.2-mbstring php7.2-xml mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

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
