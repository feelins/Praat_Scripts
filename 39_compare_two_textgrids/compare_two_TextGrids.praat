# This Praat script will merge tiers of different TextGrid dirs, which tiers you can choose freely.
# and save new TextGrids to a new path.
# 合并不同目录里的TextGrid的需要的层级
# 
# This script is distributed under the GNU General Public License.
# Copyright 2023.03.25 feelins[feipengshao@163.com]

form Information
	comment Input main directory - 输入TextGrid主目录:
	text input_directory_main A/
	comment Input secondary directory - 输入TextGrid次目录:
	text input_directory_secondary B/
	comment Word or Syllable Tier - 输入字或者词层
	positive tier_word 1
	comment Phoneme Tier - 输入音素层
	positive tier_phon 2
	comment Want to check? - 是否准备校对错误TG
	boolean check_not 0
	comment Path of output check TG - 输入保存校对错误TG目录
	text save_path new_TextGrid/
	comment Path of output result file - 输入保存校对结果路径
	text save_result_path check_result.txt
endform

if (praatVersion < 6300)
	printline Requires Praat version 6.3 or higher. Please upgrade your Praat version 
	exit
endif

if check_not
	createDirectory: save_path$
endif
deleteFile: save_result_path$
Create Strings as file list: "fileList", input_directory_main$ + "*.TextGrid"
fileNum = Get number of strings
diff_phon = 0
diff_word = 0
total_word = 0
total_phon = 0

appendFileLine: save_result_path$, "主目录：" + "," + input_directory_main$
appendFileLine: save_result_path$, "待比较目录：" + "," + input_directory_secondary$
appendFileLine: save_result_path$, "比较结果如下："
for file from 1 to fileNum
	selectObject: "Strings fileList"
	fileName$ = Get string: file
	input_textgrid_file_main$ = input_directory_main$ + fileName$
	input_textgrid_file_second$ = input_directory_secondary$ + fileName$
	if fileReadable(input_textgrid_file_main$) and fileReadable(input_textgrid_file_second$)
		Read from file: input_textgrid_file_main$
		Rename: "main"
		mainObjectName$ = "main"
		Read from file: input_textgrid_file_second$
		Rename: "second"
		secondObjectName$ = "second"
		selectObject: "TextGrid " + mainObjectName$
		interNumWordMain = Get number of intervals: tier_word
		selectObject: "TextGrid " + secondObjectName$
		interNumWordSecond = Get number of intervals: tier_word
		if interNumWordMain <> interNumWordSecond
			printline 需要两个比较对象的词或者字个数是相同的
			exit
		endif
		find_diff = 1
		for iNumWord from 1 to interNumWordMain
			selectObject: "TextGrid " + mainObjectName$
			same_word = 1
			wordStart = Get start time of interval: tier_word, iNumWord
			wordEnd = Get end time of interval: tier_word, iNumWord
			wordName$ = Get label of interval: tier_word, iNumWord
			
			phonStartInterval = Get interval at time: tier_phon, wordStart
			phonEndInterval = Get interval at time: tier_phon, wordEnd
			phonEndInterval = phonEndInterval - 1
			for iNumPhon from phonStartInterval to phonEndInterval
				selectObject: "TextGrid " + mainObjectName$
				phonNameMain$ = Get label of interval: tier_phon, iNumPhon
				phonStartMain = Get start time of interval: tier_phon, iNumPhon
				selectObject: "TextGrid " + secondObjectName$
				phonNameSecond$ = Get label of interval: tier_phon, iNumPhon
				phonStartSecond = Get start time of interval: tier_phon, iNumPhon
				if phonNameMain$ <> phonNameSecond$
					selectObject: "TextGrid " + secondObjectName$
					Set interval text: tier_phon, iNumPhon, phonNameSecond$ + "%%%%%"

					diff_phon = diff_phon + 1
					same_word = 0
					find_diff = 0
					appendFileLine: save_result_path$, fileName$ + ", 标注内容不同, " + wordName$ + ", " + string$(phonStartMain) + ", " + phonNameMain$ + "-" + phonNameSecond$
				endif
				if phonStartMain <> phonStartSecond
					selectObject: "TextGrid " + secondObjectName$
					Set interval text: tier_phon, iNumPhon, phonNameSecond$ + "%%%%%"
					diff_phon = diff_phon + 1
					same_word = 0
					find_diff = 0
					appendFileLine: save_result_path$, fileName$ + ", 标注边界不同, " + wordName$ + ", " + string$(phonStartMain) + ", " + phonNameMain$ + "-" + phonNameSecond$
				endif
				total_phon = total_phon + 1
			endfor
			if same_word = 0
				diff_word = diff_word + 1
			endif
			total_word = total_word + 1
		endfor
		if check_not and not find_diff
			selectObject: "TextGrid " + mainObjectName$
			plusObject: "TextGrid " + secondObjectName$
			Merge
			Save as text file: save_path$ + fileName$
			Remove
		endif
		#TextGrid settings: 18, "centre", "are shown as typed", "multiple boundaries", "intervals or points", "ends with", "%%%%%"
		selectObject: "TextGrid " + mainObjectName$
		Remove
		selectObject: "TextGrid " + secondObjectName$
		Remove
	endif
endfor
selectObject: "Strings fileList"
Remove
appendFileLine: save_result_path$, ""
appendFileLine: save_result_path$, "比较一致率情况："
appendFileLine: save_result_path$, "检查后两者词/字一致率" + string$(1 - (diff_word / total_word))
appendFileLine: save_result_path$, "检查后两者音素一致率" + string$(1 - (diff_phon / total_phon))
exit Done!Thank you!-shaopf