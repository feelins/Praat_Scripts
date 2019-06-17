# This Praat script will extract duration and pitch of One particular Tier based on the TextGrid file and sound file
# and save result to a TXT file.
# 提取某一层的Interval的时长及名称(空白标注忽略)，以及10个基频点, 需要提供标注TextGrid和sound
# 提取的10个点，是在Interval时长归一化的10个点
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.06.17 feelins[feipengshao@163.com]
# [result]:
# fileName	name	duration	Pitch1	Pitch2	Pitch3	Pitch4	Pitch5	Pitch6	Pitch7	Pitch8	Pitch9	Pitch10
# 000001.TextGrid	sil	0.280	262	262	262	262	262	262	262	262	262	262
# 000001.TextGrid	k	0.127	262	262	262	262	262	262	262	262	262	262
# 000001.TextGrid	a2	0.110	262	262	263	265	268	273	278	285	293	303
# 000001.TextGrid	er2	0.098	303	313	322	331	338	341	341	338	333	328
# 000001.TextGrid	p	0.129	328	324	320	318	315	312	310	306	300	291
# 000001.TextGrid	u3	0.157	291	271	247	225	211	204	200	199	198	199
# 000001.TextGrid	p	0.075	199	200	201	203	206	208	211	213	216	219
# 000001.TextGrid	ei2	0.140	219	224	225	225	224	227	233	242	254	267

form Information
	comment Directory path of input wav files:
	text input_wav_directory /home/shaopf/test/wav/
	comment Directory path of input TextGrid files:
	text input_directory /home/shaopf/test/TextGrid/
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_result /home/shaopf/test/result_duration_pitch.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

writeFileLine: save_result$, "fileName" + tab$ + "name" + tab$ + "duration" + tab$ + "Pitch1" + tab$ + "Pitch2" + tab$ + "Pitch3" + tab$ + "Pitch4" + tab$ + "Pitch5" + tab$ + "Pitch6" + tab$ + "Pitch7" + tab$ + "Pitch8" + tab$ + "Pitch9" + tab$ + "Pitch10"

Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings
for iFile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: iFile
	textGridFileName$ = input_directory$ + fileName$
	Read from file: textGridFileName$
	objectName$ = selected$ ("TextGrid", 1)
	wavFileName$ = input_wav_directory$ + objectName$ + ".wav"
	
	Read from file: wavFileName$

	To Pitch: 0, 75, 600
	Interpolate
	Smooth: 10
	Down to PitchTier
	selectObject: "Pitch " + objectName$
	Remove
	selectObject: "Pitch " + objectName$
	Remove
	selectObject: "Pitch " + objectName$
	Remove

	selectObject: "TextGrid " + objectName$
	numberOfIntervals = Get number of intervals: reference_tier
	for iInterval from 1 to numberOfIntervals
		selectObject: "TextGrid " + objectName$
		sTime = Get start point: reference_tier, iInterval
		eTime = Get end point: reference_tier, iInterval
		duration = eTime-sTime

		labelOfInterval$ = Get label of interval: reference_tier, iInterval
		output$ = fileName$ + tab$ + labelOfInterval$ + tab$ + fixed$(duration, 3) + tab$
		stepTime = duration / 9
		for i from 1 to 10
			selectObject: "PitchTier " + objectName$
			tmpTime = sTime + stepTime * (i - 1)
			pitchValue = Get value at time: tmpTime
			output$ = output$ + fixed$(pitchValue, 0)
			if i <> 10
				output$ = output$ + tab$
			endif
		endfor
		appendFileLine: save_result$, output$
	endfor
	
	selectObject: "TextGrid " + objectName$
	Remove
	selectObject: "Sound " + objectName$
	Remove
	selectObject: "PitchTier " + objectName$
	Remove
endfor

selectObject: "Strings fileList"
Remove
exit Done!Thank you!-shaopf