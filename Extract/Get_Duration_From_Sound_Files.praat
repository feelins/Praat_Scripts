# This Praat script will extract total duration of all sound files in a given directory
# and save result to a TXT file.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.26 feelins[feipengshao@163.com]
# 2019.06.13 set the sample dir 

form dialogue
	comment Directory path of input files:
	sentence input_directory /home/shaopf/test/wav/
	comment Path of output result file:
	sentence save_result /home/shaopf/test/duration_result.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Create Strings as file list: "fileList", input_directory$ + "*.wav"
fileNumber = Get number of strings
for i from 1 to fileNumber
	selectObject: "Strings fileList"
	fileName$ = Get string: i
	Read from file: input_directory$ + fileName$
	objectName$ = selected$ ("Sound", 1)
	duraTotal = Get total duration
	appendFileLine: save_result$, fileName$, ",", duraTotal
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf

