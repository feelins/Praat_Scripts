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
	#writeInfoLine: simpleName$
	wavFullPath$ = input_wav_path$ + simpleName$ + ".wav"
	textGridFullPath$ = output_textgrid_path$ + simpleName$ + ".TextGrid"
	labelPath$ = input_label_path$ + simpleName$ + ".txt"
	

	Read from file: wavFullPath$


	objectName$ = selected$("Sound", 1)
	To TextGrid (silences): 100, 0, -25, 0.1, 0.1, "", "sounding"
	intervalNums = Get number of intervals: 1
	#pause 'intervalNums'
	firstTime = 0
	totalDur = Get total duration
	lastTime = totalDur
	if intervalNums >= 3
		firstlab$ = Get label of interval: 1, 1
		lastlab$ = Get label of interval: 1, intervalNums
		if firstlab$ = ""
			firstTime = Get end time of interval: 1, 1
		endif
		if lastlab$ = ""
			lastTime = Get start time of interval: 1, intervalNums
		endif
	endif
	selectObject: "TextGrid " + objectName$
	Remove

	selectObject: "Sound " + objectName$
	To TextGrid: "word phon", ""
	
	if firstTime <> 0
		Insert boundary: 1, firstTime
		Insert boundary: 2, firstTime
	endif
	if lastTime <> totalDur
		Insert boundary: 1, lastTime
	endif
	
	#Insert boundary: 2, lastTime

	
	Read Table from whitespace-separated file: labelPath$
	totalNum = Get number of rows
	for mt from 1 to totalNum
		selectObject: "Table " + objectName$
		txtValue$['mt'] = Get value: mt, "sent"
	endfor
	selectObject: "Table " + objectName$
	Remove

	stepTime = (lastTime - firstTime) / totalNum
	for mt from 1 to totalNum
		selectObject: "TextGrid " + objectName$
		tmpTime = firstTime + stepTime * mt
	 	if mt <> totalNum
			Insert boundary: 1, tmpTime
		endif
		tmpInterval = Get interval at time: 1, tmpTime
		if tmpTime <> totalDur
			tmpInterval = tmpInterval - 1
		endif
		tmpValue$ = txtValue$['mt']
		Set interval text: 1, tmpInterval, tmpValue$ + wordPhon$[tmpValue$]
		tmpWordPhon$ = wordPhon$[tmpValue$]
		resultPhonIndex = 1
		repeat
			blankMark = index(tmpWordPhon$, " ")
			if blankMark <> 0
				resultPhons$[resultPhonIndex] = left$(tmpWordPhon$, blankMark - 1)
				tmptmp$ = left$(tmpWordPhon$, blankMark - 1)
				tmpWordPhon$ = right$(tmpWordPhon$, length(tmpWordPhon$) - blankMark)
				resultPhonIndex = resultPhonIndex + 1
			endif
		until blankMark = 0
		#resultPhonIndex = resultPhonIndex - 1
		resultPhons$[resultPhonIndex] = tmpWordPhon$
		thisStart = Get start time of interval: 1, tmpInterval
		thisEnd = Get end time of interval: 1, tmpInterval
		

		stepPhonTime = (thisEnd - thisStart) / resultPhonIndex
		for kt from 1 to resultPhonIndex
			thisTmpTime = thisStart + stepPhonTime * kt
			if thisTmpTime <> totalDur
				Insert boundary: 2, thisTmpTime
			endif
			tmpInterval2 = Get interval at time: 2, thisTmpTime
			if thisTmpTime <> totalDur
				tmpInterval2 = tmpInterval2 - 1
			endif
			thisTmpValue$ = resultPhons$['kt']
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


