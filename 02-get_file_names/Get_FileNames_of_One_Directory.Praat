# This Praat script will get all file names with given file extension in a given directory
# and save to result text.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.15 feelins[feipengshao@163.com] 

form Information
   sentence file_extension .png
   comment Directory path of input files:
   text input_directory images\
   comment Result path:
   text result_path file_names_images.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Create Strings as file list: "fileList", input_directory$ + "*" + file_extension$
Save as raw text file: result_path$
selectObject: "Strings fileList"
Remove
exit Done!