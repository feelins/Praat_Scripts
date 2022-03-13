import os
import shutil

input_textgrid_dir = r'E:\Data_ArcticPhonetics\20220112_zi\outTextGrid_rename_hrz\outTextGrid_rename'
output_textgrid_dir = r'E:\Data_ArcticPhonetics\20220112_zi\outTextGrid_rename_hrz\outTextGrid_rename_20220112'

for file_name in os.listdir(input_textgrid_dir):
    print(file_name)
    # 1_1_3
    init_name = os.path.join(input_textgrid_dir, file_name)
    output_name = os.path.join(output_textgrid_dir, file_name.replace('_', '-'))
    shutil.copyfile(init_name, output_name)
print('done!')
