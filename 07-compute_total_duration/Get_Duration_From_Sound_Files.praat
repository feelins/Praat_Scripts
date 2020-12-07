# This Praat script will stats total duration of all sound files or TextGrid files in a given directory
# and save result to a TXT file.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.12.06 feelins[feipengshao@163.com]
# 2020.12.06 set the sample dir 
# e.g.
# [dir]-----wav
# -------------+----0001.wav
# -------------+----0001.TextGrid
# -------------+----0002.wav
# -------------+----0002.TextGrid
#
# results:
# -------------------0001.wav,2.66
# -------------------0002.wav,2.86
# -------------------0001.TextGrid,2.66
# -------------------0002.TextGrid,2.86
# -------------------total: 5.52

form dialogue
	comment Directory path of input wav files:
	sentence input_wav_directory wavs/
	comment Directory path of input TextGrid files:
	sentence input_textgrid_directory TextGrids/
	comment Path of output result file:
	sentence save_result duration_result.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif
deleteFile: save_result$
if input_wav_directory$ <> ""
	Create Strings as file list: "fileList", input_wav_directory$ + "*.wav"
	fileNumber = Get number of strings
	total_duration = 0.0
	for i from 1 to fileNumber
		selectObject: "Strings fileList"
		fileName$ = Get string: i
		Read from file: input_wav_directory$ + fileName$
		objectName$ = selected$ ("Sound", 1)
		duraTotal = Get total duration
		total_duration = total_duration + duraTotal
		appendFileLine: save_result$, fileName$, ",", duraTotal
		selectObject: "Sound " + objectName$
		Remove
	endfor
	appendFileLine: save_result$, "Total wavs", ": ", total_duration
	selectObject: "Strings fileList"
	Remove
endif
appendFileLine: save_result$, "  "
if input_textgrid_directory$ <> ""
	Create Strings as file list: "fileList", input_textgrid_directory$ + "*.TextGrid"
	fileNumber = Get number of strings
	total_duration = 0.0
	for i from 1 to fileNumber
		selectObject: "Strings fileList"
		fileName$ = Get string: i
		Read from file: input_textgrid_directory$ + fileName$
		objectName$ = selected$ ("TextGrid", 1)
	
		# duraTotal = Get total duration
		duraTotal = Get total duration of intervals where: 1, "is not equal to", ""

		total_duration = total_duration + duraTotal
		appendFileLine: save_result$, fileName$, ",", duraTotal
		selectObject: "TextGrid " + objectName$
		Remove
	endfor
	appendFileLine: save_result$, "Total TextGrids", ": ", total_duration
	selectObject: "Strings fileList"
	Remove
endif
exit Done!Thank you!-shaopf

