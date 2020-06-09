# This Praat script will split Intervals of One particular Phoneme into two Intervals using a replace list
# and save new TextGrids to a new path.
# 根据一个列表，将一些音素拆分成两个interval
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.06.09 feelins[feipengshao@163.com]

form Information
	comment Directory path of input files:
	text input_directory old_TextGrid/
	comment Path of map list file:
	text list_path split_list.txt
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_path new_TextGrid/
endform

if (praatVersion < 6100)
	printline Requires Praat version 6.1 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory:save_path$

Read Table from tab-separated file: list_path$
Rename: "TableList"
numOfTableRows = Get number of rows
for nt from 1 to numOfTableRows
	selectObject: "Table TableList"
	tableOld$['nt'] = Get value: nt, "old"
	tableNew$['nt'] = Get value: nt, "new"
endfor
selectObject: "Table TableList"
Remove

save_log$ = "log.txt"

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
        	for nt from 1 to numOfTableRows
			curOldContent$ = tableOld$['nt']
			curNewContent$ = tableNew$['nt']
			if intervalName$ = curOldContent$
				# split
				Set interval text: reference_tier, interval, ""
				split_mark = index(curNewContent$, "+")
				firstPart$ = left$(curNewContent$, split_mark - 1)
				secondPart$ = right$(curNewContent$, length(curNewContent$) - split_mark)
				splitTime = start + (end - start) / 2
				Insert boundary: 1, splitTime
				firstInterval = Get interval at time: 1, start
				Set interval text: reference_tier, firstInterval, firstPart$
				secondInterval = Get interval at time: 1, splitTime
				Set interval text: reference_tier, secondInterval, secondPart$
				appendFileLine: save_log$, fileName$, ",", interval, ",", curOldContent$, "->", curNewContent$
		    	endif
		endfor
		# update the intervalNums
		intervalNums = Get number of intervals: reference_tier
	endfor
	selectObject: "TextGrid " + objectName$
	Save as text file: save_path$ + fileName$
	Remove
endfor
select Strings fileList
Remove
exit Done!Thank you!-shaopf