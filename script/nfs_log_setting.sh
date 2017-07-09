#===========================================================================
# nfs_log_setting.sh
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
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/messages
#
#-----------------------------------------------------------------

1、ubuntu12.04缺省没有 /var/log/messages，要打开它：

sudo vi /etc/rsyslog.d/50-default.conf
	*.info;mail.none;authpriv.none;cron.none /var/log/messages	#新增

2、重启服务，以使 /var/log/messages 生效
sudo restart rsyslog 

3、注意，即使 /var/log/messages 生效了，但它仍然是空的，即nfs没日志记录，非常奇怪！

#-----------------------------------------------------------------
# 配置 nfs
#-----------------------------------------------------------------

1、
sudo vi /etc/exports

	#在文档的最后一行加入
	/dita/dest/nfs/share_files *(rw,sync,no_root_squash,no_subtree_check)

	#*：允许所有的网段访问，也可以使用具体的IP(101.102.103.*为同一网段内机器）
	#rw：挂接此目录的客户端对该共享目录具有读写权限
	#sync：资料同步写入内存和硬盘
	#no_root_squash：root用户具有对根目录的完全管理访问权限。
	#no_subtree_check：不检查父目录的权限。

#-----------------------------------------------------------------
# 客户端测试 
# 	服务器：101.102.103.100
#	客户端：101.102.103.104
#-----------------------------------------------------------------
在客户机上，

1、安装 nfs 客户端
sudo apt-get -y install nfs-common

2、mount/umount 服务器上的共享文件夹

sudo mount -t nfs 101.102.103.100:/dita/dest/nfs/share_files /mnt

sudo umount 101.102.103.100:/dita/dest/nfs/share_files /mnt




	
	


