# This Praat script will delete current selected boundary when annotating TextGrid
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.10.10 feelins[feipengshao@163.com]

name$ = selected$("TextGrid", 1)

editor: "TextGrid " + name$
	curTime = Get start of selection
endeditor

selectObject: "TextGrid " + name$
totalTiers = Get number of tiers

# 在此修改需要处理的层，只处理一层
# totalTiers = 1

for targetTier from 1 to totalTiers
	selectObject: "TextGrid " + name$
	Remove boundary at time: targetTier, curTime
endfor

selectObject: "Sound " + name$
plusObject: "TextGrid " + name$
