#===========================================================================
# vsftp_log_setting.sh
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
# 配置 vsftp
#-----------------------------------------------------------------

1、设置 ftp
> sudo gedit /etc/vsftpd.conf

	#禁止匿名訪问
	anonymous_enable=NO
	#接受本地用户
	local_enable=YES
	#能够上传
	write_enable=YES
	#启用在chroot_list_file的用户仅仅能訪问根文件夹
	chroot_list_enable=YES
	chroot_list_file=/etc/vsftpd.chroot_list
	#新增
	allow_writeable_chroot=YES

2、新建ftp用户、组（ftpt, ftpgroup）
> sudo groupadd ftpgroup
> sudo useradd -g ftpgroup -d /dita/dest/vsftp/upload -M ftpt
> sudo passwd ftpt

3、编辑chroot_list文件，将ftpt用户增加当中：

> sudo gedit /etc/vsftpd.chroot_list
	添加ftpt


#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/vsftpd.log
#-----------------------------------------------------------------

1、sudo gedit /etc/vsftpd.conf

	以 xferlog 为关键字搜索 ，将里面的内容改为如下：
		xferlog_enable=YES				//不用改
		xferlog_file=/dita/log/xferlog		//改路径
		dual_log_enable=YES				//增加
		vsftpd_log_file=/dita/log/vsftpd.log	//增加
	
	
#-----------------------------------------------------------------
# 分析日志路径：
#-----------------------------------------------------------------
cat /dita/log/xferlog | awk '{print $1,$2,$3,$4,$5,$7,$9,$12,$14,$18}'

	################################################################################
	# 时间             	  ip	         文件        上传/下载  帐号    是否完成
	# $1-$5		  	  $7		 $9		$12	$14	$18
	################################################################################
	Wed Jun 21 17:47:03 2017 101.102.103.103 /vsftpd.log	o 	ftpt 	i
	Wed Jun 21 18:08:31 2017 101.102.103.103 /vsftpd.log	o 	ftpt 	i
	Wed Jun 21 18:09:32 2017 101.102.103.103 /vsftpd.log 	o 	ftpt 	c

