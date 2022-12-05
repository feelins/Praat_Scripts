# This Praat script will cut the silence in an utterance to a given value of wavs in a directory
# 切分句子中间停顿，使之在某个范围内
# 
# This script is distributed under the GNU General Public License.
# 博客说明：
# Copyright 2022.11.28 feelins[feipengshao@163.com]


form Dialogue_Cut
	comment Directory path of input WAV files：
	text input_wav_path input_wavs\
	comment Directory path of input TextGrid files:
	text input_textgrid_path -
	comment Do you have TextGrid files:
	boolean hasTextGrid 0
	comment If has TextGrid the silence mark:
	text silMark sp1
	comment Duration do you want to leave(second):
	real checkValue 0.6
	comment Directory path of ouput WAV files：
	text output_wav_path new_wavs\
	comment Directory path of output TextGrid files:
	text output_textgrid_path new_TextGrids\
endform

clearinfo
# 如果新目录不存在，自动创建
createDirectory: output_textgrid_path$
createDirectory: output_wav_path$

Create Strings as file list: "fileList", input_wav_path$ + "*.wav"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	simpleName$ = fileName$ - ".wav"
	writeInfoLine: simpleName$
	wavFullPath$ = input_wav_path$ + simpleName$ + ".wav"
	textGridFullPath$ = input_textgrid_path$ + simpleName$ + ".TextGrid"
	Read from file: wavFullPath$
	simpleNameNoBlank$ = selected$("Sound",1)
	if hasTextGrid
		Read from file: textGridFullPath$
	else
		selectObject: "Sound " + simpleNameNoBlank$
		To TextGrid (silences): 100, 0, -25, 0.1, 0.1, silMark$, "sounding"
	endif

	totalTime = Get total duration

	selectObject: "TextGrid " + simpleNameNoBlank$
	totalIntervals = Get number of intervals: 1
	for iInterval from 1 to totalIntervals
		selectObject: "TextGrid " + simpleNameNoBlank$
		curLabel$ = Get label of interval: 1, iInterval
		startTime = Get starting point: 1, iInterval
		endTime = Get end point: 1, iInterval
		durationB = endTime - startTime
		if curLabel$ = silMark$ and durationB > checkValue
			cutValue = checkValue / 2
			newStart = startTime + cutValue
			newEnd = endTime - cutValue
			selectObject: "Sound " + simpleNameNoBlank$
			Extract part: 0, newStart, "rectangular", 1, "no"
			selectObject: "Sound " + simpleNameNoBlank$ + "_part"
			Rename: "FIRST"
			selectObject: "TextGrid " + simpleNameNoBlank$
			Extract part: 0, newStart, "no"
			Rename: "FIRSTt"
			selectObject: "Sound " + simpleNameNoBlank$
			Extract part: newEnd, totalTime, "rectangular", 1, "no"
			selectObject: "Sound " + simpleNameNoBlank$ + "_part"
			Rename: "SECOND"
			selectObject: "TextGrid " + simpleNameNoBlank$
			Extract part: newEnd, totalTime, "no"
			Rename: "SECONDt"
			selectObject: "Sound FIRST"
			plusObject: "Sound SECOND"
			Concatenate
			#Save as WAV file: output_wav_path$ + simpleName$ + ".wav"
			selectObject: "TextGrid FIRSTt"
			plusObject: "TextGrid SECONDt"
			Concatenate
			select all
			minusObject: "Sound chain"
			minusObject: "TextGrid chain"
			minusObject: "Strings fileList"
			Remove
			selectObject: "Sound chain"
			Rename: simpleNameNoBlank$
			selectObject: "TextGrid chain"
			Rename: simpleNameNoBlank$
			
			#Save as text file: output_textgrid_path$ + simpleName$ + ".TextGrid"

			selectObject: "TextGrid " + simpleNameNoBlank$
			stotalIntervals = Get number of intervals: 1
			selectObject: "Sound " + simpleNameNoBlank$
			totalTime = Get total duration
		endif
	endfor

	selectObject: "TextGrid " + simpleNameNoBlank$
	totalIntervals = Get number of intervals: 1

	checkstr$ = simpleName$ + tab$
	# 检查第一个音素sil时长
	first$ = Get label of interval: 1, 1
	startTime = Get starting point: 1, 1
	endTime = Get end point: 1, 1
	durationB = endTime - startTime
	newStart = startTime
	if durationB > checkValue
		newStart = endTime - checkValue
		checkstr$ = checkstr$ + string$(durationB-checkValue) + tab$
	else
		checkstr$ = checkstr$ + string$(0) + tab$
	endif

	# 检查最后一个音素sil时长
	last$ = Get label of interval: 1, totalIntervals
	startTime = Get starting point: 1, totalIntervals
	endTime = Get end point: 1, totalIntervals
	durationE = endTime - startTime
	newEnd = endTime
	if durationE > checkValue
		newEnd = startTime + checkValue
		checkstr$ = checkstr$ + string$(durationE-checkValue) + tab$
	else
		checkstr$ = checkstr$ + string$(0) + tab$
	endif

	selectObject: "Sound " + simpleNameNoBlank$
	Extract part: newStart, newEnd, "rectangular", 1, "no"
	selectObject: "TextGrid " + simpleNameNoBlank$
	Extract part: newStart, newEnd, "no"

	selectObject: "Sound " + simpleNameNoBlank$ + "_part"
	Save as WAV file: output_wav_path$ + simpleName$ + ".wav"
	selectObject: "TextGrid " + simpleNameNoBlank$ + "_part"
	Save as text file: output_textgrid_path$ + simpleName$ + ".TextGrid"
	selectObject: "Sound " + simpleNameNoBlank$
	plusObject: "TextGrid " + simpleNameNoBlank$
	plusObject: "Sound " + simpleNameNoBlank$ + "_part"
	plusObject: "TextGrid " + simpleNameNoBlank$ + "_part"
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!


