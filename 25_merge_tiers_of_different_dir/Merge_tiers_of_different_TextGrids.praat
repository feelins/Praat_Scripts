# This Praat script will merge tiers of different TextGrid dirs, which tiers you can choose freely.
# and save new TextGrids to a new path.
# 合并不同目录里的TextGrid的需要的层级
# 
# This script is distributed under the GNU General Public License.
# Copyright 2021.05.20 feelins[feipengshao@163.com]

form Information
	comment Directory path of input files-1:
	text input_directory_1 oldTextGrid1
	comment Directory path of input files-2:
	text input_directory_2 oldTextGrid2
	comment Need list of tiers:
	text select_list 1-1,tom/2-1,emma/1-2,0/1-7,mike
	comment Path of output result file:
	text save_path new_TextGrid
endform

if (praatVersion < 6100)
	printline Requires Praat version 6.1 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory:save_path$

i = 1
while index(select_list$, "/") > 0
	curValue$=left$(select_list$, index(select_list$, "/") - 1)
	if curValue$!=""
		select_values$[i] = curValue$
		i = i + 1
	endif
	select_list$ = right$(select_list$, length(select_list$) - index(select_list$, "/"))
endwhile
select_values$[i] = select_list$


Create Strings as file list: "fileList", input_directory_1$ + "/*.TextGrid"
fileNum = Get number of strings
for file from 1 to fileNum
	selectObject: "Strings fileList"
	fileName$ = Get string: file
    
	input_textgrid_file_1$ = input_directory_1$+ "/" + fileName$
	input_textgrid_file_2$ = input_directory_2$+ "/" + fileName$
	#pause 'input_textgrid_file_2$'
	if fileReadable(input_textgrid_file_2$)
		# 1-1,tom
		#pause 'i'
		for ii from 1 to i
			select_value$ = select_values$[ii]
			#pause 'select_value$'
			select_file$ = left$(select_value$, 1)
			select_tier = number(mid$(select_value$, 3, 1))
			select_name$ = right$(select_value$, length(select_value$) - index(select_value$, ","))
			#pause 'select_file$', 'select_tier', 'select_name$'
			if select_file$ = "1"
				Read from file: input_textgrid_file_1$
				objectName$ = selected$ ("TextGrid", 1)
				totalTier = Get number of tiers
				if select_tier <= totalTier
					Extract one tier: select_tier
					if select_name$ <> "0"
						Set tier name: 1, select_name$
					endif
				endif
				selectObject: "TextGrid " + objectName$
				Remove
				#pause "1"
			elif select_file$ = "2"
				Read from file: input_textgrid_file_2$
				objectName$ = selected$ ("TextGrid", 1)
				totalTier = Get number of tiers
				if select_tier <= totalTier
					Extract one tier: select_tier
					if select_name$ <> "0"
						Set tier name: 1, select_name$
					endif
				endif
				selectObject: "TextGrid " + objectName$
				Remove
				#pause "2"
			else
				pause "only two files are supported!"
			endif
		endfor
		#pause
		select all
		minusObject: "Strings fileList"
		Merge
    		Save as text file: save_path$ + "/" + fileName$
		select all
		minusObject: "Strings fileList"
		Remove
	endif
endfor
selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf