# This Praat script will draw the map of vowels in a given txt which shows the result of the F1, F2
# 利用提取的共振峰F1,F2画声学元音图
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.06.25 feelins[feipengshao@163.com]
# e.g.
# TXT:
# label	F1	F2
# u	320	630
# a	780	1300
# o	500	940
# \as	720	1060
# \o/	430	1580
# i	280	2300

form Dialogue
	comment Directory path of input TXT files：
	text open_path /home/shaopf/study/Praat_Scripts/DrawVowelMap/
	text txt_file_name test.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

Read Table from tab-separated file: open_path$ + txt_file_name$
txt_columns = Get number of columns
txt_rows=Get number of rows

for i from 1 to txt_columns	
	label_col'i'$=Get column label... 'i'
	for j from 1 to txt_rows
		temp_label_col$=label_col'i'$
		value_'j'_'i'$=Get value... 'j' 'temp_label_col$'
	endfor
endfor

save_TableOfReal_TXT_path$=open_path$+"temp_result_TXT.txt"
filedelete 'save_TableOfReal_TXT_path$'
for i from 1 to txt_rows
	for j from 2 to txt_columns-1
		
		temp_value$=value_'i'_'j'$
		fileappend 'save_TableOfReal_TXT_path$' 'temp_value$''tab$'
	endfor
	temp_value$=value_'i'_'txt_columns'$
	fileappend 'save_TableOfReal_TXT_path$' 'temp_value$'
	fileappend 'save_TableOfReal_TXT_path$' 'newline$'
endfor

Read Matrix from raw text file... 'save_TableOfReal_TXT_path$'
To TableOfReal
Rename... table

Set column label (index)... 1 F1
Set column label (index)... 2 F2

number_of_TableOfReal=Get number of rows
for mj from 1 to number_of_TableOfReal
	temp_value$=value_'mj'_1$
	Set row label (index)... 'mj' 'temp_value$'
endfor


Save as text file... 'open_path$'table.TableOfReal

##Read from file... 'open_path$'test11.TableOfReal
Erase all
Black
# draw a vowel chart axis, with the F1 F2 in bark scale
Axes... -17.6 -4 -10.1 -1.07
Marks top... 25 no yes no
Marks right... 15 no yes no
Marks bottom... 25 no yes no
Marks left... 15 no yes no
One mark top... -4.96 no yes no 500
Draw line... -4 -1.07 -4 -10.1
Grey
Dotted line

Draw line... -4.96 -1.07 -4.96 -10.1
One mark top... -8.51 no yes no 1000
Draw line... -8.51 -1.07 -8.51 -10.1
One mark top... -11.01 no yes no 1500
Draw line... -11.01 -1.07 -11.01 -10.1
One mark top... -12.90 no yes no 2000
Draw line... -12.90 -1.07 -12.90 -10.1
One mark top... -14.40 no yes no 2500
Draw line... -14.40 -1.07 -14.40 -10.1
One mark top... -15.64 no yes no 3000
Draw line... -15.64 -1.07 -15.64 -10.1
One mark top... -17.6 no yes no 4000
Black
Solid line
Draw line... -17.6 -1.07 -17.6 -10.1

One mark right... -1.0727194795687742 no yes  no 100
Draw line... -4 -1.0727194795687742 -17.6 -1.0727194795687742
One mark right... -2.1212316490751526 no yes  no 200
Grey
Dotted line
Draw line... -4 -2.1212316490751526 -17.6 -2.1212316490751526
One mark right... -3.1258431985277 no yes  no 300
Draw line... -4 -3.1258431985277 -17.6 -3.1258431985277
One mark right... -4.0738057650062896 no yes  no 400
Draw line... -4 -4.0738057650062896 -17.6 -4.0738057650062896
One mark right... -4.959225904852174 no yes  no 500
Draw line... -4 -4.959225904852174 -17.6 -4.959225904852174
One mark right... -5.78145230923569 no yes  no 600
Draw line... -4 -5.78145230923569 -17.6 -5.78145230923569
One mark right... -6.543139124204025 no yes  no 700
Draw line... -4 -6.543139124204025 -17.6 -6.543139124204025
One mark right... -7.248661411356835 no yes  no 800
Draw line... -4 -7.248661411356835 -17.6 -7.248661411356835
One mark right... -7.9030508812698015 no yes  no 900
Draw line... -4 -7.9030508812698015 -17.6 -7.9030508812698015
One mark right... -8.51137148802024 no yes  no 1000
Draw line... -4 -8.51137148802024 -17.6 -8.51137148802024
One mark right... -9.078395930261458 no yes  no 1100
Draw line... -4 -9.078395930261458 -17.6 -9.078395930261458
One mark right... -9.60846490862398 no yes  no 1200
Draw line... -4 -9.60846490862398 -17.6 -9.60846490862398
One mark right... -10.105448326251672 no yes  no 1300
Black
Solid line
Draw line... -4 -10.105448326251672 -17.6 -10.105448326251672

;One mark right... -11 no yes  no 1500
# draw scatter plots of the vowel samples
select TableOfReal table
Formula... if col = 2 then hertzToBark(self)*(-1) else self fi
Formula... if col = 1 then hertzToBark(self)*(-1) else self fi

##############画出所有数据点############
Draw scatter plot... 2 1 0 0 -17.6 -4 -10.1 -1.07 8 yes + no
########################################

# draw ellipses
To Discriminant
Blue

Draw confidence ellipses... 0.95 no 2 1 -17.6 -4 -11 -1.07 18 no
select all
Remove
#==================================================================#