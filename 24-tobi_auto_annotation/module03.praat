###########################################################################
#                                                                      	  #
#  Praat Script: PyToBI           			                          	  #
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
##### MODULE 3 ############################################################
###### Acoustic feature annotation										  #
###########################################################################
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
Read from file: directory$ + basename$ + "_mod1.TextGridd"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + "_mod2.TextGridd"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + ".Pitch"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_mod2"
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$

#Variables for writing features
startFeatLine$ = "{"
intFeat$ = "="
endFeat$ = ","
endFeatLine$ = "}"

# Extract acoustic features from the whole soundfile
############################################################
# Write features to a general tier "utterance(L1)" n.1
############################################################
selectObject: text$
dur = Get total duration
dur$ = fixed$(dur, 2)
selectObject: int$
meanint = Get mean: 0, 0, "dB"
stdint = Get standard deviation: 0, 0
minint = Get minimum: 0, 0, "Parabolic"
timeMinInt_s = Get time of minimum: 0, 0, "Parabolic"
timeMinInt = timeMinInt_s/dur
maxint = Get maximum: 0, 0, "Parabolic"
timeMaxInt_s = Get time of maximum: 0, 0, "Parabolic"
timeMaxInt = timeMaxInt_s/dur
rangeInt = maxint - minint
meanint$ = fixed$ (meanint, 0)
stdint$ = fixed$ (stdint, 2)
minint$ = fixed$ (minint, 0)
timeMinInt$ = fixed$ (timeMinInt, 2)
maxint$ = fixed$ (maxint, 0)
timeMaxInt$ = fixed$ (timeMaxInt, 2)
rangeInt$ = fixed$ (rangeInt, 0)
selectObject: pitch$
meanF0 = Get mean: 0, 0, "Hertz"
stdF0 = Get standard deviation: 0, 0, "Hertz"
minF0 = Get minimum: 0, 0, "Hertz", "Parabolic"
timeMinF0_s = Get time of minimum: 0, 0,"Hertz", "Parabolic"
timeMinF0 = timeMinF0_s/dur
maxF0 = Get maximum: 0, 0,"Hertz", "Parabolic"
timeMaxF0_s = Get time of maximum: 0, 0,"Hertz", "Parabolic"
timeMaxF0 = timeMaxF0_s/dur
rangeF0 = maxF0 - minF0
meanF0$ = fixed$ (meanF0, 0)
stdF0$ = fixed$ (stdF0, 2)	
minF0$ = fixed$ (minF0, 0)
timeMinF0$ = fixed$ (timeMinF0, 0)
maxF0$ = fixed$ (maxF0, 0)
timeMaxF0$ = fixed$ (timeMaxF0, 0)
rangeF0$ = fixed$ (rangeF0, 0)

selectObject: text$
#Insert interval tier 1 and write features
Insert interval tier: 1, "utterance(L1)"
feat1$ = "int(dB)" +intFeat$+ meanint$ + endFeat$
feat2$ = "stdint(dB)"+intFeat$+ stdint$ + endFeat$
feat3$ = "minInt(dB)"+intFeat$+ minint$ + endFeat$
feat4$ = "minIntT(norm)"+intFeat$+ timeMinInt$ + endFeat$
feat5$ = "maxInt(dB)"+intFeat$+ maxint$ + endFeat$
feat6$ = "maxIntT(norm)"+intFeat$+ timeMaxInt$ + endFeat$
feat7$ = "rangeInt(dB)"+intFeat$+ rangeInt$ + endFeat$
feat8$ =  "f0(Hz)"+intFeat$+ meanF0$ + endFeat$
feat9$ = "stdf0(Hz)"+intFeat$+ stdF0$ + endFeat$
feat10$ = "minF0(Hz)"+intFeat$+ minF0$ + endFeat$
feat11$ = "minF0T(norm)"+intFeat$+ timeMinF0$ + endFeat$
feat12$ = "maxF0(Hz)"+intFeat$+ maxF0$ + endFeat$
feat13$ = "maxF0T(norm)"+intFeat$+ timeMaxF0$ + endFeat$
feat14$ = "rangeF0(Hz)"+intFeat$+ rangeF0$ + endFeat$
feat15$ = "dur(sec)"+intFeat$+ dur$ 
## I am HERERrrrr
labeltext$ = startFeatLine$ + feat1$ + feat2$+ feat3$ + feat4$ + feat5$ + feat6$ + feat7$ + feat8$ + feat9$ + feat10$ + feat11$ + feat12$ + feat13$ + feat14$ + feat15$ +endFeatLine$
Set interval text: 1, 1, labeltext$

#############################################################
# Write features for voiced intervals at silence tier n.2
#############################################################
selectObject: text$
n_int = Get number of intervals: 2
count_sound = 0
count_sil = 0
for i from 1 to n_int
	selectObject: text$
	start[i] = Get starting point: 2, i
	end = Get end point: 2, i
	dur_pph = end - start[i]
	int_label$ = Get label of interval: 2, i
	
	selectObject: int$
	int_pph[i] = Get mean: start[i], end, "dB"
	stdint_pph[i] = Get standard deviation: start[i], end

	selectObject: pitch$
	f0_pph[i] = Get mean: start[i], end, "Hertz"
	stdF0_pph[i] = Get standard deviation: start[i], end, "Hertz"

	# Calculate z-scores of each pph (reference to extracted values from the whole sound)
	z_intpph = (int_pph[i] - meanint) / stdint
	z_f0pph = (f0_pph[i] - meanF0) / stdF0
	z_durpph = (dur_pph / dur)
	# Relative duration of interval compared to total duration of file (NB. not z-score)
	# Write features
	selectObject: text$
	# at voiced intervals
	if int_label$ == ""
		count_sound += 1
		count_sound$ = string$ (count_sound)
		z_intpph$ = fixed$ (z_intpph, 2)
		f0_pph$ = fixed$ (f0_pph[i], 2)
		stdF0_pph$ = fixed$ (stdF0_pph[i], 2)
		z_f0pph$ = fixed$ (z_f0pph, 2)
		dur_pph$ = fixed$ (dur_pph, 2)
		z_durpph$ = fixed$ (z_durpph, 2)
		featy1$ = "z_intpph" +intFeat$+ z_intpph$ + endFeat$
		featy2$ = "f0pph" +intFeat$+ f0_pph$ + endFeat$
		featy3$ = "stdf0pph" +intFeat$+ stdF0_pph$ + endFeat$
		featy4$ = "z_f0pph" +intFeat$+ z_f0pph$ + endFeat$
		featy5$ = "dur" +intFeat$+ dur_pph$ + endFeat$
		featy6$ = "rel_dur" +intFeat$+ z_durpph$ + endFeat$
		featy7$ = "pph_sil" +intFeat$+ count_sound$ + endFeat$
		lab1$ = Get label of interval: 2, i
		labeltext$ = lab1$ + startFeatLine$ + featy1$ + featy2$+ featy3$ + featy4$ + featy5$ + featy6$ + featy7$ 
		Set interval text: 2, i, labeltext$
	# at silence intervals
	else
		count_sil += 1
	endif
endfor

######################################################
# Write normalized features to IntensityPeak tier n.3
# relative to voiced segments
######################################################
selectObject: text$
n_points = Get number of points: 3
for i from 1 to n_points
	p_point = i - 1
	selectObject: text$
	time = Get time of point: 3, i
	i_sound = Get interval at time: 2, time

	selectObject: int$
	int_point = Get value at time: time, "Cubic"

	selectObject: pitch$
	f0_point = Get value at time: time, "Hertz", "Linear"

	# Calculate z-scores of each point (reference to extracted values from silence tier
	z_intpoint = (int_point - int_pph[i_sound]) / stdint_pph[i_sound]
	z_f0point = (f0_point - f0_pph[i_sound]) / stdF0_pph[i_sound]

	# Write features
	selectObject: text$
	z_intpoint$ = fixed$ (z_intpoint, 2)
	z_f0point$ = fixed$ (z_f0point, 2)
	int_p$ = fixed$ (int_point, 0)
	f0_p$ = fixed$ (f0_point, 0)
	start_pph = Get starting point: 2, i_sound
	end_pph = Get end point: 2, i_sound
	dur_pph = end_pph - start_pph
	timePoint = (time - start[i_sound])/dur_pph
	timePoint$ = fixed$ (timePoint, 2)
	dist$ = ""
	# Distance to previous point annotation
	if p_point > 0
		p_time = Get time of point: 3, p_point
		dist = time - p_time
		dist$ = fixed$ (dist, 2)
	else
	# Calculate the distance of the first syllable to the beginning of the voiced segment
		pph_int = Get interval at time: 2, time
		pph_time = Get starting point: 2, pph_int
		dist = time - pph_time
		dist$ = fixed$ (dist, 2)
	endif

	featz1$ = "int" + intFeat$ + int_p$ + endFeat$
	featz2$ = "f0"+ intFeat$ + f0_p$ + endFeat$
	featz3$ = "z_int"+ intFeat$ + z_intpoint$+ endFeat$
	featz4$ = "z_f0"+ intFeat$ + z_f0point$+ endFeat$
	featz5$ = "t_point"+ intFeat$ + timePoint$+ endFeat$
	featz6$ = "dist_p"+ intFeat$ + dist$
	lab3$ = Get label of point: 3, i 
	labeltext3$ = lab3$ + featz1$ + featz2$+ featz3$ + featz4$ + featz5$ + featz6$ + endFeatLine$
	Set point text: 3, i, labeltext3$
endfor


#########################################################
### Annotate features at IntensityValleys tier n.4
#########################################################
selectObject: text$
n_valls = Get number of points: 4
for i from 1 to n_valls
	p_vall = i - 1
	selectObject: text$
	time_v = Get time of point: 4, i
	i_pph = Get interval at time: 2, time_v
	# Extract pph count for array writen as feature pph_sil
	start_pph = Get starting point: 2, i_pph
	end_pph = Get end point: 2, i_pph
	dur_pph = end_pph - start_pph
	timePoint = (time_v- start[i_pph])/dur_pph
	timePoint$ = fixed$ (timePoint, 2)
	lab4$ = Get label of point: 4, i
	labeltext4$ =  lab4$ + startFeatLine$ + "t_point" + intFeat$ + timePoint$ + endFeat$
	Set point text: 4, i, labeltext4$

	selectObject: pitch$
	f0_vall = Get value at time: time_v, "Hertz", "Linear"
	
	
	# Calculate f0 z-scores if f0 value exists
	if f0_vall == undefined
		selectObject: text$
		lab2$ = Get label of point: 4, i
		labeltext2$ = lab2$ + "z_f0" + intFeat$ + "--undefined--" + endFeat$
		Set point text: 4,i, labeltext2$
	else 
		selectObject: text$
		z_f0vall = (f0_vall - f0_pph[i_sound]) / stdF0_pph[i_sound]
		z_f0vall$ = fixed$ (z_f0vall, 2)
		lab2$ = Get label of point: 4, i
		labeltext2$ = lab2$ + "z_f0" + intFeat$ + z_f0vall$ + endFeat$
		Set point text: 4,i, labeltext2$
	endif
	# Distance to previous point annotation
	if p_vall > 0
		selectObject: text$
		p_time = Get time of point: 4, p_vall
		dist = time_v - p_time
		dist$ = fixed$ (dist, 2)
		lab3$ = Get label of point: 4, i
		labeltext3$ = lab3$ + "dist_p" + intFeat$ +dist$ + endFeatLine$
		Set point text: 4,i, labeltext3$
	else
	# Calculate the distance of the first syllable to the beginning of the voiced segment
		pph_int = Get interval at time: 2, time_v
		pph_time = Get starting point: 2, pph_int
		dist = time_v - pph_time
		dist$ = fixed$ (dist, 2)
		lab3$ = Get label of point: 4, i
		labeltext3$ = lab3$ + "dist_p" + intFeat$ +dist$ + endFeatLine$
		Set point text: 4,i, labeltext3$			
	endif
endfor

# Save changes to directory
Write to text file: directory$ + basename$ + "_mod3.TextGridd"
endfor
# clean Menu
select all
Remove

appendInfoLine: "Module 3 completed!"
### END OF MODULE 3 #################