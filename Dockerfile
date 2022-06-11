FROM debian

MAINTAINER "Dep de Redes" <redes@>

EXPOSE 22 80 443

# Atualizar e dependencias
RUN \
        apt-get update && \
        apt-get -y dist-upgrade && \
        apt-get install -y -q \
        	mysecureshell \
		git \
        	openssh-server \
		apache2 \
		apache2-utils \
		sudo \
		wget


#PHP8 Installation
RUN \
	apt update && \
	apt install -y -q \
		lsb-release \
		ca-certificates \
		apt-transport-https \
		software-properties-common \
		gnupg2
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
RUN wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
RUN \
	apt update && \
	apt install -y -q \
		php8.0 \
		php8.0-bcmath \
		php8.0-bz2 \
		php8.0-cli \
		php8.0-common \
		php8.0-curl \
		php8.0-dba \
		php8.0-fpm \
		php8.0-gd \
		php8.0-imagick \
		php8.0-imap \
		php8.0-intl \
		php8.0-ldap \
		php8.0-mbstring \
		php8.0-mcrypt \
		php8.0-memcache \
		php8.0-mysql \
		php8.0-opcache \
		php8.0-pgsql \
		php8.0-readline \
		php8.0-soap \
		php8.0-xml \
		php8.0-xmlrpc \
		php8.0-zip \
		libapache2-mod-php8.0

#Ajustando timezone
RUN echo "America/Fortaleza" > /etc/timezone

#Modulos proxy reverso
RUN a2enmod proxy proxy_http proxy_connect proxy_html auth_digest headers

#Ativando SSL
RUN ln -s /etc/apache2/mods-available/ssl.load  /etc/apache2/mods-enabled/ssl.load

#Configuracoes
#COPY ./config/sshd_config /etc/ssh/sshd_config
#COPY ./config/sftp_config /etc/ssh/sftp_config
#COPY ./config/php.ini-production /usr/local/etc/php/php.ini-production

#Usuarios
WORKDIR /var/www/html
RUN useradd -r -g www-data -u 1000 dev
RUN chown -R dev:www-data /var/www/html

#Senhas
RUN echo 'root:Docker!' | chpasswd
RUN echo 'Senha root: Docker!'
RUN echo 'Favor alterar!'
RUN echo 'dev:Docker!' | chpasswd

#Start Servicos
ENV APACHE_RUN_DIR /var/www/html
ENV APACHE_PID_FILE /var/www/html/pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/www/html

CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
