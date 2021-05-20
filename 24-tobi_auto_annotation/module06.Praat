# This Praat script will process add tiers of all TextGrid files 
# in a given directory and save new files to another directory.
# (See the Praat manual for details on modify tiers.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.04.17 feelins[feipengshao@163.com] 


form dialogue
	sentence input_directory data/
	sentence output_directory data_out/
endform

createDirectory: output_directory$
Create Strings as file list: "fileList", input_directory$ + "/*.TextGrid"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	fileNameResult$ = fileName$ -".TextGrid" + "_result.TextGridd"
	Read from file: input_directory$ + fileName$
	simpleName$ = selected$("TextGrid", 1)
	Read from file: input_directory$ + fileNameResult$
	simpleNameResult$ = selected$("TextGrid", 1)
	selectObject: "TextGrid " + simpleName$
	Extract one tier: 1
	selectObject: "TextGrid " + simpleName$
	Extract one tier: 2
	selectObject: "TextGrid " + simpleNameResult$
	Extract one tier: 1
	selectObject: "TextGrid " + simpleNameResult$
	Extract one tier: 2

	selectObject: "TextGrid words"
	plusObject: "TextGrid phones"
	plusObject: "TextGrid tones"
	plusObject: "TextGrid breaks"
	Merge
	selectObject: "TextGrid merged"
	Write to text file: output_directory$ + "/" + fileName$
	selectObject: "TextGrid " + simpleName$
	plusObject:  "TextGrid " + simpleNameResult$
	plusObject: "TextGrid words"
	plusObject: "TextGrid phones"
	plusObject: "TextGrid tones"
	plusObject: "TextGrid breaks"
	plusObject: "TextGrid merged"
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!
