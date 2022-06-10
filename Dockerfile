FROM debian

MAINTAINER "Dep de Redes" <redes@natal.rn.gov.br>

EXPOSE 22 80 443

RUN \
        apt-get update && \
        apt-get -y dist-upgrade && \
        apt-get install -y -q \
        mysecureshell \
		git
        openssh-server
		apache2
#       && docker-php-ext-install pdo_mysql gd opcache

#Ajustando timezone
RUN echo "America/Fortaleza" > /etc/timezone

#Modulos proxy reverso
RUN a2enmod proxy proxy_http proxy_connect proxy_html auth_digest headers

#Ativando SSL
#RUN ln -s /etc/apache2/mods-available/ssl.load  /etc/apache2/mods-enabled/ssl.load

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
#RUN echo '/etc/init.d/ssh start' | bash
