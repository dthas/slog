#===========================================================================
# ssh_log_setting.sh
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
# 服务器日志配置
#-----------------------------------------------------------------
1、vi /etc/ssh/sshd_config
	将 SyslogFacility AUTH 改为SyslogFacility local5
2 vi /etc/rsyslog.conf
添加如下两行：
# save sshd messages also to sshd.log
local5.* /dita/log/sshd.log

3、重启sshd和syslog服务，然后你可以使用ssh来登录看看发现与sshd有关的信息都记录到了sshd.log中。不在是messages。
> sudo service ssh restart
> sudo restart rsyslog 

#-----------------------------------------------------------------
# 客户端的日志配置（即使用ssh登录服务器时，客户端的行为会记录在“客户端”）
#-----------------------------------------------------------------
在“客户端”机器上，修改 ssh 程序：
1、
sudo mv /usr/bin/ssh /usr/bin/ssh_ori

2、
1）
sudo touch /usr/bin/ssh

2）
sudo vi /usr/bin/ssh

添加：

#! /bin/sh 
 
mkdir -p ~/ssh_logs 
 
IP=$(echo $1 | grep -oP "((?:(?:25[0-5]|2[0-4]d|[01]?d?d).){3}(?:25[0-5]|2[0-4]d|[01]?d?d))") 
LOGNAME=${IP}_$(date +"%Y%m%d_%T") 
ssh_ori $@ | tee -a ~/ssh_logs/${LOGNAME}.log 

3）
chmod a+x /usr/bin/ssh







	
	


