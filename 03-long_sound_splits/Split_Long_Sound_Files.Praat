# This Praat script will split long wav files into small ones. 
# 
# This script is distributed under the GNU General Public License.
# 博客说明：https://blog.csdn.net/shaopengfei/article/details/109097404
# Copyright 2020.04.17 feelins[feipengshao@163.com] 



form dialogue
	comment Please input the source wav and textgrid files:
	text input_directory LongWavToDo_1\
	comment Please input the result wav files:
	text output_directory small_wavs_1\
	comment Please input the mark symbols tier:
	positive tier_number 1
	sentence mark_string 
	optionmenu file_mark: 1
		option FileName_markString_order
		option FileName_order
		option FileName_order(No mark)
	comment Please input the digits of order：
	positive limit 4
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$

Create Strings as file list: "fileList", input_directory$ + "*.wav"
numofFiles = Get number of strings
for iFile from 1 to numofFiles
	# set the initial order
	order = 1

	selectObject: "Strings fileList"
	fileName$ = Get string: iFile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("Sound", 1)
	textgridName$ = objectName$ + ".TextGrid"
	Read from file: input_directory$ + textgridName$	
	intervalNums = Get number of intervals: tier_number
	for iInterval from 1 to intervalNums
		selectObject: "TextGrid " + objectName$
		start = Get start time of interval: tier_number, iInterval
		end = Get end time of interval: tier_number, iInterval
		intervalName$ = Get label of interval: tier_number, iInterval
		#####
		if (intervalName$ = mark_string$ and mark_string$ <> "") or (intervalName$ <> "" and mark_string$ = "" and intervalName$ <> "sil")
			##### extend 0.3 seconds at the begin and end boundary
			start = start - 0.3
			end = end + 0.3
			selectObject: "Sound " + objectName$
			Extract part: start, end, "rectangular", 1, "no"
			# 
			temp = order
			ii = 0
			repeat
				temp = temp div 10
				ii = ii+1
			until temp = 0
			sumtemp = limit - ii
			mark$ = ""
			for jjj from 1 to sumtemp
				mark$ = mark$ + "0"
			endfor
			mark$ = mark$ + string$(order)

			if file_mark=1
				selectObject: "Sound " + objectName$ + "_part"
				Save as WAV file: output_directory$ + objectName$ + "_" + intervalName$ + "_" + mark$ + ".wav"
			endif
			if file_mark=2
				selectObject: "Sound " + objectName$ + "_part"
				Save as WAV file: output_directory$ + objectName$ + "_" + mark$ + ".wav"
			endif
			selectObject: "Sound " + objectName$ + "_part"
			Remove
			order = order + 1
		elsif (file_mark = 3 and mark_string$ = "")
			##### extend 0.3 seconds at the begin and end boundary
			start = start - 0.3
			end = end + 0.3
			selectObject: "Sound " + objectName$
			Extract part: start, end, "rectangular", 1, "no"
			# 
			temp = order
			ii = 0
			repeat
				temp = temp div 10
				ii = ii+1
			until temp = 0
			sumtemp = limit - ii
			mark$ = ""
			for jjj from 1 to sumtemp
				mark$ = mark$ + "0"
			endfor
			mark$ = mark$ + string$(order)

			if file_mark=3
				selectObject: "Sound " + objectName$ + "_part"
				Save as WAV file: output_directory$ + objectName$ + "_" + mark$ + ".wav"
			endif
			selectObject: "Sound " + objectName$ + "_part"
			Remove
			order = order + 1	
		endif
	endfor
	selectObject: "TextGrid " + objectName$
	Remove
	selectObject: "Sound " + objectName$
	Remove
endfor
select Strings fileList
Remove
exit Over!
