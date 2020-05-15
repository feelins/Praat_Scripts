# This Praat script will delete part between the selection when annotating TextGrid and wav.
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.15 feelins[feipengshao@163.com]

name$ = selected$("TextGrid", 1)

editor: "TextGrid " + name$
	startTime = Get start of selection
	endTime = Get end of selection
endeditor

selectObject: "Sound " + name$
info$ = Info
fileName$ = extractLine$ (info$, "Associated file: ")
totalDuration = Get total duration
Extract part: 0, startTime, "rectangular", 1, "no"
Rename: "part1"
selectObject: "Sound " + name$
Extract part: endTime, totalDuration, "rectangular", 1, "no"
Rename: "part2"
selectObject: "Sound part1"
plusObject: "Sound part2"
Concatenate
Rename: "newSound"
selectObject: "Sound part1"
plusObject: "Sound part2"
plusObject: "Sound " + name$
Remove
selectObject: "Sound newSound"
Rename: name$
Save as WAV file: fileName$


selectObject: "TextGrid " + name$
info$ = Info
fileName$ = extractLine$ (info$, "Associated file: ")
totalDuration = Get total duration
Extract part: 0, startTime, "no"
Rename: "part1"
selectObject: "TextGrid " + name$
Extract part: endTime, totalDuration, "no"
Rename: "part2"
selectObject: "TextGrid part1"
plusObject: "TextGrid part2"
Concatenate
Rename: "newTextGrid"
selectObject: "TextGrid part1"
plusObject: "TextGrid part2"
plusObject: "TextGrid " + name$
Remove
selectObject: "TextGrid newTextGrid"
Rename: name$
Save as text file: fileName$

selectObject: "Sound " + name$
plusObject: "TextGrid " + name$
View & Edit
