# This Praat script will select one channel of two seperat channels' sound files in a given directory
# and save files to another directory.
# (See the Praat manual for details on Channels.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.08.20 feelins[feipengshao@163.com] 

form ReSample sound files
   comment Directory path of input files:
   text input_directory  wavs_2_channels/
   comment Directory path of output files:
   text output_directory  wavs_1_channel/
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
	View & Edit
	Convert to mono
	Save as WAV file: output_directory$ + objectName$  + ".wav"
	Remove
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!