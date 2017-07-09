#===========================================================================
# apache2_tls_log_setting.sh
#   Copyright (C) 2017 Free Software Foundation, Inc.
#   Originally by ZhaoFeng Liang <zhf.liang@outlook.com>
#
#This file is part of DTHAS_SLOG.
#
#DTHAS_SLOG is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or 
#(at your option) any later version.
#
#DTHAS_SLOG is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with DTHAS_SLOG; If not, see <http://www.gnu.org/licenses/>.  
#===========================================================================

#!/bin/bash

#env
#root

########################################################################################
# 第一部分：
#	安装/配置 SSL
########################################################################################
	sudo apt-get install openssl
	sudo a2enmod ssl

	#-----------------------------------------------------------------
	# 创建密钥
	#-----------------------------------------------------------------
	cd /dita/cert

	openssl genrsa -out server.key 2048

	#-----------------------------------------------------------------
	# 创建CSR（证书签名请求，这不是证书）
	#-----------------------------------------------------------------
	cd /dita/cert

	openssl req -new -key server.key -out server.csr

	#-----------------------------------------------------------------
	# 创建CRT（这是证书，并且这里是“自签名证书”）
	#-----------------------------------------------------------------
	cd /dita/cert

	openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

	#-----------------------------------------------------------------
	# 将上面创建的证书和密钥复制到 /etc/ssl处
	#-----------------------------------------------------------------
	cd /dita/cert

	sudo cp server.crt /etc/ssl/certs 
	sudo cp server.key /etc/ssl/private

########################################################################################
# 第二部分：
#	安装/配置 apache2 https
########################################################################################

	#-----------------------------------------------------------------
	# 设置 site-enabled
	#-----------------------------------------------------------------
	ln -s /etc/apache2/sites-available/default-ssl /etc/apache2/sites-enabled/001-ssl

	#-----------------------------------------------------------------
	# 配置 default-ssl（/etc/apache2/sites-enabled/001-ssl）
	#-----------------------------------------------------------------
	1、vi /etc/apache2/sites-enabled/001-ssl
		1）在文件开头（最上面）增加：
			NameVirtualHost *:443

		2）DocumentRoot一行的下方加入内容：
			SSLEngine On
			SSLOptions +StrictRequire
			SSLCertificateFile /etc/ssl/certs/server.crt
			SSLCertificateKeyFile /etc/ssl/private/server.key

		3）注释以下内容（因为上面已设置）：
			#SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
        		#SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

		4）更改 web 文件存放的根目录：
			#DocumentRoot /var/www
        		DocumentRoot /var/www/log_check

			#<Directory /var/www/>
        		<Directory /var/www/log_check>

		5）保存/退出

	2、sudo service apache2 restart

	#-----------------------------------------------------------------
	# 测试
	#-----------------------------------------------------------------
	https://101.102.103.102/main.php


########################################################################################
# 第三部分：
#	配置 apache2 https 日志
########################################################################################

	vi /etc/apache2/sites-enabled/001-ssl

		#ErrorLog ${APACHE_LOG_DIR}/error.log
        	ErrorLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_tls_error_log 86400 480"
		
		#CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined
        	CustomLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_tls_access_log 86400 480" common
















