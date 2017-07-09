#===========================================================================
# postfix_log_setting.sh
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
# 配置postfix
#-----------------------------------------------------------------

1、设置收信人的域名
1）
sudo vi /etc/mail/local-host-names
	将 test 修改为 test.com

2）因为修改了local-host-names，因此要同步修改 /etc/hosts
sudo vi /etc/hosts
	将 127.0.1.1       test 改为 127.0.1.1       test.com。即：
		#127.0.1.1       test
		127.0.1.1       test.com

3）因为修改了local-host-names，因此要同步修改 /etc/hostname
sudo vi /etc/hostname
	将 test 改为 test.com

#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/mail.log
#-----------------------------------------------------------------

sudo vi /etc/rsyslog.d/50-default.conf
	#mail.*                         -/var/log/mail.log
	mail.*                          -/dita/log/postfix_mail.log

sudo restart rsyslog 

#-----------------------------------------------------------------
# 测试postfix
#-----------------------------------------------------------------

echo mmm | mail -s test wlaqtest11@126.com

查看 /dita/log/sendmail/mail.log：

2017-06-26T10:37:00.130803+08:00 test postfix/master[7612]: daemon started -- version 2.9.6, configuration /etc/postfix
2017-06-26T10:37:40.492786+08:00 test postfix/smtpd[7655]: connect from localhost[127.0.0.1]
2017-06-26T10:39:18.793492+08:00 test postfix/pickup[7615]: C1A1B10475E: uid=0 from=<root>
2017-06-26T10:39:18.802752+08:00 test postfix/cleanup[7700]: C1A1B10475E: message-id=<20170626023918.C1A1B10475E@test.com>
2017-06-26T10:39:18.836455+08:00 test postfix/qmgr[7616]: C1A1B10475E: from=<root@test.com>, size=312, nrcpt=1 (queue active)
2017-06-26T10:39:20.826318+08:00 test postfix/smtp[7702]: C1A1B10475E: to=<wlaqtest11@126.com>, relay=126mx01.mxmail.netease.com[220.181.15.142]:25, delay=2.1, delays=0.07/0.01/1.7/0.31, dsn=2.0.0, status=sent (250 Mail OK queued as mx24,KsmowAAXjy_Xc1BZ8HYWFg--.41679S2 1498444760)
2017-06-26T10:39:20.826397+08:00 test postfix/qmgr[7616]: C1A1B10475E: removed
