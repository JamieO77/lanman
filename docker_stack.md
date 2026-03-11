version: "3.8"

networks:
  devnet:
    driver: bridge

services:

  mysql:
    image: mysql:5.7
    container_name: dev-mysql
    restart: unless-stopped
    environment:
      PMA_HOST: mysql
      PMA_USER: root
      PMA_PASSWORD: username_here
      MYSQL_ROOT_PASSWORD: password_here
      MYSQL_DATABASE: dev_main
      MYSQL_USER: username_here
      MYSQL_PASSWORD: password_here
      # This allows root to connect from PHPMyAdmin and your PC
      MYSQL_ROOT_HOST: '%'
    ports:
      - "3306:3306"
    volumes:
      - mysql_data_v2:/var/lib/mysql
      - /c/DockerConfigs/init.sql:/data/application/init.sql
    networks:
      - devnet

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: dev-phpmyadmin
    restart: unless-stopped
    ports:
      - "8084:80"
    environment:
      PMA_HOST: mysql
      MYSQL_ROOT_PASSWORD: password_here
    networks:
      - devnet

  apache-php:
    image: php:8.1-apache
    container_name: dev-apache
    restart: unless-stopped
    ports:
      - "8089:80"
    volumes:
      - www_data_v2:/var/www/html
      - ./logs:/var/log/apache2
    environment:
      TZ: Europe/Lisbon
    command: >
      bash -c "
      apt-get update &&
      apt-get install -y libzip-dev libpng-dev libjpeg-dev libonig-dev libxml2-dev unzip libfreetype6-dev &&
      docker-php-ext-configure gd --with-freetype --with-jpeg &&
      docker-php-ext-install pdo pdo_mysql zip mbstring gd &&
      echo 'date.timezone=Europe/Lisbon' > /usr/local/etc/php/conf.d/timezone.ini &&
      apache2-foreground"
    networks:
      - devnet

  filebrowser:
    image: filebrowser/filebrowser
    container_name: dev-filebrowser
    restart: unless-stopped
    ports:
      - "8083:80"
    volumes:
      - www_data_v2:/srv/www
      - mysql_data_v2:/srv/mysql
      - ./logs:/srv/logs
    networks:
      - devnet

volumes:
  mysql_data_v2:
  www_data_v2:
