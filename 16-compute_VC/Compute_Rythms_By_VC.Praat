# This Praat script will compute some rhythm measures.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.05.09 feelins[feipengshao@163.com]

form Dialogue
	comment 请输入标注文件目录：
	text read_path data\
	comment 结果文件:
	text save_path result.txt
	comment  
	comment VC所在的层级:
	positive vc_tier 1
endform

if (praatVersion < 6113)
	clearinfo
	appendInfoLine: "Requires Praat version 6.1.13 or higher."
	appendInfoLine: "Please upgrade your Praat version."
	exit
endif

Create Strings as file list: "fileList", read_path$ + "\*.TextGrid"
deleteFile: save_path$
appendFileLine: save_path$, "fileName" + tab$ + "sum_V" + tab$ + "sum_C" + tab$ + "mean_V" + tab$ + "mean_C" + tab$ + "delta_V" + tab$ + "delta_C" + tab$ + "percent_V" + tab$ + "varco_V" + tab$ + "varco_C" + tab$ + "nPVI_V" + tab$ + "nPVI_C" + tab$ + "rPVI_V" + tab$ + "rPVI_C"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: read_path$ + "\" + fileName$
	simpleName$ = selected$("TextGrid")
	selectObject: "TextGrid " + simpleName$
	totalDuration = Get total duration
	Down to Table: "no", 6, "no", "no"
	Append difference column: "tmax", "tmin", "duration"
	totalNumRows = Get number of rows
	firstLabel$ = Get value: 1, "text"
	if firstLabel$ = "sil"
		firstDuration = Get value: 1, "duration"
		totalDuration = totalDuration - firstDuration
	endif
	lastLabel$ = Get value: totalNumRows, "text"
	if lastLabel$ = "sil"
		lastDuration = Get value: totalNumRows, "duration"
		totalDuration = totalDuration - lastDuration
	endif
	selectObject: "Table " + simpleName$
	Extract rows where column (text): "text", "is equal to", "V"
	selectObject: "Table " + simpleName$ + "_V"
	numRows = Get number of rows
	for iRow from 1 to numRows
		durationV[iRow] = Get value: iRow, "duration"
	endfor
	# mean
	meanV = Get mean: "duration"
	# sum
	sumV = numRows * meanV
	# percent
	percentV = sumV / totalDuration
	# standard deviation
	stdV = Get standard deviation: "duration"
	# varco
	varcoV = 100 * (stdV / meanV)
	# rPVI_V
	tmpPVI_V = 0
	for iRow from 1 to numRows - 1
		curDurationV = durationV[iRow]
		nextDurationV = durationV[iRow + 1]
		tmpPVI_V = tmpPVI_V + abs(curDurationV - nextDurationV)
	endfor
	rPVI_V = tmpPVI_V / (numRows - 1) * 100
	# nPVI_V
	tmpPVI_V = 0
	for iRow from 1 to numRows - 1
		curDurationV = durationV[iRow]
		nextDurationV = durationV[iRow + 1]
		if curDurationV = 0 and nextDurationV = 0
			tmpPVI_V = tmpPVI_V
		else
			tmpPVI_V = tmpPVI_V + abs((abs(curDurationV - nextDurationV)) / ((curDurationV + nextDurationV) / 2))
		endif
	endfor
	nPVI_V = tmpPVI_V / (numRows - 1) * 100
	Save as tab-separated file: read_path$ + "\" + fileName$ + "_V.Table"
	Remove

	selectObject: "Table " + simpleName$
	Extract rows where column (text): "text", "is equal to", "C"
	selectObject: "Table " + simpleName$ + "_C"
	numRows = Get number of rows
	for iRow from 1 to numRows
		durationC[iRow] = Get value: iRow, "duration"
	endfor
	# meanC
	meanC = Get mean: "duration"
	# sumC
	sumC = numRows * meanC
	# stdC
	stdC = Get standard deviation: "duration"
	# varcoC
	varcoC = 100 * (stdC / meanC)
	# rPVI_C
	tmpPVI_C = 0
	for iRow from 1 to numRows - 1
		curDurationC = durationC[iRow]
		nextDurationC = durationC[iRow + 1]
		tmpPVI_C = tmpPVI_C + abs(curDurationC - nextDurationC)
	endfor
	rPVI_C = tmpPVI_V / (numRows - 1) * 100
	# nPVI_C
	tmpPVI_C = 0
	for iRow from 1 to numRows - 1
		curDurationC = durationC[iRow]
		nextDurationC = durationC[iRow + 1]
		if curDurationC = 0 and nextDurationC = 0
			tmpPVI_C = tmpPVI_C
		else
			tmpPVI_C = tmpPVI_C + abs((abs(curDurationC - nextDurationC)) / ((curDurationC + nextDurationC) / 2))
		endif
	endfor
	nPVI_C = tmpPVI_C / (numRows - 1) * 100
	Save as tab-separated file: read_path$ + "\" + fileName$ + "_C.Table"
	Remove
	appendFileLine: save_path$, fileName$ + tab$ + fixed$(sumV, 3) + tab$ + fixed$(sumC, 3) + tab$ + fixed$(meanV, 3) + tab$ + fixed$(meanC, 3) + tab$ + fixed$(stdV, 3) + tab$ + fixed$(stdC, 3) + tab$ + fixed$(percentV, 3) + tab$ + fixed$(varcoV, 3) + tab$ + fixed$(varcoC, 3) + tab$ + fixed$(nPVI_V, 3) + tab$ + fixed$(nPVI_C, 3) + tab$ + fixed$(rPVI_V, 3) + tab$ + fixed$(rPVI_C, 3)
	selectObject: "Table " + simpleName$
	Remove
	selectObject: "TextGrid " + simpleName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!