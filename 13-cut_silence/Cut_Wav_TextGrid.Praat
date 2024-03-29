# This Praat script will cut the initial and end silence to a given value of wavs and TextGrids in a directory
# 切分句子首、尾静音段
# 
# This script is distributed under the GNU General Public License.
# 博客说明：https://blog.csdn.net/shaopengfei/article/details/112252779
# Copyright 2020.04.22 feelins[feipengshao@163.com]
# 2021.04.28 update to relative path


form Dialogue_Cut
	comment Directory path of input WAV files：
	text input_wav_path old_wavs\
	comment Directory path of input TextGrid files:
	text input_textgrid_path -
	comment Do you have TextGrid files:
	boolean hasTextGrid 0
	comment Duration do you want to leave(second):
	real splitValue 0.1
	comment Directory path of ouput WAV files：
	text output_wav_path new_wavs\
	comment Directory path of output TextGrid files:
	text output_textgrid_path -
endform

clearinfo

# 如果新目录不存在，自动创建
if hasTextGrid
	createDirectory: output_textgrid_path$
endif
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
		To TextGrid (silences): 100, 0, -25, 0.1, 0.1, "sil", "sounding"
	endif
	
	
	selectObject: "TextGrid " + simpleNameNoBlank$
	totalIntervals = Get number of intervals: 1

	checkstr$ = simpleName$ + tab$
	# 检查第一个音素sil时长
	first$ = Get label of interval: 1, 1
	startTime = Get starting point: 1, 1
	endTime = Get end point: 1, 1
	durationB = endTime - startTime
	newStart = startTime
	if durationB > splitValue
		newStart = endTime - splitValue
		checkstr$ = checkstr$ + string$(durationB-splitValue) + tab$
	else
		checkstr$ = checkstr$ + string$(0) + tab$
	endif

	# 检查最后一个音素sil时长
	last$ = Get label of interval: 1, totalIntervals
	startTime = Get starting point: 1, totalIntervals
	endTime = Get end point: 1, totalIntervals
	durationE = endTime - startTime
	newEnd = endTime
	if durationE > splitValue
		newEnd = startTime + splitValue
		checkstr$ = checkstr$ + string$(durationE-splitValue) + tab$
	else
		checkstr$ = checkstr$ + string$(0) + tab$
	endif

	selectObject: "Sound " + simpleNameNoBlank$
	Extract part: newStart, newEnd, "rectangular", 1, "no"
	selectObject: "TextGrid " + simpleNameNoBlank$
	Extract part: newStart, newEnd, "no"

	selectObject: "Sound " + simpleNameNoBlank$ + "_part"
	Save as WAV file: output_wav_path$ + simpleName$ + ".wav"
	if hasTextGrid
		selectObject: "TextGrid " + simpleNameNoBlank$ + "_part"
		Save as text file: output_textgrid_path$ + simpleName$ + ".TextGrid"
	endif
	selectObject: "Sound " + simpleNameNoBlank$
	plusObject: "TextGrid " + simpleNameNoBlank$
	plusObject: "Sound " + simpleNameNoBlank$ + "_part"
	plusObject: "TextGrid " + simpleNameNoBlank$ + "_part"
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!


