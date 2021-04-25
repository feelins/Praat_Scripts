# This Praat script will extract duration and intensity of One particular Tier based on the TextGrid file and sound file
# and save result to a TXT file.
# 提取某一层的Interval的时长及名称(空白标注忽略)，以及根据标注的时间段的音强的平均值, 需要提供标注TextGrid和sound
# 
# This script is distributed under the GNU General Public License.
# Copyright 2021.04.25 feelins[feipengshao@163.com]

form Information
	comment Directory path of input wav files:
	text input_wav_directory input_wav\
	comment Directory path of input TextGrid files:
	text input_directory input_TextGrid\
	comment Target Tier:
	positive reference_tier 2
	comment Path of output result file:
	text save_result result_duration_intensity.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

writeFileLine: save_result$, "fileName" + tab$ + "name" + tab$ + "duration" + tab$ + "intensity1" + tab$ + "intensity2" + tab$ + "intensity3" + tab$ + "intensity4" + tab$ + "intensity5" + tab$ + "intensity6" + tab$ + "intensity7" + tab$ + "intensity8" + tab$ + "intensity9" + tab$ + "intensity10" + tab$ + "meanIntensity"

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
	To Intensity: 100, 0, "yes"

	selectObject: "TextGrid " + objectName$
	numberOfIntervals = Get number of intervals: reference_tier
	for iInterval from 1 to numberOfIntervals
		selectObject: "TextGrid " + objectName$
		sTime = Get start point: reference_tier, iInterval
		eTime = Get end point: reference_tier, iInterval
		duration = eTime-sTime

		labelOfInterval$ = Get label of interval: reference_tier, iInterval  
		output$ = fileName$ + tab$ + labelOfInterval$ + tab$ + fixed$(duration, 3) + tab$

		stepTime = duration / 9
		for i from 1 to 10
			selectObject: "Intensity " + objectName$
			tmpTime = sTime + stepTime * (i - 1)
			#pause 'tmpTime'
			intensityValue = Get value at time: tmpTime, "cubic"
			output$ = output$ + fixed$(intensityValue, 0)
			if i <> 10
				output$ = output$ + tab$
			endif
		endfor
		meanValue = Get mean: sTime, eTime, "dB"
		output$ = output$ + tab$ + fixed$(meanValue, 3)
		appendFileLine: save_result$, output$
		endif
	endfor
	
	selectObject: "TextGrid " + objectName$
	Remove
	selectObject: "Sound " + objectName$
	Remove
	selectObject: "Intensity " + objectName$
	Remove
endfor

selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf