# This Praat script will save selected part of WAV and TextGrid to new file automatically.
# 
# This script is distributed under the GNU General Public License.
# Copyright feelins[feipengshao@163.com]

name$ = selected$("TextGrid", 1)

editor: "TextGrid " + name$
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
lastSlash = rindex(fileName$, wavName$)
formerName$ = left$(fileName$, lastSlash - 1 - 1)
lastlastSlash = rindex(formerName$, "\")
formerformerName$ = left$(formerName$, lastlastSlash)
oldDirName$ = replace$(formerName$, formerformerName$, "", 0)
newDirName$ = oldDirName$ + "_New"
newFullDirName$ = formerformerName$ + newDirName$
createDirectory: newFullDirName$
startTimeName$ = fixed$(startTime, 3)
startTimeName$ = replace$(startTimeName$, ".", "-", 0)
newFullFileName$ = newFullDirName$ + "\" + name$ + "_" + startTimeName$ + ".wav"
Save as WAV file: newFullFileName$
Remove

selectObject: "TextGrid " + name$
textgridName$ = name$ + ".TextGrid"
info$ = Info
fileName$ = extractLine$ (info$, "Associated file: ")
selectObject: "TextGrid " + name$
Extract part: startTime, endTime, "no"
Rename: "part"
lastSlash = rindex(fileName$, textgridName$)
formerName$ = left$(fileName$, lastSlash - 1 - 1)
lastlastSlash = rindex(formerName$, "\")
formerformerName$ = left$(formerName$, lastlastSlash)
oldDirName$ = replace$(formerName$, formerformerName$, "", 0)
newDirName$ = oldDirName$ + "_New"
newFullDirName$ = formerformerName$ + newDirName$
createDirectory: newFullDirName$
startTimeName$ = fixed$(startTime, 3)
startTimeName$ = replace$(startTimeName$, ".", "-", 0)
newFullFileName$ = newFullDirName$ + "\" + name$ + "_" + startTimeName$ + ".TextGrid"
Save as text file: newFullFileName$
Remove

selectObject: "Sound " + name$
plusObject: "TextGrid " + name$
