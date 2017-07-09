#===========================================================================
# install.sh
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

# （手动）su - dita


#=====================================================================================================
# 安装前
#=====================================================================================================

cd /media/sf_install_disk_log/script/
source pre_install.sh &> ../log/log_1.txt


#=====================================================================================================
# 安装过程（需要是dita用户，即 su - dita）
#=====================================================================================================

#--------------------------------------------------------------------
# 1、构建工具链
#--------------------------------------------------------------------
cd /media/sf_install_disk_log/script/
source server_install.sh &> ../log/log_2.txt








