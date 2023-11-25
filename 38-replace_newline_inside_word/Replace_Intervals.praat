# This Praat script will replace newline inside an Interval of One particular Tier using a replace list
# and save new TextGrids to a new path.
# 替换标注内容里的换行符
# 
# This script is distributed under the GNU General Public License.
# Copyright 2023.11.25 feelins[feipengshao@163.com]

form Information
	comment Directory path of input files:
	text input_directory old_TextGrid\
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_path new_TextGrid\
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory:save_path$

Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
fileNum = Get number of strings
for file from 1 to fileNum
	selectObject: "Strings fileList"
	fileName$ = Get string: file
	Read from file: input_directory$ + fileName$
	objectName$ = selected$ ("TextGrid", 1)
	intervalNums = Get number of intervals: reference_tier
	for interval from 1 to intervalNums
		selectObject: "TextGrid " + objectName$
		start = Get start time of interval: reference_tier, interval
		end = Get end time of interval: reference_tier, interval
		duration = end - start
		intervalName$ = Get label of interval: reference_tier, interval
		intervalName$ = replace_regex$(intervalName$, "\n", "", 0)
		Set interval text: reference_tier, interval, intervalName$
	endfor
	selectObject: "TextGrid " + objectName$
	Save as text file: save_path$ + fileName$
	Remove
endfor
select Strings fileList
Remove
exit Done!Thank you!-shaopf