# This Praat script will process add tier, remove tier, duplicate tier, set tier name of all TextGrid files 
# in a given directory and save new files to another directory.
# This operation can only be performed on one tier at a time.
# (See the Praat manual for details on modify tiers.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.04.17 feelins[feipengshao@163.com] 

form dialogue
	sentence input_directory old_TextGrid\
	sentence output_directory new_TextGrid\
endform

if (praatVersion < 6300)
	printline Requires Praat version 6.3 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$

Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("TextGrid", 1)

	Remove tier: 4
	Remove tier: 3

	Save as text file: output_directory$ + fileName$
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!
