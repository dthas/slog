#===========================================================================
# squid_log_setting.sh
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
# 创建squid用户 proxyt 
#-----------------------------------------------------------------
htpasswd  -c /etc/squid3/passwd proxyt


#-----------------------------------------------------------------
# 配置 squid
#-----------------------------------------------------------------

sudo vi /etc/squid3/squid.conf
	
	#注释以下几行：
	http_access deny !Safe_ports
	http_access deny CONNECT !SSL_ports
	http_access deny manager
	http_port 3128
	#添加：
	http_port 0.0.0.0:3130
	auth_param basic program /usr/lib/squid3/ncsa_auth /etc/squid3/passwd
	acl auth_user proxy_auth REQUIRED
	http_access allow auth_user

#-----------------------------------------------------------------
# 配置浏览器
#-----------------------------------------------------------------
#在firefox 的menu ,  Edit - > preference 的advanced -> network里面的connecting 按setting .设定proxy (http代理：0.0.0.0:3130)，配置完后，用以下命令重启 squit服务器（--full-restart）

sudo service squid3 --full-restart

#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置（权限：proxy.proxy）：
# 	/var/log/squid3/access.log
# 	/var/log/squid3/cache.log
#-----------------------------------------------------------------

1、sudo vi /etc/squid3/squid.conf
	找到 access_log /var/log/squid3/access.log squid，注释掉，改为 access_log /dita/log/squid3_access.log squid，即：
	#access_log /var/log/squid3/access.log squid
	access_log /dita/log/squid3_access.log squid	
	#access_log "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_squid3_access.log 86400 480" squid

2、sudo vi /etc/squid3/squid.conf
	找到 cache_log /var/log/squid3/cache.log 注释掉，改为 cache_log /dita/log/squid3_cache.log，即：
	#cache_log /var/log/squid3/cache.log
	cache_log /dita/log/squid3_cache.log
	#cache_log "| /usr/sbin/rotatelogs /dita/log/%Y_%m_%d_squid3_cache.log 86400 480"

