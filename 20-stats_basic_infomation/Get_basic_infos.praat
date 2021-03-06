# This Praat script will extract some basic infomation of several particular Tier based on the TextGrid file
# and save result to a TXT file.
# 统计基本的层信息，需要提供标注TextGrid
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.08.26 feelins[feipengshao@163.com]


form Information
	comment Directory path of input files:
	text input_directory E:\Biaobei_Demo\
	comment Target Tier:
	positive target_tier 1
	comment Path of output result file:
	text save_result E:\Biaobei_Demo_stats.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Create Table with column names: "table", 1, "item count"
Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
fileNumber = Get number of strings
for file from 1 to fileNumber
	selectObject: "Strings fileList"
	fileName$ = Get string: file
	Read from file: input_directory$ + fileName$
	objectName$ = selected$ ("TextGrid", 1)
	writeInfoLine: objectName$
	isInterval = Is interval tier: target_tier
	if isInterval
		iterNums = Get number of intervals: target_tier
	else
		iterNums = Get number of points: target_tier
	endif
	for i from 1 to iterNums
		selectObject: "TextGrid " + objectName$
		if isInterval
			lab$ = Get label of interval: target_tier, i
		else
			lab$ = Get label of point: target_tier, i
		endif
		lab$ = replace$(lab$, "1", "", 0)
		lab$ = replace$(lab$, "2", "", 0)
		lab$ = replace$(lab$, "3", "", 0)
		lab$ = replace$(lab$, "4", "", 0)
		lab$ = replace$(lab$, "5", "", 0)
		

		selectObject: "Table table"
		totalRow = Get number of rows
		exists = 0
		for j from 1 to totalRow
			name$ = Get value: j, "item"
			if name$ = lab$
				exists = j
			endif
		endfor
		if exists
			totalRow = Get number of rows
			for j from 1 to totalRow
				name$ = Get value: j, "item"
				if name$ = lab$
					curCount = Get value: j, "count"
					Set numeric value: j, "count", curCount + 1
				endif
			endfor
		else
			curRow = Get number of rows
			Set string value: curRow, "item", lab$
			Set numeric value: curRow, "count", 1
			Append row
		endif
	endfor
	
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Table table"
Save as tab-separated file: save_result$
Remove
selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf