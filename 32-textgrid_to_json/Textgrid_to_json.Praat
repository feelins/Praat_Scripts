# This Praat script will change the format of all TextGrid files in a given directory
# and save files with the json format.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2022.03.13 feelins[feipengshao@163.com] 

form ReSample sound files
   	comment Directory path of input files:
   	text input_directory  textgrids/
   	comment Directory path of output files:
	text output_directory  jsons/
	positive decimalNum 3
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$
Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings
for ifile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("TextGrid", 1)
	jsonFile$ = output_directory$ + objectName$ + ".json"
	deleteFile: jsonFile$
	numberOfIntervals = Get number of intervals: 1
	appendFileLine: jsonFile$, "{"
	appendFileLine: jsonFile$, tab$ + """tiers"":["
	totalTierNum = Get number of tiers
	for iTier from 1 to totalTierNum
		tierName$ = Get tier name: iTier
		appendFileLine: jsonFile$, tab$ + tab$ + "{""name"":""" + tierName$ + ""","
		appendFileLine: jsonFile$, tab$ + tab$ + """intervals"":["
		for iInterval from 1 to numberOfIntervals
			selectObject: "TextGrid " + objectName$
			sTime = Get start point: 1, iInterval
			eTime = Get end point: 1, iInterval

			labelOfInterval$ = Get label of interval: 1, iInterval
			output$ = "{""xmin"":" + fixed$(sTime, decimalNum) + ",""xmax"":" + fixed$(eTime, decimalNum) + ",""text"":""" + labelOfInterval$ + """}"
			if iInterval <> numberOfIntervals
				output$ = output$ + ","
			endif
			appendFileLine: jsonFile$, tab$ + tab$ + tab$ + output$
		endfor
		tmpEndMark$ = "]}"
		if iTier <> totalTierNum
			tmpEndMark$ = tmpEndMark$ + ","
		endif
		appendFileLine: jsonFile$, tab$ + tab$ + tmpEndMark$
	endfor
	appendFileLine: jsonFile$, tab$ + "]"
	appendFileLine: jsonFile$, "}"
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!