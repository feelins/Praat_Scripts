# This Praat script will extract the tier content from TextGrid with only one Tier.
# 从一层TextGrid提取内容
# 
# This script is distributed under the GNU General Public License.
# 博客说明：
# Copyright 2021.09.24 feelins[feipengshao@163.com]



form Dialogue_ExtractTextGrid
	comment Directory path of input TextGrid files：
	text input_textgrid_path outTextGrids\
	comment Path of output Txt file:
	text output_text_path txt_list_checked.txt
endform

clearinfo

deleteFile: output_text_path$
appendFileLine: output_text_path$, "文件名", tab$, "校对后内容"
Create Strings as file list: "fileList", input_textgrid_path$ + "*.TextGrid"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	textgridFullPath$ = input_textgrid_path$ + fileName$
	Read from file: textgridFullPath$
	simpleName$ = selected$("TextGrid",1)
	writeInfoLine: simpleName$
	sent$ = Get label of interval: 1, 1
	appendFileLine: output_text_path$, simpleName$, tab$, sent$
	selectObject: "TextGrid " + simpleName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!


