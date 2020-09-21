#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   a02_stats_complex_infos.py
@Time    :   2020/09/21 19:48:56
@Author  :   shaopf 
@Version :   1.0
@Contact :   feipengshao@163.com
@License :   (C)Copyright 2019-2020
@Desc    :   stats some complex infos in TextGrids
'''

import textgrid as tg
import os

input_textgrid_dir = r'E:\006_TTS\biaobei\CMU_Demo'
save_result_file = r'E:\006_TTS\biaobei\CMU_Demo_complex.txt'

results = {}
for file_name in os.listdir(input_textgrid_dir):
    if file_name.find('.TextGrid') != -1:
        print(file_name)
        input_textgrid_file = os.path.join(input_textgrid_dir, file_name)
        ph_tiers = tg.read_textgrid(input_textgrid_file, 'phones')
        wd_tiers = tg.read_textgrid(input_textgrid_file, 'words')
        for wd_tier in wd_tiers:
            cur_word = wd_tier.name
            for punc in [',', '，', '。', '.']:
                cur_word = cur_word.replace(punc, '')
            cur_phons = []
            for ph_tier in ph_tiers:
                if ph_tier.start >= wd_tier.start and ph_tier.stop <= wd_tier.stop:
                    cur_phons.append(ph_tier.name)
            if cur_word not in results:
                results[cur_word] = [' '.join(cur_phons)]
            else:
                if ' '.join(cur_phons) not in results[cur_word]:
                    results[cur_word].append(' '.join(cur_phons))
with open(save_result_file, 'w', encoding='utf-8') as wid:
    wid.writelines([k + '\t' + str(v) + '\n' for k, v in results.items()])
print('Done!')

