# This Praat script will split the input TXT file into files contains each line of txt
# 
# This script is distributed under the GNU General Public License.
# Copyright 2023.04.20 [feipengshao@163.com] 

form Information
   comment 需要拆分的文本路径:
   sentence input_txt input.txt
   comment 拆分后保存的目录(无需创建):
   sentence result_path output
   comment 是否有文件名:
   boolean hasFileName 1
endform

if (praatVersion < 6300)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Read Table from tab-separated file: input_txt$
createFolder: result_path$
rowNum = Get number of rows
order = 1
limit = 5
for row from 1 to rowNum
	if hasFileName
		curFileName$ = Get value: row, "filename"
	else
		# 
		temp = order
		ii = 0
		repeat
			temp = temp div 10
			ii = ii+1
		until temp = 0
		sumtemp = limit - ii
		mark$ = ""
		for jjj from 1 to sumtemp
			mark$ = mark$ + "0"
		endfor
		smark$ = mark$ + string$(order)
		curFileName$ = smark$
	endif
	curValue$ = Get value: row, "content"
	save_path$ = result_path$ + "\" + curFileName$ + ".txt"
	writeFileLine: save_path$, curValue$
	order = order + 1
endfor
selectObject: "Table input"
Remove
exit Done!