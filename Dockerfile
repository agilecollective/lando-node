FROM bitnami/node:10-debian-9-prod

ENV \
      APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true \
      NPM_CONFIG_UNSAFE_PERM=true

RUN apt-get update && apt-get install -y gnupg2 bzip2 curl \
  && rm -rf /etc/apt/sources.list.d/* \
  && apt-get clean

RUN npm install -g --unsafe-perm=true --allow-root backstopjs gulp-cli

RUN curl -sS https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
  && apt-get -y update && apt-get -y install google-chrome-stable php-cli php-mysql php-mbstring php-xml mysql-client apt-transport-https \
  && rm -rf /etc/apt/sources.list.d/* \
  && apt-get clean

RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
  && apt-get -qyy clean

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn \
  && rm -rf /etc/apt/sources.list.d/* \
  && apt-get clean

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

CMD [ "node" ]
