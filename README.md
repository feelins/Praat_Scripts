# Praat_Scripts 

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

该项目包括一些Praat常用脚本，并结合简单实例说明结合Praat进行语音实验的大概步骤，适用于已经对Praat基本操作有些了解，对时长，基频，共振峰等基本声学参数有所了解的初学者，所有的脚本操作都相当于Praat基本操作的批处理。  

该项目包括以下内容：

1. Praat对文件，包括标注文件、音频文件的操作；
2. Praat对具体的标注信息的操作，比如tier, interval操作；
3. 实例一：完成中文普通话四个声调图；
4. 实例二：完成元音分布图；
5. 实例三：完成平行语料句的语调对比图；

希望能够对想通过Praat入门实验语音学的初学者有所帮助。  

### Table of Contents

Some basic praat scripts. 每一个目录里，有每个脚本的详细说明。 

>Files:文件操作;  
>>`Get_FileNames_of_One_Directory.Praat`:提取一个目录里的文件名;  
>>`Resample_Sound_Files.Praat`:对目录里wav进行重新采样;  
>>`SegmentLongWAVFilesToSmallOnes.praat`:将长文件切分成小文件;  
>>`Files\Split_Long_Sound_Files_mn.praat`:将长文件切分成小文件;  

>Replace:  
>>`Replace_Intervals.praat`:替换标注里的信息  

>Tiers:  
>>`add_tiers.Praat`:只增加，而且可以增加很多层，以及指定增加的层是否是interval或者point  
>>`add_remove_duplicate_set_tier.Praat`:该脚本可以一次进行增加，删除，复制，修改层名称这四个操作  

>Extract:从标注里提取参数，基频，共振峰，时长等  
>>`Get_Duration_and_Formant.Praat`:提取时长和共振峰  
>>`Get_Duration_and_Pitch.Praat`:提取时长和基频10个点  
>>`Get_Duration_From_Sound_Files.praat`:提取目录里所有wavs的总时长  
>>`Get_Duration_of_One_Tier.praat`:提取某一层的所有interval的时长  

>DrawVowelMap:根据提取的大量共振峰数据，画出F1, F2的声学元音分布图  
>>`draw_vowel_map.Praat`:根据提取的大量共振峰数据，画出F1, F2的声学元音分布图  
<div align=center><img width="720" height="480" src="images/vowel.png"/></div>