#===========================================================================
# server_install.sh
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
#apt-get install
#-----------------------------------------------------------------

sudo apt-get -y install apache2

sudo apt-get -y install vsftpd

sudo apt-get -y install squid

sudo apt-get -y install nfs-kernel-server

sudo apt-get -y install samba samba-common smbfs

sudo apt-get -y install bind9		# dns

sudo apt-get -y install isc-dhcp-server

sudo apt-get -y install sendmail mailutils

sudo apt-get install -y postfix

sudo apt-get install -y openssh-server



