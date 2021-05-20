###########################################################################
#                                                                      	  #
#  Praat Script: PyToBI                     		                	  #
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
##### MODULE 2 ############################################################
###### Intensity valley detection			v.01						  #
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

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_mod1"
int$ = "Intensity " + basename$
intvall$ = "IntensityTier " + basename$

#Variables for writing features
startFeatLine$ = "{"
intFeat$ = "="
endFeat$ = ","
endFeatLine$ = "}"

# Create tier for valleys #4
selectObject: text$
Insert point tier: 3, "valleys"

## Extract intensity parameters of the whole sound
selectObject: int$
meanint = Get mean: 0, 0, "dB"
stdint = Get standard deviation: 0, 0

# Create an Intensity Valleys object
To IntensityTier (valleys)

n_vall = Get number of points
pre_z = 0
for i from 1 to n_vall
	selectObject: intvall$
	t = Get time from index: i
	value = Get value at index: i

	# Extract intensity parameters from reference voiced segment
	selectObject: text$
	whichintval = Get interval at time: 1, t
	pph_lab$ = string$ (whichintval)
	start = Get starting point: 1, whichintval
	end = Get end point: 1, whichintval
	pph$ = Get label of interval: 1, whichintval
	
	selectObject: int$
	int_pph = Get mean: start, end, "dB"
	stdint_pph = Get standard deviation: start, end

	# Calculate z-scores
	z_int = (value - int_pph) / stdint_pph
	z_int$ = fixed$ (z_int, 2)
	# I had commented z_all variables for some reason (con't remember right now). I decided to uncomment them as error occurred.
	z_all = (value - meanint)/ stdint
	z_all$ = fixed$(z_all, 2)
	# Annotate normalized features to selected intensity valleys
	if pph$ = ""
		if z_all < 0
			selectObject: text$
			labtext$ = pph_lab$ + startFeatLine$ +"z_int"+ intFeat$+ z_int$ + endFeat$ + "z_all"+ intFeat$+ z_all$
			Insert point: 3, t, labtext$
			ind = Get low index from time: 3, t
			# Check distance to previous point and z_int to decide which intensity valleys are created
			pre_ind = ind -1
			if pre_ind <> 0
				pre_t = Get time of point: 3, pre_ind
				dif_t = t - pre_t
				if dif_t < 0.20  
					if pre_z < z_int 
						Remove point: 3, ind
					else
						Remove point: 3, pre_ind
					endif
				endif
			endif
		endif
	endif
	pre_z = z_int
endfor 

# Save temporal file
selectObject: text$
Write to text file: directory$ + basename$ + "_mod2.TextGridd"
endfor
# clean Menu
select all
Remove

appendInfoLine: "Module 2 completed!"
#################### END OF MODULE 2 ####