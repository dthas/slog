#===========================================================================
# smb_log_setting.sh
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
# 配置smb
#-----------------------------------------------------------------
1、设置共享目录
sudo mkdir -p /home/test/smbshare
sudo chmod 777 /home/test/smbshare

2、增加smb帐号
sudo groupadd smbu
sudo useradd -m -s /bin/bash -g smbu smbu

sudo touch /etc/samba/smbpasswd
sudo smbpasswd -a smbu

3、配置文件smb.conf
sudo gedit /etc/samba/smb.conf
修改：
	找到security = user，去注释（如果没找到，则新增这句）

新增：
[share]
      path = /home/test/smbshare
      available = yes
      browsealbe = yes
      public = yes
      writable = yes
      valid users = smbu
      create mask = 0700
      directory mask =0700
      force user =nobody
      force group = nogroup

4、重启smb服务
sudo service smbd restart

#-----------------------------------------------------------------
# 测试smb
# 客户机：101.102.103.104（要安装 sudo apt-get -y install samba-common smbfs）
#-----------------------------------------------------------------
mkdir -p /home/test/smbtest
sudo mount //101.102.103.100/share /home/test/smbtest -o username="smbu"



#退出测试
sudo umount //101.102.103.100/share /home/test/smbtest

#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/samba/
#	里面主要是log.smbd这个日志，但内容都是比较简单的（smb何时启动等的信息），
#	真正详细的需要使用下面strace的方式
#-----------------------------------------------------------------

sudo gedit /etc/samba/smb.conf
	找到 log file = /var/log/samba/log.%m，改为：log file = /dita/log/samba_log.%m，即：
	#log file = /var/log/samba/log.%m
	log file = /dita/log/samba_log.%m



#-----------------------------------------------------------------
# 追踪“谁”通过smb修改里服务器上的文件：
#
# 服务器：101.102.103.100
# 客户机：101.102.103.104
#
#-----------------------------------------------------------------
1、客户机连接服务器：
sudo mount '//101.102.103.100/share' /home/test/smbtest -o username="smbu"

2、服务器查看“谁”使用smb连接上了服务器，并追踪该进程
1）ps -ef | grep smb

	root      4830     1  0 14:44 ?        00:00:00 smbd -F
	root      4831  4830  0 14:44 ?        00:00:00 smbd -F
	root      4838  4830  0 14:47 ?        00:00:00 smbd -F
	root      4878  2486  0 14:54 pts/2    00:00:00 grep --color=auto smb

2）strace -e trace=file -p 4838
	目前输出是空的（要等到客户机“有动作”这里才有输出）

3、客户机修改服务器上的文件
echo "bbb" >> aaa.txt

4、服务器上马上会显示客户机进程修改了服务器上的文件：
strace -e trace=file -p 4838
	（鉴于客户机已有动作（修改服务器文件），则输出如下：）
	Process 4838 attached - interrupt to quit
	lstat("aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	getcwd("/home/test/smbshare", 4096)     = 20
	lstat("/home/test/smbshare/aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	lstat("aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	lstat("aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	getcwd("/home/test/smbshare", 4096)     = 20
	lstat("/home/test/smbshare/aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	lstat("aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	stat(".", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
	stat("/home/test/smbshare", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
	getcwd("/home/test/smbshare", 4096)     = 20
	lstat("/home/test/smbshare/aaa.txt", {st_mode=S_IFREG|0777, st_size=10, ...}) = 0
	open("aaa.txt", O_WRONLY|O_CREAT|O_NOFOLLOW, 0755) = 30
	stat("", 0x7fff56bf6830)                = -1 ENOENT (No such file or directory)
	open("/var/log/samba/log.", O_WRONLY|O_CREAT|O_APPEND, 0644) = 30
	stat("/etc/samba/smb.conf", {st_mode=S_IFREG|0644, st_size=12738, ...}) = 0
	--- SIGUSR1 (User defined signal 1) @ 0 (0) ---
	stat("", 0x7fff56bf6830)                = -1 ENOENT (No such file or directory)
	open("/var/log/samba/log.", O_WRONLY|O_CREAT|O_APPEND, 0644) = 31
	stat("/etc/samba/smb.conf", {st_mode=S_IFREG|0644, st_size=12738, ...}) = 0






