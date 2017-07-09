#===========================================================================
# server_start.sh
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
#su - dita

#-----------------------------------------------------------------
# web服务器
#-----------------------------------------------------------------
sudo /etc/init.d/apache2 restart

#-----------------------------------------------------------------
# ftp服务器
#-----------------------------------------------------------------
sudo service vsftpd restart

#-----------------------------------------------------------------
# 代理服务器（proxy）
#-----------------------------------------------------------------
sudo service squid3 restart

#-----------------------------------------------------------------
# 网络文件服务器（nfs）
#-----------------------------------------------------------------
sudo /etc/init.d/portmap restart
sudo /etc/init.d/nfs-kernel-server restart

#-----------------------------------------------------------------
# smaba服务器
#-----------------------------------------------------------------
sudo /etc/init.d/smbd restart

#-----------------------------------------------------------------
# dns服务器
#-----------------------------------------------------------------
/etc/init.d/bind9 restart

#-----------------------------------------------------------------
# dhcp服务器
#-----------------------------------------------------------------
sudo service isc-dhcp-server restart

#-----------------------------------------------------------------
# 邮件服务器1（都可收发邮件）
#-----------------------------------------------------------------
sudo service sendmail restart

#-----------------------------------------------------------------
# 邮件服务器2（都可收发邮件）
#-----------------------------------------------------------------
sudo service postfix restart 

#-----------------------------------------------------------------
# ssh
#-----------------------------------------------------------------
sudo service ssh restart
