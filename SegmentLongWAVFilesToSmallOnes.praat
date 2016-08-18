# Praat script:  SegmentLongWAVFilesToSmallOnes.praat

# Author: Pengfei Shao <feipengshao@163.com>
# Version:  2014/5/28  14:16:00 
# Praat Version 6.0.19

# Purpose: Divide the discourse into slices according to the label of Tier
#		
# Requires: 
#		 
# Version History:
# 2014/5/28: Praat script is created.
##################################################
form dialogue
	comment 请输入源声音文件和标注文件所在目录：
	text openpath C:\Users\Administrator\Desktop\Test\ToDo\
	comment 请输入切分后声音保存目录：
	text savepath C:\Users\Administrator\Desktop\Test\Over
	comment 运行结束后产生一个文件名列表
	text saveTxtPath C:\Users\Administrator\Desktop\Test\list.txt
	comment 请输入标记所在层级及标记内容：
	positive tier_number 1
	sentence mark_string 
	optionmenu file_mark: 2
		option 原文件名+标注内容+序号
		option 原文件名+序号
	comment 请输入数字位数：
	positive limit 4
endform


if right$(openpath$,1)<>"\"
	openpath$=openpath$+"\"
endif
if right$(savepath$,1)<>"\"
	savepath$=savepath$+"\"
endif
createDirectory(savepath$)
tierNum=tier_number

saveTXTpath$=saveTxtPath$
filedelete 'saveTXTpath$'
fileappend 'saveTXTpath$' order'tab$'filename'tab$'sentence'newline$'


Create Strings as file list... fileList 'openpath$'*.wav
numofFiles=Get number of strings
for i from 1 to numofFiles
	select Strings fileList
	fileName$=Get string... 'i'
	order=1
	Read from file... 'openpath$''fileName$'
	nameOfFile$=fileName$-".wav"-".WAV"
	textgridNameOfFile$=nameOfFile$+".TextGrid"
	Read from file... 'openpath$''textgridNameOfFile$'
	select TextGrid 'nameOfFile$'

	numOfIntervals=Get number of intervals... 'tierNum'

	for j from 1 to numOfIntervals
		select TextGrid 'nameOfFile$'
		startTime=Get start point... 'tierNum' 'j'
		endTime=Get end point... 'tierNum' 'j'
		labelOfInterval$=Get label of interval... 'tierNum' 'j'
		#####
		if (labelOfInterval$=mark_string$ and mark_string$<>"") or (labelOfInterval$<>"" and mark_string$="" and labelOfInterval$<>"sil")

			#####将范围根据标的情况前后分别扩大0.2秒
			startTime1=startTime-0.3
			endTime1=endTime+0.3
			Extract part... 'startTime1' 'endTime1' no
			select Sound 'nameOfFile$'
			Extract part... 'startTime1' 'endTime1' rectangular 1 no
			select TextGrid 'nameOfFile$'_part

			temp=order
			ii=0
			repeat
				temp=temp div 10
				ii=ii+1
			until temp=0
			sumtemp=limit-ii
			mark$=""
			for jjj from 1 to sumtemp
				mark$=mark$+"0"
			endfor
			mark$=mark$+string$(order)

			if file_mark=1
				select Sound 'nameOfFile$'_part
				Write to WAV file... 'savepath$''nameOfFile$'_'labelOfInterval$''mark$'.wav
				fileappend 'saveTXTpath$' 'order''tab$''nameOfFile$'_'labelOfInterval$''mark$'.wav'newline$'
			endif
			if file_mark=2
				select Sound 'nameOfFile$'_part
				Write to WAV file... 'savepath$''nameOfFile$''mark$'.wav
				fileappend 'saveTXTpath$' 'order''tab$''nameOfFile$''mark$'.wav'tab$''labelOfInterval$''newline$'
			endif
			select TextGrid 'nameOfFile$'_part
			plus Sound 'nameOfFile$'_part
			Remove
			order=order+1			
		endif
	endfor
	select TextGrid 'nameOfFile$'
	plus Sound 'nameOfFile$'
	Remove
endfor
select Strings fileList
Remove
exit Over!
