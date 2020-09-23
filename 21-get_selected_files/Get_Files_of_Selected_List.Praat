# This Praat script will get selected files to an output directory from a given directory
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.09.23 feelins[feipengshao@163.com] 

form Information
	comment Directory path of input files:
	text input_directory E:\Biaobei_Demo\
	comment Selected list file:
	text select_file E:\select_file_names.txt
	comment Result path:
	text output_directory E:\Biaobei_Demo_select\
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$

Read Strings from raw text file: select_file$
fileNum = Get number of strings
for ifile from 1 to fileNum
	#selectObject: "Strings " + select_file_names"
	fileName$ = Get string: ifile
	filePath$ = input_directory$ + "\" + fileName$
	if fileReadable(filePath$)
		targetPath$ = output_directory$ + "\" + fileName$
		if index(fileName$, ".") = 0
			runSystem: "copy ", filePath$ + ".*" + " ", targetPath$
		else
			runSystem: "copy ", filePath$ + " ", targetPath$
		endif
	else
		writeInfoLine: filePath$ + " is not exist."
	endif
endfor
exit Done!
