# This Praat script will save selected part of wav to a new WAV file automatically.
# 
# This script is distributed under the GNU General Public License.
# Copyright feelins[feipengshao@163.com]

name$ = selected$("Sound", 1)

editor: "Sound " + name$
	startTime = Get start of selection
	endTime = Get end of selection
endeditor

selectObject: "Sound " + name$
wavName$ = name$ + ".wav"
info$ = Info
fileName$ = extractLine$ (info$, "Associated file: ")
selectObject: "Sound " + name$
Extract part: startTime, endTime, "rectangular", 1, "no"
Rename: "part"
a = rindex(fileName$, wavName$)
formerName$ = left$(fileName$, a - 1 - 1)
b = rindex(formerName$, "\")
formerformerName$ = left$(formerName$, b)
oldDirName$ = replace$(formerName$, formerformerName$, "", 0)
newDirName$ = oldDirName$ + "_New"
newFullDirName$ = formerformerName$ + newDirName$
createDirectory: newFullDirName$
startTimeName$ = fixed$(startTime, 3)
startTimeName$ = replace$(startTimeName$, ".", "-", 0)
newFullFileName$ = newFullDirName$ + "\" + name$ + "_" + startTimeName$ + ".wav"
Save as WAV file: newFullFileName$
Remove

selectObject: "Sound " + name$
