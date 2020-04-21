# This Praat script will extract total duration of all sound files in a given directory
# and save result to a TXT file.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.26 feelins[feipengshao@163.com]
# 2019.06.13 set the sample dir 
# e.g.
# [dir]-----wav
# -------------+----0001.wav
# -------------+----0002.wav
#
# results:
# -------------------0001.wav,2.66
# -------------------0002.wav,2.86
# -------------------total: 5.52

form dialogue
	comment Directory path of input files:
	sentence input_directory E:\003_ProgramLanguage\Praat_Scripts\01-resample_sound_files\wavs_48k\
	comment Path of output result file:
	sentence save_result E:\003_ProgramLanguage\Praat_Scripts\07-compute_total_duration\duration_result.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Create Strings as file list: "fileList", input_directory$ + "*.wav"
fileNumber = Get number of strings
total_duration = 0.0
for i from 1 to fileNumber
	selectObject: "Strings fileList"
	fileName$ = Get string: i
	Read from file: input_directory$ + fileName$
	objectName$ = selected$ ("Sound", 1)
	duraTotal = Get total duration
	total_duration = total_duration + duraTotal
	appendFileLine: save_result$, fileName$, ",", duraTotal
	selectObject: "Sound " + objectName$
	Remove
endfor
appendFileLine: save_result$, "Total", ": ", total_duration
selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf

