#===========================================================================
# iptables_log_setting.sh
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
# 	/var/log/ptables.log
#
#-----------------------------------------------------------------

1、ubuntu12.04缺省没有 /dita/log/iptables/iptables.log：

#sudo vi /etc/rsyslog.conf
sudo vi /etc/rsyslog.d/50-default.conf
	kern.warning	/dita/log/iptables.log	#新增

2、重启服务，以使生效
sudo /etc/init.d/rsyslog restart 

3、测试iptables日志
iptables -A INPUT -j LOG



