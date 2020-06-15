# This Praat script will change the peak of all sound files in a given directory
# and save files with the new peak to another directory.
# (See the Praat manual for details on peak.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.06.15 feelins[feipengshao@163.com] 

form Adjust Peak sound files
   comment Directory path of input files:
   text input_directory  old_wavs/
   comment Directory path of adjust files:
   text output_directory  new_wavs/
   positive new_peak 0.99
endform

if (praatVersion < 6100)
	printline Requires Praat version 6.1 or higher. Please upgrade your Praat version 
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
	Scale peak: new_peak
	Save as WAV file: output_directory$ + objectName$  + ".wav"
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!