# This script is to generate Rhythm Text through TextGrid.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2023.04.22 [feipengshao@163.com] 

form info
   	comment Directory path of input files:
   	text input_directory  input_data_中文/
   	comment Directory path of output files:
	text output_txt_file  Rhythm_中文.txt
	comment Word/Syllable Tier:
	integer syl_tier 2
	comment Phoneme Tier:
	integer phon_tier 1
	comment Point Break Tier:
	integer point_break_tier 0
endform

if (praatVersion < 6300)
	printline Requires Praat version 6.3 or higher. Please upgrade your Praat version 
	exit
endif

Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings
deleteFile: output_txt_file$
for ifile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("TextGrid", 1)
	totalTier = Get number of tiers
	numberOfIntervals = Get number of intervals: syl_tier
	word_line_str$ = ""
	phon_line_str$ = ""
	for iInterval from 1 to numberOfIntervals
		selectObject: "TextGrid " + objectName$
		sTime = Get start point: syl_tier, iInterval
		eTime = Get end point: syl_tier, iInterval

		labelOfInterval$ = Get label of interval: syl_tier, iInterval
		bInterval = Get interval at time: phon_tier , sTime
		eInterval = Get interval at time: phon_tier , eTime
		if iInterval <> numberOfIntervals
			eInterval = eInterval - 1
		endif
		tmp_phon_str$ = ""
		for iiInterval from bInterval to eInterval
			labelOfIntervalPhon$ = Get label of interval: phon_tier, iiInterval
			tmp_phon_str$ = tmp_phon_str$ + labelOfIntervalPhon$
			if iiInterval <> eInterval
				tmp_phon_str$ = tmp_phon_str$ + "+"
			endif
		endfor
		word_line_str$ = word_line_str$ + labelOfInterval$
		phon_line_str$ = phon_line_str$ + tmp_phon_str$
		if point_break_tier <> 0
			totalNumPoint = Get number of points: point_break_tier
			find_point_label$ = ""
			for j from 1 to totalNumPoint
				tmp_time = Get time of point: point_break_tier, j
				point_label$ = Get label of point: point_break_tier, j
				if tmp_time = eTime
					find_point_label$ = point_label$
				endif
			endfor
			if find_point_label$ <> "" and iInterval <> numberOfIntervals
				word_line_str$ = word_line_str$ + " " + "(" + find_point_label$ + ")"
			endif
		endif
		if iInterval <> numberOfIntervals
			word_line_str$ = word_line_str$ + " "
			phon_line_str$ = phon_line_str$ + " "
		endif
	endfor
	appendFileLine: output_txt_file$, fileName$
	appendFileLine: output_txt_file$, word_line_str$
	appendFileLine: output_txt_file$, phon_line_str$
	appendFileLine: output_txt_file$, ""

	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!