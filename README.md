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

## 目录  

* [背景](#背景)
* [安装](#安装)
* [常用脚本](#常用操作)
    * [文件操作](#文件操作)
    * [标注内容](#标注内容)
    * [提取数据](#提取数据)
* [实例一](#实例一)
* [实例二](#实例二)
* [实例三](#实例三)
 

## 背景  

##### 命名  
Praat在荷兰语中是说话或交谈的意思，而doing phonetics by computer即使用计算机研究语音学。作为软件的名称，简便起见，合起来翻译作Praat语音学软件。  
##### 作者  
Praat的作者是荷兰阿姆斯特丹大学人文学院语音科学研究所的主席保罗·博尔斯马（Paul Boersma）教授和大卫·威宁克（David Weenink）助教授。  
##### 版本  
Praat最早的版本发布于1993年。起初用户还无法自由地下载使用，但从2003年6月5日的4.1版起，作者取消了专门的授权并开放了绝大部分源代码。进一步，从2004年3月4日的4.2版起，作者开放了全部源代码，使Praat成为采用GNU通用公共许可证授权的开源软件。相隔短则一天，长则月余，作者就会发布最近修订的版本，消除旧的故障，增添新的功能。2007年12月10日发布了5.0版。  
Praat目前支持在多种计算机平台上运行，包括：  
* 作者为以上平台的用户提供已编译好的目标文件。高级用户还可以在其他操作系统平台上修改并编译源代码后运行Praat程序。
* Praat能够在图形和命令行两种用户界面下运行，但两种界面的目标文件（可执行文件）各自独立，以Windows版为例，即分为praat.exe和praatcon.exe两个可执行文件，其中后者只能通过命令行方式从控制台调用。

该部分信息来源于[百度百科-Praat](https://baike.baidu.com/item/praat/7852897?fr=aladdin)

## 安装  

Praat官方网站[http://www.fon.hum.uva.nl/praat/](http://www.fon.hum.uva.nl/praat/)，请根据自己的系统下载Windows, Mac, 或者Linux等版本，下载到本地电脑之后，双击打开**Praat.exe**就可以使用，无需安装。另外为了更好的体验IPA等特殊符号的标注，需要将安装页面的**Phonetic and international symbols**也一并安装，具体方法网站都有详细说明。请尽量使用最新版本。官方网站也提供了英文版的使用说明，以及很多的脚本，由于每个人完成实验的设计，目的等都不相同，所以很多脚本需要对Praat脚本语法比较熟悉才能灵活使用。  

## 常用脚本  


#### 文件操作  
1. 提取一个目录里的文件名，保存为一个文件，[Get_FileNames_of_One_Directory.Praat](Files/Get_FileNames_of_One_Directory.Praat)
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