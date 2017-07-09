#===========================================================================
# pre_install.sh
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

#-----------------------------------------------------------------
# 第一步：创建dita用户及其用户组
#-----------------------------------------------------------------
#1、创建dita用户及其用户组（dita）
#sudo groupadd dita
#sudo useradd -m -s /bin/bash -g dita dita

#2、让用户dita成为sudoers（即以后使用 sudo 时不用输入密码）
#cd /etc/sudoers.d
#sudo touch dita
#
#sudo echo "dita ALL=(ALL) NOPASSWD: ALL" >> dita
#
#sudo chmod 440 dita

#-----------------------------------------------------------------
# 第二步：建立工作目录
#-----------------------------------------------------------------
#0、创建 /dita
sudo mkdir /dita
sudo chown dita.dita /dita

#1、进入实验区根目录（/dita）
# /dita = /dev/sda2
cd /dita

#2、在实验区根目录下创建各个工作目录
mkdir source build dest log

mkdir -p log/apache2
mkdir -p log/vsftp
mkdir -p log/squid3
mkdir -p log/nfs
mkdir -p log/iptables
mkdir -p log/samba
mkdir -p log/dns
mkdir -p log/dhcp
mkdir -p log/sendmail
mkdir -p log/postfix

mkdir -p dest/vsftp/upload
mkdir -p dest/vsftp/download

mkdir -p dest/nfs/share_files

#3、将实验区根目录下的所有目录的“所属用户”及“所属群组”都设置为 dita
sudo chown -R dita.dita /dita

sudo chown proxy.proxy -R /dita/log/squid3


