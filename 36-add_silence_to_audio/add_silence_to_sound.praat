# This Praat script will add silence before and after a sound file.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2022.03.13 feelins[feipengshao@163.com]

form add_silence
	sentence inputDirectory input_wav\
	positive addSilenceDuration 0.025
	positive samplingFrequency 48000
	sentence outputDirectory output_wav\
endform

createDirectory: outputDirectory$

Create Strings as file list: "fileList", inputDirectory$ + "*.wav"
numberFiles = Get number of strings

Create Sound from formula: "before", 1, 0, addSilenceDuration, samplingFrequency, "0 * x"

for ifile from 1 to numberFiles
	select Strings fileList
	fileName$ = Get string: ifile
	Read from file: inputDirectory$ + fileName$
	objectName$ = selected$("Sound", 1)
	Create Sound from formula: "after", 1, 0, addSilenceDuration, samplingFrequency, "0 * x"
	selectObject: "Sound before"
	plusObject: "Sound " + objectName$
	plusObject: "Sound after"
	Concatenate
	Save as WAV file: outputDirectory$ + fileName$
	selectObject: "Sound " + objectName$
	plusObject: "Sound after"
	plusObject: "Sound chain"
	Remove
endfor
selectObject: "Sound before"
Remove
select Strings fileList
Remove
exit over!

	

