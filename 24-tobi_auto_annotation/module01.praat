###########################################################################
#                                                                      	  #
#  Praat Script: PyToBI                          			           	  #
#  Copyright (C) 2019  Mónica Domínguez-Bajo - Universitat Pompeu Fabra   #
#																		  #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 3 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
###########################################################################
##### MODULE 1 ############################################################
###### Intensity peak detection 		v.01    						  #
###########################################################################
appendInfoLine: "Computing prosodic parameters under Praat"

clearinfo
form Parameters
	text directory data/
endform

Create Strings as file list: "fileList", directory$ + "/*.TextGrid"
fileNum = Get number of strings
for ifile from 1 to fileNum
selectObject: "Strings fileList"
fileName$ = Get string: ifile
basename$ = fileName$ - ".TextGrid"
# Variables for objects in Menu
sound$ = "Sound " + basename$
text$ = "TextGrid " + basename$
int$ = "Intensity " + basename$
peak$ = "IntensityTier " + basename$
pitch$ = "Pitch " + basename$

#Variables for writing features
startFeatLine$ = "{"
intFeat$ = "="
endFeat$ = ","
endFeatLine$ = "}"

Read from file: directory$ + basename$ + ".wav"

# Create silence tier. Voiced parts carry no interval label
To TextGrid (silences): 100, 0, -25, 0.1, 0.03, "SIL", ""

# Create Intensity Object
selectObject: sound$
To Intensity: 100, 0, "yes"

# Extract peaks
To IntensityTier (peaks)
n_peaks = Get number of points

# Create Pitch object
selectObject: sound$
To Pitch: 0, 20, 500


# Create intensity peak tier
selectObject: text$
Insert point tier: 2, "peaks"

#Loop over IntensityTier peak object ("peak$" variable) taking into account next peak
for i from 1 to n_peaks
	selectObject: peak$
	t_peak = Get time from index: i
	int_peak = Get value at index: i
	int_peak$ = fixed$ (int_peak, 0)
	i_next = i + 1
	if i_next <= n_peaks
		t_next = Get time from index: i_next
		int_next = Get value at index: i_next
		dist = t_next - t_peak
		int_dif = int_peak - int_next
		if dist > 0.05 && int_dif >= 0
			selectObject: pitch$
			f0 = Get value at time: t_peak, "Hertz", "linear"
			f0$ = fixed$ (f0, 0)
			if f0$ != "--undefined--"
				selectObject: text$
				i_sil = Get interval at time: 1, t_peak
				l_sil$ = string$ (i_sil)
				if l_sil$ != "SIL"
					sil_st = Get starting point: 1, i_sil
					sil_end = Get end point: 1, i_sil
					timeMaxInt = t_peak- sil_st/ (sil_end - sil_st)
					timeMaxInt$ = fixed$ (timeMaxInt, 2)
					#Annotate absolute acoustic features to each intensity peak
					labtext$ = l_sil$ + startFeatLine$ +"int"+ intFeat$+ int_peak$ + endFeat$ + "t_maxInt"+ intFeat$+ timeMaxInt$ + endFeat$ + "f0"+ intFeat$+ f0$ + endFeat$
					Insert point: 2, t_peak, labtext$
				endif
			endif
		endif
	endif
endfor


# Save temporary files
selectObject: text$
Write to text file: directory$ + basename$ + "_mod1.TextGridd"

selectObject: int$
Write to binary file: directory$ + basename$ + ".Intensity"

selectObject: pitch$
Write to binary file: directory$ + basename$ + ".Pitch"
select all
minusObject: "Strings fileList"
Remove
endfor
# clean Menu

appendInfoLine: "····························································"
appendInfoLine: "END OF MODULE 1 !"
appendInfoLine: "····························································"
appendInfoLine: "····························································"

############### END OF MODULE 1 ####################