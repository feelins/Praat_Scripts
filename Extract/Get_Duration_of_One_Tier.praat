# This Praat script will extract duration of One particular Tier based on the TextGrid file
# and save result to a TXT file.
# 提取某一层的Interval的时长及名称(空白标注忽略), 需要提供标注TextGrid
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.26 feelins[feipengshao@163.com]
# e.g.
# [dir]-----TextGrid
# -------------+----0001.TextGrid
# -------------+----0002.TextGrid
#
# results:
# 
# fileName,IntervalName,duration
# 0001.TextGrid,sil,0.27958612055419324
# 0001.TextGrid,k,0.12670506851255176
# 0002.TextGrid,a2,0.11022310838083771

form Information
	comment Directory path of input files:
	text input_directory /home/shaopf/test/TextGrid/
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_result /home/shaopf/test/result_duration_tier.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

writeFileLine: save_result$, "fileName", ",", "IntervalName", ",", "duration"
Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
fileNumber = Get number of strings
for file from 1 to fileNumber
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
		if intervalName$ <> ""
			appendFileLine: save_result$, fileName$, ",", intervalName$, ",", duration
		endif
	endfor
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf