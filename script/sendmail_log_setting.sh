#===========================================================================
# sendmail_log_setting.sh
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
# 配置sendmail
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

2、设置这个服务器的侦听范围
1）
sudo vi /etc/mail/sendmail.mc
	将Addr=127.0.0.1改为Addr=0.0.0.0 意为全域范围内，即：
		找到并删除：
			DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=127.0.0.1')dnl
			DAEMON_OPTIONS(`Family=inet,  Name=MSP-v4, Port=submission, M=Ea, Addr=127.0.0.1')dnl
		
		新增：
			DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=0.0.0.0')dnl
			DAEMON_OPTIONS(`Family=inet,  Name=MSP-v4, Port=submission, M=Ea, Addr=0.0.0.0')dnl
	
2）使生效
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf


3、重启 sendmail服务
sudo service sendmail restart

#-----------------------------------------------------------------
# 修改日志路径：
#
# 日志缺省位置：
# 	/var/log/mail.log
#-----------------------------------------------------------------

sudo vi /etc/rsyslog.d/50-default.conf
	#mail.*                         -/var/log/mail.log
	mail.*                          -/dita/log/sendmail.log

sudo restart rsyslog 

#-----------------------------------------------------------------
# 测试sendmail
#-----------------------------------------------------------------

echo bbb | mail -s test wlaqtest11@126.com

查看 /dita/log/sendmail/mail.log：

2017-06-26T10:28:29.672151+08:00 test sendmail[5882]: v5Q2STJ7005882: from=root, size=79, class=0, nrcpts=1, msgid=<201706260228.v5Q2STJ7005882@test.com>, relay=root@localhost
2017-06-26T10:28:29.743665+08:00 test sm-mta[5884]: v5Q2ST8k005884: from=<root@test.com>, size=315, class=0, nrcpts=1, msgid=<201706260228.v5Q2STJ7005882@test.com>, proto=ESMTP, daemon=MTA-v4, relay=localhost [127.0.0.1]
2017-06-26T10:28:29.761910+08:00 test sendmail[5882]: v5Q2STJ7005882: to=<wlaqtest11@126.com>, ctladdr=root (0/0), delay=00:00:00, xdelay=00:00:00, mailer=relay, pri=30079, relay=[127.0.0.1] [127.0.0.1], dsn=2.0.0, stat=Sent (v5Q2ST8k005884 Message accepted for delivery)
2017-06-26T10:28:31.400761+08:00 test sm-mta[5886]: STARTTLS=client, relay=126mx02.mxmail.netease.com., version=TLSv1/SSLv3, verify=FAIL, cipher=AES256-SHA, bits=256/256
2017-06-26T10:28:32.383539+08:00 test sm-mta[5886]: v5Q2ST8k005884: to=<wlaqtest11@126.com>, ctladdr=<root@test.com> (0/0), delay=00:00:03, xdelay=00:00:03, mailer=esmtp, pri=120315, relay=126mx02.mxmail.netease.com. [220.181.15.155], dsn=2.0.0, stat=Sent (Mail OK queued as mx38,1MmowADXh59OcVBZ8SNFEw--.15435S3 1498444112)


