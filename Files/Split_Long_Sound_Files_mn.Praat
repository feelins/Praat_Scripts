# This Praat script will split long sound files into small parts according to the manually label in TextGrid
# and save the small files to another directory.
# This script is specially for m Process.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.20 feelins[feipengshao@163.com]

form dialogue
	comment Please input the source sound files path：
	text inputWavPath /media/shaopf/Works/008_Mongo/20190320_SplitWords/test/
	comment Please input the source TextGrid files path：
	text inputTextGridPath /media/shaopf/Works/008_Mongo/20190320_SplitWords/test/
	comment Please input the source txt files path:
	text inputTxtPath /media/shaopf/Works/008_Mongo/008_Mongo/20181218/Biaozhun_Female_txt_New/Biaozhun_Female_txt_New/
	comment Please input the target sound Files path：
	text savePath /media/shaopf/Works/008_Mongo/20190320_SplitWords/split_wavs/
	comment Please input the label tier：
	positive tierNumber 1
	comment Please input the fileNames list file:
	text listFile /media/shaopf/Works/008_Mongo/20190320_SplitWords_list.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

# create the target path automatically
createDirectory: savePath$

Create Strings as file list: "fileList", inputWavPath$ + "*.TextGrid"
numofFiles = Get number of strings

# Total Order Number
order = 1
for ifile from 1 to numofFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	simpleName$ = fileName$ - ".TextGrid"
	Read from file: inputWavPath$ + simpleName$ + ".wav"
	Read Strings from raw text file: inputTxtPath$ + simpleName$ + ".txt"
	Read from file: inputTextGridPath$ + simpleName$ + ".TextGrid"
	numOfIntervals = Get number of intervals: tierNumber
	startTime = Get start point: tierNumber, 1
	endTime = Get end point: tierNumber, 1
	i = 2
	while i < numOfIntervals
		selectObject: "TextGrid " + simpleName$
		repeat
			selectObject: "TextGrid " + simpleName$
			labelOfInterval$ = Get label of interval: tierNumber, i
			endTime = Get end point: tierNumber, i
			tmpstartTime = Get start point: tierNumber, i
			i = i + 1
			#pause 'labelOfInterval$', 'i'
		until labelOfInterval$ = "silv" or labelOfInterval$ = "sil"
		#pause
		selectObject: "TextGrid " + simpleName$
		Extract part: startTime, endTime, "no"
		selectObject: "Sound " + simpleName$
		Extract part: startTime, endTime, "rectangular", 1, "no"
		
		# change the numbers
		temp = order
		ii = 0
		repeat
			temp = temp div 10
			ii = ii + 1
		until temp = 0
		sumtemp = 3 - ii
		mark$ = ""
		for jjj from 1 to sumtemp
			mark$ = mark$ + "0"
		endfor
		mark$ = mark$ + string$(order)

		selectObject: "TextGrid " + simpleName$ + "_part"
		tmpInterval = Get number of intervals: 1
		time1 = Get end point: 1, 1
		time2 = Get start point: 1, tmpInterval
		Insert interval tier: 1, "word"
		Insert boundary: 1, time1
		Insert boundary: 1, time2
		selectObject: "Strings " + simpleName$
		tmpWord$ = Get string: order
		selectObject: "TextGrid " + simpleName$ + "_part"
		Set interval text: 1, 1, "sil"
		Set interval text: 1, 2, tmpWord$
		Set interval text: 1, 3, "sil"
		Insert interval tier: 3, "CV"
		tmpInterval = Get number of intervals: 2
		for j from 2 to tmpInterval
			tmpTime = Get start point: 2, j
			Insert boundary: 3, tmpTime
		endfor
		Set interval text: 3, 1, "sil"
		Set interval text: 3, tmpInterval, "sil"

		Save as text file: savePath$  + simpleName$ + "_" + mark$ + "_" + tmpWord$ + ".TextGrid"
		selectObject: "Sound " + simpleName$ + "_part"
		Save as WAV file: savePath$  + simpleName$ +  "_" + mark$ + "_" + tmpWord$ + ".wav"
		order = order + 1
		selectObject: "TextGrid " + simpleName$ + "_part"
		Remove
		selectObject: "Sound " + simpleName$ + "_part"
		Remove
		selectObject: "TextGrid " + simpleName$
		startTime = tmpstartTime
		i = i + 1
	endwhile
	selectObject: "TextGrid " + simpleName$
	Remove
	selectObject: "Sound " + simpleName$
	Remove
	selectObject: "Strings " + simpleName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!