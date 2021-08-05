# This Praat script will merge all the sound files in a selected 
# directory and concatenates them into a single sound file.
# 
# 
# This script is distributed under the GNU General Public License.
# Copyright 2021.08.03 feelins[feipengshao@163.com]


form Concatenate sound files
	comment Directory of input sound files
	text Sound_directory input_data/
	choice select_merge_option: 1
		button merge whole directory
		button merge specific filenames
	word specific_marks specific_list.txt
endform

if select_merge_option = 2
	if specific_marks$ = "" or not fileReadable(specific_marks$)
		exit " Please set a valid specific mark File!!!  "
	endif
	Read Strings from raw text file: specific_marks$
	totalLines = Get number of strings
	curName$ = selected$("Strings", 1)
	for istring from 1 to totalLines
		txt$[istring] = Get string: istring
	endfor
	#select Strings curName$
	Remove
endif

Create Strings as directory list: "directoryList", sound_directory$ + "/*"

numberOfDirs = Get number of strings

for idir to numberOfDirs
	select Strings directoryList
	dirname$ = Get string: idir
	Create Strings as file list: "fileList", sound_directory$ + "/" + dirname$ + "/*.wav"
	numberOfFiles = Get number of strings
	# first option
	if select_merge_option = 1
		for ifile to numberOfFiles
			select Strings fileList
			filename$ = Get string: ifile
			Read from file: sound_directory$ + "/" + dirname$ + "/" + filename$
		endfor
		select all
		minus Strings fileList
		minus Strings directoryList
		Concatenate
		save_file$ = sound_directory$ + "/" + dirname$ + ".wav"
		Save as WAV file: save_file$
	endif
	
	# second option
	if select_merge_option = 2
		for txtIndex from 1 to totalLines
			curTxt$ = txt$[txtIndex]
			findFiles = 0
			for ifile to numberOfFiles
				select Strings fileList
				filename$ = Get string: ifile
				if index(filename$, curTxt$) <> 0
					Read from file: sound_directory$ + "/" + dirname$ + "/" + filename$
					findFiles = findFiles + 1
				endif
			endfor
			if findFiles > 0
				select all
				minus Strings fileList
				minus Strings directoryList
				Concatenate
				save_file$ = sound_directory$ + "/" + dirname$ + "_" + curTxt$ + ".wav"
				Save as WAV file: save_file$
			endif
		endfor
	endif
	select all
	minus Strings directoryList
	Remove
endfor
select Strings directoryList
Remove
exit Over!
