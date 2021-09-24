# This Praat script will generate the TextGrid with only one Tier to check the speech script.
# 只生成一层TextGrid，为了校对读音
# 
# This script is distributed under the GNU General Public License.
# 博客说明：
# Copyright 2021.09.17 feelins[feipengshao@163.com]



form Dialogue_GenTextGrid
	comment Directory path of input WAV files：
	text input_wav_path wavs\
	comment Path of input Txt file:
	text input_text_path txt_list.txt
	comment Directory path of output TextGrid files:
	text output_textgrid_path outTextGrids\
endform

clearinfo

# 如果新目录不存在，自动创建
createDirectory: output_textgrid_path$

Read Table from tab-separated file: input_text_path$
Rename: "TableList"
numOfTableRows = Get number of rows
for nt from 1 to numOfTableRows
	selectObject: "Table TableList"
	tablefilename$['nt'] = Get value: nt, "filename"
	tablesentence$['nt'] = Get value: nt, "sentence"
endfor
selectObject: "Table TableList"
Remove

Create Strings as file list: "fileList", input_wav_path$ + "*.wav"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	simpleName$ = fileName$ - ".wav"
	writeInfoLine: simpleName$
	wavFullPath$ = input_wav_path$ + simpleName$ + ".wav"
	Read from file: wavFullPath$
	simpleNameNoBlank$ = selected$("Sound",1)
	To TextGrid: "script", ""
	for nt from 1 to numOfTableRows
		curName$ = tablefilename$['nt']
		curTxt$ = tablesentence$['nt']
		if curName$ = simpleNameNoBlank$
			Set interval text: 1, 1, curTxt$
		endif
	endfor

	selectObject: "TextGrid " + simpleNameNoBlank$
	Save as text file: output_textgrid_path$ + simpleName$ + ".TextGrid"
	selectObject: "Sound " + simpleNameNoBlank$
	plusObject: "TextGrid " + simpleNameNoBlank$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!


