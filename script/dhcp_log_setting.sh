#===========================================================================
# dhcp_log_setting.sh
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
# 配置dhcp
#-----------------------------------------------------------------

1、
sudo vi /etc/default/isc-dhcp-server

填入eth0，即：
	INTERFACES="eth0"

2、
sudo vi /etc/dhcp/dhcpd.conf

1）修改：
	原来的：
		# option definitions common to all supported networks...
		option domain-name "example.org";
		option domain-name-servers ns1.example.org, ns2.example.org;

		default-lease-time 600;
		max-lease-time 7200;
	修改后：
		# option definitions common to all supported networks...                                                                                       
		option domain-name "test.cn";  
		option domain-name-servers dhcp.test.cn, namenode1.test.cn, namenode2.test.cn, datanode1.test.cn, datanode2.test.cn, 		datanode3.test.cn, datanode4.test.cn, datanode5.test.cn, datanode6.test.cn;

		default-lease-time 6000;                                                                                                            
		max-lease-time 72000;  

2）新增：
    option routers 101.102.103.11;  
    subnet 101.102.103.0 netmask 255.255.255.0 {  
           range 101.102.103.50 101.102.103.60;  
           option domain-name-servers 101.102.103.11;  
           option broadcast-address 101.102.103.255;  
    }  

#-----------------------------------------------------------------
# 修改日志路径：
#-----------------------------------------------------------------

1、创建 dhcp.log
touch /dita/log/dhcp/dhcp.log
chmod 640 /dita/log/dhcp/dhcp.log

2、
sudo vi /etc/dhcp/dhcpd.conf

新增：
	log-facility local4;

3、
sudo vi /etc/rsyslog.conf
新增：
	local4.*	/dita/log/dhcp.log

修改：
	注释这句：$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat，即：
	#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

修改：
	#*.info;mail.none;authpriv.none;cron.none /var/log/messages
	*.info;mail.none;authpriv.none;cron.none;local4.none /var/log/messages

5、
sudo service rsyslog restart
sudo service isc-dhcp-server restart
