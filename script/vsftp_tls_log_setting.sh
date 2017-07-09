#===========================================================================
# vsftp_tls_log_setting.sh
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
#	安装/配置 vsftp tls
########################################################################################

	#-----------------------------------------------------------------
	# 防火墙设置（如果已打开防火墙）：
	#-----------------------------------------------------------------
	sudo ufw allow 990/tcp
	sudo ufw allow 40000:50000/tcp
	sudo ufw status

	#-----------------------------------------------------------------
	# 配置 vsftpd.conf
	#-----------------------------------------------------------------
	1、sudo vi /etc/vsftpd.conf
		1）添加：
			ssl_enable=YES
    			ssl_tlsv1=YES
    			ssl_sslv2=NO
    			ssl_sslv3=NO

		2）找到 rsa_cert_file=/etc/ssl/private/vsftpd.pem，注释掉，并添加：
			#rsa_cert_file=/etc/ssl/private/vsftpd.pem
			rsa_cert_file=/etc/ssl/certs/server.crt

			#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
			rsa_private_key_file=/etc/ssl/private/server.key

		3）增加以下内容：
			allow_anon_ssl=NO
    			force_local_data_ssl=YES
    			force_local_logins_ssl=YES

		4）增加以下内容：
			ssl_ciphers=HIGH
			pasv_min_port=40000
			pasv_max_port=50000
        		debug_ssl=YES

		5）保存/退出

	2、sudo service vsftpd restart

	#-----------------------------------------------------------------
	# 测试
	#-----------------------------------------------------------------
	1、安装使用tls协议进行ftp的“ftp客户端” filezilla（注意：原来安装的vsftp客户端是不能进行tls的连接的）
	sudo apt-get install filezilla

	2、使用 filezilla 对 “vsftp服务器” 进行连接


########################################################################################
# 第三部分：
#	配置 vsftpd tls 日志
########################################################################################

	不用特别配置，因为它的日志会记录到 “不使用tls” 的 vsftpd.log 中
















