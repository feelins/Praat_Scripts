# This Praat script will set word and phonemes according to your given dict and label automatically, the duration is averaged by total.
# 简单的自动标注，时长通过平均得到，仅仅为了得到标注的边界，人工辅助调整
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.04.26 feelins[feipengshao@163.com]

form Dialogue_Auto
	comment Directory path of input WAV files：
	text input_wav_path audios\
	comment Directory path of input labels files:
	text input_label_path labels\
	comment Directory path of input dict files:
	text input_dict_path dict.txt
	comment Directory path of ouput TextGrid files：
	text output_textgrid_path TextGrid\
endform

if (praatVersion < 6309)
	printline Requires Praat version 6.3.09 or higher. Please upgrade your Praat version 
	exit
endif


# 如果新目录不存在，自动创建
createDirectory: output_textgrid_path$

Read Table from tab-separated file: input_dict_path$
Rename: "TableList"
numOfTableRows = Get number of rows
for nt from 1 to numOfTableRows
	selectObject: "Table TableList"
	curKey$ = Get value: nt, "word"
	curValue$ = Get value: nt, "phons"
	wordPhon$[curKey$] = curValue$ 
endfor
selectObject: "Table TableList"
Remove

Create Strings as file list: "fileList", input_wav_path$ + "*.wav"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	simpleName$ = fileName$ - ".wav"
	wavFullPath$ = input_wav_path$ + simpleName$ + ".wav"
	textGridFullPath$ = output_textgrid_path$ + simpleName$ + ".TextGrid"
	labelPath$ = input_label_path$ + simpleName$ + ".txt"
	
	Read from file: wavFullPath$
	totalDur = Get total duration

	objectName$ = selected$("Sound", 1)
	To TextGrid: "word phon", ""	
	Read Table from whitespace-separated file: labelPath$
	totalNum = Get number of rows
	for mt from 1 to totalNum
		selectObject: "Table " + objectName$
		txtValue$['mt'] = Get value: mt, "sent"
	endfor
	selectObject: "Table " + objectName$
	Remove

	stepTime = totalDur / totalNum
	beginTime = 0
	for mt from 1 to totalNum
		selectObject: "TextGrid " + objectName$
		tmpTime = beginTime + stepTime * mt
	 	if mt <> totalNum
			Insert boundary: 1, tmpTime
			Insert boundary: 2, tmpTime
		endif
		tmpInterval = Get interval at time: 1, tmpTime
		if tmpTime <> totalDur
			tmpInterval = tmpInterval - 1
		endif
		tmpValue$ = txtValue$['mt']
		Set interval text: 1, tmpInterval, tmpValue$ + wordPhon$[tmpValue$]
		tmpWordPhon$ = wordPhon$[tmpValue$]
		phons$# = splitByWhitespace$#(tmpWordPhon$)
		phonsSize = size(phons$#)
		
		thisStart = Get start time of interval: 1, tmpInterval
		thisEnd = Get end time of interval: 1, tmpInterval
		

		stepPhonTime = (thisEnd - thisStart) / phonsSize
		for kt from 1 to phonsSize
			thisTmpTime = thisStart + stepPhonTime * kt
			if kt <> phonsSize
				Insert boundary: 2, thisTmpTime
			endif
			tmpInterval2 = Get interval at time: 2, thisTmpTime
			if thisTmpTime <> totalDur
				tmpInterval2 = tmpInterval2 - 1
			endif
			thisTmpValue$ = phons$#['kt']
			
			Set interval text: 2, tmpInterval2, thisTmpValue$
		endfor
	endfor
	
	selectObject: "TextGrid " + objectName$
	Save as text file: textGridFullPath$
	selectObject: "Sound " + objectName$
	plusObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!


