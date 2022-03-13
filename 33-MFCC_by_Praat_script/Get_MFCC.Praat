# This Praat script will get the MFCC coefficients from sound files.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2022.03.13 feelins[feipengshao@163.com] 

form info
   comment Directory path of input files:
   text input_directory  wavs\
   comment Directory path of MFCC files:
   text output_directory  MFCC\
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$
Create Strings as file list: "fileList", input_directory$ + "*.wav"
numberOfFiles = Get number of strings
for ifile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("Sound", 1)
	To MFCC: 12, 0.015, 0.005, 100, 100, 0
	Save as text file: output_directory$ + objectName$  + ".MFCC"
	selectObject: "MFCC " + objectName$
	Remove
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!