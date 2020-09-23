#!/usr/bin/env python
# -*- encoding: utf-8 -*-
"""
@File    :   a03_select_files.py
@Time    :   2020-09-23 17:47
@Author  :   pfshao 
@Version :   1.0
@Contact :   feipengshao@163.com
@License :   (C)Copyright 2019-2020
@Desc    :   get selected files from a directory
"""

import os
import shutil

input_dir = r'E:\Biaobei_Demo'  # initial directory
output_dir = r'E:\Biaobei_Demo_select2'  # target directory

if not os.path.exists(output_dir):
    os.mkdir(output_dir)

input_select_file = r'E:\select_file_names.txt'  # select list file
with open(input_select_file, encoding='utf-8') as fid:
    select_list = [x.strip() for x in fid.readlines()]

for file_name in select_list:
    print(file_name)
    init_file = os.path.join(input_dir, file_name)
    target_file = os.path.join(output_dir, file_name)
    if os.path.exists(init_file):
        shutil.copy(init_file, target_file)
    else:
        print(file_name + ' is not exist.')
print('Done!')
