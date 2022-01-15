# This Praat script will change the format of all sound files in a given directory
# and save files with the new rate to another directory..
# 
# This script is distributed under the GNU General Public License.
# Copyright 2022.01.15 feelins[feipengshao@163.com] 

form ReSample sound files
   comment Directory path of input files:
   text input_directory  mp3s/
   comment Directory path of resampled files (old files will be overwritten!):
   text output_directory  wavs/
   sentence init_format .mp3
   sentence target_format .wav
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$
Create Strings as file list: "fileList", input_directory$ + "*" + init_format$
numberOfFiles = Get number of strings
for ifile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("Sound", 1)
	Save as WAV file: output_directory$ + objectName$  + target_format$
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!