#===========================================================================
# apache2_log_setting.sh
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

#-----------------------------------------------------------------
# 配置 apache2
#-----------------------------------------------------------------

sudo chmod 666 /etc/apache2/httpd.conf
sudo echo "slab localhost:80" >> /etc/apache2/httpd.conf
sudo chmod 644 /etc/apache2/httpd.conf

#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/apache2/access_log
# 	/var/log/apache2/error_log
#-----------------------------------------------------------------

1、vi /etc/apache2/apache2.conf

	找到 ErrorLog ${APACHE_LOG_DIR}/error.log，注释掉，改为 ErrorLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_error_log 86400 480"，即：
	#ErrorLog ${APACHE_LOG_DIR}/error.log
	#ErrorLog /dita/log/apache2/error.log
	ErrorLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_error_log 86400 480"
	
	

2、vi /etc/apache2/sites-enabled/000-default
	找到 CustomLog ${APACHE_LOG_DIR}/access.log combined 注释掉，改为 CustomLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_access_log 86400 480" common，即：
	#CustomLog ${APACHE_LOG_DIR}/access.log combined
	#CustomLog /dita/log/apache2/access.log combined
	CustomLog "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_apache2_access_log 86400 480" common


