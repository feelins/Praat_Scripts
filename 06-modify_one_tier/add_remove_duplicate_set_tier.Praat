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
	comment Do you want to add tier:
	boolean add_option 1
	choice select_type: 1
		option 1. interval tier
		option 2. point tier
	integer add_position 1
	sentence add_tier_name hello
	comment Do you want to remove tier:
	boolean remove_option 0
	integer remove_tier_num 1
	comment Do you want to duplicate tier:
	boolean copy_option 0
	integer tiernum 1
	integer position 2
	sentence target_tier_name nice
	comment Do you want to set tier names:
	boolean set_option 0
	integer tiernum 1
	sentence set_tier_name good
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
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

	# 是否有增加层操作
	if add_option
		if select_type = 1
			Insert interval tier: add_position, add_tier_name$
		endif
		if select_type = 2
			Insert point tier: add_position, add_tier_name$
		endif
	endif


	# 是否有移除层的操作
	if remove_option
		Remove tier: remove_tier_num
	endif

	# 复制层
	if copy_option
		Duplicate tier: tiernum, position, target_tier_name$
	endif

	# 设置某层的名称
	if set_option
		Set tier name: tiernum, set_tier_name$
	endif

	Save as text file: output_directory$ + fileName$
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!
