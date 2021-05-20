###########################################################################
#                                                                      	  #
#  Praat Script: PyToBI              			                       	  #
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
##### MODULE 4 ############################################################
###### Word and phone tiers export and feature annotation 		v.01	  #
###########################################################################
## NOTE: words need to be in a TextGrid with the same of the wav file

appendInfoLine: "Exporting TextGrid with words and phones alignment"

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

include proceed_std.praat

Read from file: directory$ + basename$ + ".TextGrid"
Read from file: directory$ + basename$ + "_mod3.TextGridd"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + ".Pitch"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_mod3"
words$ = "TextGrid " + basename$ 
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$
merged$ = "TextGrid merged"
wordtier$ = "TextGrid words"
phones$ = "TextGrid phones"

#Variables for writing features
startFeatLine$ = "{"
intFeat$ = "="
endFeat$ = ","
endFeatLine$ = "}"

# Export word tier to TextGrid
selectObject: words$
Extract one tier: 1
selectObject: words$
Extract one tier: 2
selectObject: wordtier$
plusObject: phones$
plusObject: text$
Merge

#######################################################################
# Correct intonational phrases with word alignment.
Remove tier: 2
Insert interval tier: 2, "IP"
dur = Get total duration
words = Get number of intervals: 5
for w to words
	selectObject: merged$
	lab_word$ = Get label of interval: 5, w
	if lab_word$ == ""
		start = Get starting point: 5, w
		end = Get end point: 5, w
		check01 = Get interval boundary from time: 2, start
		check02 = Get interval boundary from time: 2, end
		# add boundary check
		if start != 0 and end != dur
			if check01 == 0 and check02 == 0
				#appendInfoLine: "processing = ", w
				Insert boundary: 2, start
				Insert boundary: 2, end
				ip_int = Get low interval at time: 2, end
				Set interval text: 2, ip_int, "SIL"
			elif check01 != 0 and check02 == 0
				Insert boundary: 2, end
				ip_int= Get low interval at time: 2, end
				Set interval text: 2, ip_int, "SIL"
			elif check01 == 0 and check02 != 0
				Insert boundary: 2, start
				ip_int= Get high interval at time: 2, start
				Set interval text: 2, ip_int, "SIL"
			else
				ip_int= Get high interval at time: 2, start
				Set interval text: 2, ip_int, "SIL"
			endif
		elif end != dur and start == 0
			if check02 == 0
				Insert boundary: 2, end
				ip_int= Get low interval at time: 2, end
				Set interval text: 2, ip_int, "SIL"
			else
				ip_int= Get high interval at time: 2, start
				Set interval text: 2, ip_int, "SIL"
			endif
		elif start != 0 and end == dur
			if check01 == 0
				Insert boundary: 2, start
				ip_int= Get high interval at time: 2, start
				Set interval text: 2, ip_int, "SIL"
			else
				ip_int= Get high interval at time: 2, start
				Set interval text: 2, ip_int, "SIL"
			endif
		endif
	endif
endfor
#################################################
# Compute phone info at pph level
n_sil = Get number of intervals: 2
for x to n_sil
	selectObject: merged$
	checksil$ = Get label of interval: 2, x
	if checksil$ != "SIL"
		#appendInfoLine: "Entering interval = ", x
		start_pph = Get starting point: 2, x
		end_pph = Get end point: 2, x
		lab_pph$ = Get label of interval: 2, x
		time_pph = end_pph - start_pph
		part1 = Extract part: start_pph, end_pph, "yes"
		##################
		## Compute phone z-scores with respect to pph
		dev = 0
		mean = 0
		pho_count = 0
		phones_inpph = Get number of intervals: 6
		if phones_inpph > 3
			for y to phones_inpph
				selectObject: part1
				lab_pho$ = Get label of interval: 6, y
				#appendInfoLine: "Phone label = ", lab_pho$
				if lab_pho$ != ""
					pho_count += 1
					start_pho = Get starting point: 6, y
					end_pho = Get end point: 6, y
					dur_pho_pph[pho_count] = end_pho - start_pho
				endif
			endfor
			#compute mean and std for each pph using stored values in list dur_pho
			#appendInfoLine: "Mean = ", mean
			sqr_v = 0
			if pho_count != 0
				mean = time_pph / pho_count
				for z to pho_count
					sqr_add = (dur_pho_pph[z] - mean)^2
					sqr_v = sqr_v + sqr_add
				endfor
				if sqr_v != 0
					pre_calc = sqr_v / pho_count
					dev = sqrt (pre_calc)
				endif
			endif
		endif
		# write values to word
		if dev != 0 and mean != 0
			#write features
			selectObject: merged$
			#var$ = fixed$ (var, 2)
			mean$ = fixed$ (mean, 2)
			dev$ = fixed$ (dev, 2)
			pho_count$ = string$ (pho_count)
			featx1$ = "phone_mean"+ intFeat$ + mean$ +endFeat$
			featx2$ = "phone_std" + intFeat$ + dev$ + endFeat$
			featx3$ = "n_phones"+ intFeat$ + pho_count$
			labtextx$ = lab_pph$ + startFeatLine$ + featx1$ + featx2$ +featx3$ + endFeatLine$
			Set interval text: 2, x, labtextx$
#			count_phone = 0
#			dur_pho$ = ""
#			zdur_phone$ = ""
			# Write z_dur to phone
#			for a to pho_count
#				selectObject: merged$
#				zdur_phone = (dur_pho_pph[a] - mean) / dev
#				zdur_phone$ = fixed$ (zdur_phone, 2)
#				dur_pho$ = fixed$ (dur_pho_pph[a], 2)
#				time = Get end point: 6, a
				#appendInfoLine: "feature inserted = ", zdur_phone
#			endfor
# REVISAR AQUI############### ANTES ENTRABA EN EL FOR LOOP #############
#			if zdur_phone$ != ""
#				selectObject: merged$
#				point = Get low interval at time: 6, time
#				labp$ = Get label of interval: 6, point
#				featp1$ = "z_dur_pph" +intFeat$+ zdur_phone$ + endFeat$
#				featp2$ = "dur" +intFeat$+ dur_pho$ + endFeat$
#				labeltextp$ = labp$ + startFeatLine$ + featp1$ + featp2$ 
#				Set interval text: 6, point, labeltextp$
			endif
		endif
	endif
endfor

############################
## Compute word information
selectObject: merged$
totintWord = Get number of intervals: 5
for w to totintWord
	@intervalInfo: 5, w
	#appendInfoLine: "Current word is = ", labCheck$
	if lab$ != ""
		ipref = Get low interval at time: 2, end
		start_pph = Get starting point: 2, ipref
		end_pph = Get end point: 2, ipref
		selectObject: pitch$
		@featExtraction: "pitch"
#####################################
	# Compute slope of F0
		quart = (end-start)/4
		q3rd_start = start + (quart * 2)
		q3rd_end = start + (quart * 3)
		q2nd_start = start + quart
		q1stF0 = Get mean: start, q2nd_start, "Hertz"
		q2ndF0 = Get mean: q2nd_start, q3rd_start, "Hertz"
		q3rdF0 = Get mean: q3rd_start, q3rd_end, "Hertz"
		q4thF0 = Get mean: q3rd_end, end, "Hertz"
		
		quartiles[1] = q1stF0
		quartiles[2] = q2ndF0
		quartiles[3] = q3rdF0
		quartiles[4] = q4thF0
		exists = 0
		first = 0
		last = 0
		slopeTend = 0

		for index to 4 
			current = quartiles[index]
			if current != undefined
				if exists == 0
					first = current
					exists = 1
				else
					last = current
				endif
			endif
		endfor
		if first != 0 and last !=0
			slopeTend = last - first
		endif
		slopeTend$ = fixed$ (slopeTend, 2)
############## END OF SLOPE COMPUTATION #######################
## Write F0 features to interval
		selectObject: merged$

		featw1$ = "t_maxf0" + intFeat$ + t_relMax$ + endFeat$
		featw2$ = "z_f0" + intFeat$ + z_f0$ + endFeat$
		featw3$ = "rangeF0" + intFeat$ + rangeF0$ + endFeat$
		featw4$ = "slope" + intFeat$ + slopeTend$ + endFeat$
		labeltextw$ = lab$ + startFeatLine$ + featw1$ + featw2$ + featw3$ + featw4$
		
		labw$ = Set interval text: 5, w, labeltextw$
		

#################################

		selectObject: int$
		@featExtraction: "int"
		# Write intensity features
		selectObject: merged$
		w = Get low interval at time: 5, end
		featw5$ = "t_min" + intFeat$ + t_relMin$ + endFeat$
		featw6$ = "z_int" + intFeat$ + z_int$ + endFeat$
		featw7$ = "dur" + intFeat$ + dur$ + endFeat$
		exlabel$ = Get label of interval: 5, w
		labeltextw$ = exlabel$ + featw5$ + featw6$ + featw7$
		Set interval text: 5, w, labeltextw$ 

## Phone information 
######################################################		

		selectObject: merged$
		part2 = Extract part: start, end, "yes"
		phones_word = Get number of intervals: 6
		#appendInfoLine: "number of phones = ", phones_inpart
		if phones_word > 1
			dev = 0
			mean = dur / phones_word
			sqr_v = 0
			z_dur = 0
			z_dur$ = "0"
			for pho to phones_word
				selectObject: part2
				@intervalInfo: 6, pho
				dur[pho] = dur
				sustract = dur[pho] - mean
				sqr_add = (dur[pho] - mean)^2
				sqr_v = sqr_v + sqr_add
			endfor
			#compute mean and std for each pph using stored values in list dur[pho]
			if sqr_v != 0
				pre_calc = sqr_v / phones_word
				dev = sqrt (pre_calc)
			#else
			#	appendInfoLine: "sqr is = 0 due to sustract = ", sustract
			endif 
			# write z_score phone values to word
			if dev != 0
				# Write z_dur to phone
				for x to phones_word
					selectObject: part2
					time = Get end point: 6, x
					sustr = dur[x] - mean
					if sustr != 0
						z_dur = sustr / dev
						z_dur$ = fixed$ (z_dur, 2)
					endif
					selectObject: merged$
					point = Get low interval at time: 6, time
					labph1$ = Get label of interval: 6, point
					newlabph1$ = labph1$ + startFeatLine$ + "z_dur" + intFeat$ + z_dur$ + endFeatLine$
					Set interval text: 6, point, newlabph1$
					#appendInfoLine: "feature inserted = ", point
				endfor
#			else
#				selectObject: merged$
#				point = Get low interval at time: 6, time
#				labph$ = Get label of interval: 6, point
#				newlabph$ = labph$ + "z_dur" + intFeat$ + z_dur$ + endFeatLine$
#				Set interval text: 6, point, newlabph$
				#appendInfoLine: "Dev = 0 feature inserted = ", point, "lab = ", pho$		
			endif

			selectObject: merged$

			@intervalInfo: 5, w
			#appendInfoLine: "Current interval = ", w, " lab = ", lab$
			firstPhone = Get high interval at time: 6, start
			lastPhone = Get low interval at time: 6, end
			n_phones_i = (lastPhone - firstPhone) + 1
			n_phones_i$ = fixed$ (n_phones_i, 0)

			#appendInfoLine: "current phone = ", phone_end$
			featy1$ = "n_Phones"+intFeat$+ n_phones_i$

			labword2$ = Get label of interval: 5, w
			newlabword2$ = labword2$ + featy1$ + endFeatLine$
			Set interval text: 5, w, newlabword2$

		else
			selectObject: merged$
			labword3$ = Get label of interval: 5, w
			newlabword3$ = labword3$ + "n_Phones" + intFeat$ + "1" + endFeatLine$
			Set interval text: 5, w, newlabword3$
		endif
	endif
endfor

# Save changes to directory
selectObject: merged$
Write to text file: directory$ + basename$ + "_mod4.TextGridd"  
endfor
#clean Menu
select all
Remove

appendInfoLine: "····························································"
appendInfoLine: "Prosodic parameters have been successfully computed!"
appendInfoLine: "····························································"
appendInfoLine: "····························································"
#################### END OF MODULE 4 ####
