# This Praat script will extract duration and formant of One particular Tier based on the TextGrid file and sound file
# and save result to a TXT file.
# 提取某一层的Interval的时长及名称(空白标注忽略)，以及前3个共振峰的平均值, 需要提供标注TextGrid和sound
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.06.17 feelins[feipengshao@163.com]
# [result]:
# fileName	name	duration	F1	F2	F3
# 000001.TextGrid	sil	0.280	1058	2317	3145
# 000001.TextGrid	k	0.127	1202	2000	2792
# 000001.TextGrid	a2	0.110	998	1587	2535
# 000001.TextGrid	er2	0.098	620	1607	2334
# 000001.TextGrid	p	0.129	914	1850	2902

form Information
	comment Directory path of input wav files:
	text input_wav_directory /home/shaopf/test/wav/
	comment Directory path of input TextGrid files:
	text input_directory /home/shaopf/test/TextGrid/
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_result /home/shaopf/test/result_duration_formant.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

writeFileLine: save_result$, "fileName" + tab$ + "name" + tab$ + "duration" + tab$ + "F1" + tab$ + "F2" + tab$ + "F3"

Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings
for iFile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: iFile
	textGridFileName$ = input_directory$ + fileName$
	Read from file: textGridFileName$
	objectName$ = selected$ ("TextGrid", 1)
	wavFileName$ = input_wav_directory$ + objectName$ + ".wav"
	
	Read from file: wavFileName$
	To Formant (burg): 0, 5, 5500, 0.025, 50

	selectObject: "TextGrid " + objectName$
	numberOfIntervals = Get number of intervals: reference_tier
	for iInterval from 1 to numberOfIntervals
		selectObject: "TextGrid " + objectName$
		sTime = Get start point: reference_tier, iInterval
		eTime = Get end point: reference_tier, iInterval
		duration = eTime-sTime

		labelOfInterval$ = Get label of interval: reference_tier, iInterval
		output$ = fileName$ + tab$ + labelOfInterval$ + tab$ + fixed$(duration, 3) + tab$

		selectObject: "Formant " + objectName$
		formant1 = Get mean: 1, sTime, eTime, "hertz"
		output$ = output$ + fixed$(formant1, 0) + tab$
		formant2 = Get mean: 2, sTime, eTime, "hertz"
		output$ = output$ + fixed$(formant2, 0) + tab$
		formant3 = Get mean: 3, sTime, eTime, "hertz"
		output$ = output$ + fixed$(formant3, 0)
		appendFileLine: save_result$, output$
	endfor
	
	selectObject: "TextGrid " + objectName$
	Remove
	selectObject: "Sound " + objectName$
	Remove
	selectObject: "Formant " + objectName$
	Remove
endfor

selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf