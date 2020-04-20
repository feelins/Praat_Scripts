# Praat_Scripts 

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

该项目包括一些Praat常用脚本，并结合简单实例说明结合Praat进行语音实验的大概步骤，适用于已经对Praat基本操作有些了解，对时长，基频，共振峰等基本声学参数有所了解的初学者，所有的脚本操作都相当于Praat基本操作的批处理。  

该项目包括以下内容：

1. Praat对文件，包括标注文件、音频文件的操作；
2. Praat对具体的标注信息的操作，比如tier, interval修改，增加，删除等操作；
3. 实例一：完成中文普通话四个声调图；
4. 实例二：完成元音分布图；
5. 实例三：完成平行语料句的语调对比图；

希望能够对想通过Praat入门实验语音学的初学者有所帮助。  

## 目录  

* [背景](#背景)
* [安装](#安装)
* [Praat基本操作](#Praat基本操作)
    * [打开保存](#打开保存)
    * [脚本运行](#脚本运行)
* [常用脚本](#常用操作)
    * [文件操作](#文件操作)
    * [标注内容](#标注内容)
    * [提取数据](#提取数据)
* [语音研究步骤](#语音研究步骤)
* [实例一_绘制中文声调图](#实例一_绘制中文声调图)
* [实例二_元音分布图](#实例二_元音分布图)
* [实例三_句子语调图](#实例三_句子语调图)
 

## 背景  

##### 命名  
        Praat在荷兰语中是说话或交谈的意思，而`doing phonetics by computer`即使用计算机研究语音学。作为软件的名称，简便起见，合起来翻译作`Praat`语音学软件。  

##### 作者  
Praat的作者是荷兰阿姆斯特丹大学人文学院语音科学研究所的主席保罗·博尔斯马（*Paul Boersma*）教授和大卫·威宁克（*David Weenink*）助教授。  

##### 版本  
Praat最早的版本发布于1993年。起初用户还无法自由地下载使用，但从2003年6月5日的4.1版起，作者取消了专门的授权并开放了绝大部分源代码。进一步，从2004年3月4日的4.2版起，作者开放了全部源代码，使Praat成为采用GNU通用公共许可证授权的开源软件。相隔短则一天，长则月余，作者就会发布最近修订的版本，消除旧的故障，增添新的功能。2007年12月10日发布了5.0版。  
Praat目前支持在多种计算机平台上运行，包括：  
* 作者为以上平台的用户提供已编译好的目标文件。高级用户还可以在其他操作系统平台上修改并编译源代码后运行Praat程序。
* Praat能够在图形和命令行两种用户界面下运行，但两种界面的目标文件（可执行文件）各自独立，以Windows版为例，即分为praat.exe和praatcon.exe两个可执行文件，其中后者只能通过命令行方式从控制台调用。

该部分信息来源于[百度百科-Praat](https://baike.baidu.com/item/praat/7852897?fr=aladdin)。

## 安装  

Praat官方网站[http://www.fon.hum.uva.nl/praat/](http://www.fon.hum.uva.nl/praat/)，请根据自己的系统下载Windows, Mac, 或者Linux等版本，下载到本地电脑之后，双击打开**Praat.exe**就可以使用，无需安装。另外为了更好的体验IPA等特殊符号的标注，需要将安装页面的**Phonetic and international symbols**也一并安装，具体方法网站都有详细说明。请尽量使用最新版本。官方网站也提供了英文版的使用说明，以及很多的脚本，由于每个人完成实验的设计，目的等都不相同，所以很多脚本需要对Praat脚本语法比较熟悉才能灵活使用。  

## Praat基本操作

已经对Praat操作熟悉的，可跳过此部分。

##### 打开保存
1.  打开软件，双击已经下载的Praat.exe  
<div align=center><img width="314" height="417" border="1px" src="images/praat_open.png"/></div>

2. 点击Open, Read from file...，从弹出的对话框里找到要打开的标注文件(.TextGrid)或者音频文件(.wav)，再选择打开，这里可以选择多个文件同时打开
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_2.png"/></div>

3. 在没有标注文件的时候，可以选择打开的音频文件，选择右侧的Annotate， To TextGrid...， 可以创建新的标注层
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_3.png"/></div>

4. 如图所示，我们创建两层，一层是word层，一层是phoneme层，此外命名可自定义
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_4.png"/></div>

5. 这时，主窗口就会有一对同样名字的文件，一个是音频文件，一个是标注文件，同时选中这两个文件，再点右侧的View & Edit，这时会打开标注窗口，音频文件在上方，会显示出声波图和频谱图，下方是标注区域，即是新建的TextGrid文件，并有两层，Word和Phoneme层，先用鼠标找到合成的声音边界位置，再用鼠标点击如图位置的小圆点，则会增加一个边界，两个边界之间可以填写标注内容，如图，标注了前三个汉字部分
<div align=center><img width="922" height="495" border="1px" src="images/praat_open_5.png"/></div>

<sup>注: 示例所使用数据为[标贝开源女声数据](https://www.data-baker.com/open_source.html)</sup>

6. 每一句标注完成之后，回到主窗口，这时的标注文件并未自动保存，需要点击Save, Save as text file...，保存到相应的位置
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_6.png"/></div>

7. 标注文件可以采用重复以上步骤二次打开，再次修改等操作，其它详细的操作，都可以参考社科院熊子瑜老师的《Praat 语音软件使用手册》

##### 脚本运行

在掌握了Praat的基本操作之后，要知道如何运行一个脚本。  

1. 先打开Praat软件
<div align=center><img width="314" height="417" border="1px" src="images/praat_open.png"/></div>

2. 点击Praat, Open praat script...，
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_7.png"/></div>

3. 找到需要打开的脚本，这里用简单的例子，[`test/test.Praat`](test/test.Praat)，这个脚本只有一句话，是在屏幕上打印Hello World!
<div align=center><img width="400" height="300" border="1px" src="images/praat_open_8.png"/></div>

4. 点击这个窗口的Run, Run
<div align=center><img width="400" height="300" border="1px" src="images/praat_open_9.png"/></div>

5. 脚本运行的结果是显示一句话，Hello World!，代表脚本运行成功
<div align=center><img width="400" height="300" border="1px" src="images/praat_open_10.png"/></div>

## 常用脚本  

##### 文件操作  
1. [`Get_FileNames_of_One_Directory.Praat`](Files/Get_FileNames_of_One_Directory.Praat)：提取一个目录里的文件名，保存为一个文件；
2. [`Resample_Sound_Files.Praat`](Files/Resample_Sound_Files.Praat)：对音频文件重采样；
3. [`SegmentLongWAVFilesToSmallOnes.Praat`](Files/SegmentLongWAVFilesToSmallOnes.Praat)：将长文件切分成小文件；  

##### 标注内容  
1. [`Replace_Intervals.Praat`](Replace/Replace_Intervals.Praat)：批量替换标注里的信息；
2. [`add_tiers.Praat`](Tiers/add_tiers.Praat)：只增加，而且可以增加很多层，以及指定增加的层是否是interval或者point；
3. [`add_remove_duplicate_set_tier.Praat`](Tiers/add_remove_duplicate_set_tier.Praat)：该脚本可以一次进行增加，删除，复制，修改层名称这四个操作；

##### 提取数据    
1. [`Get_Duration_and_Formant.Praat`](Extract/Get_Duration_and_Formant.Praat):提取时长和共振峰  
2. [`Get_Duration_and_Pitch.Praat`](Extract/Get_Duration_and_Pitch.Praat):提取时长和基频10个点  
3. [`Get_Duration_From_Sound_Files.praat`](Extract/Get_Duration_From_Sound_Files.Praat):提取目录里所有wavs的总时长  
4. [`Get_Duration_of_One_Tier.praat`](Extract/Get_Duration_of_One_Tier.Praat):提取某一层的所有interval的时长  

>DrawVowelMap:根据提取的大量共振峰数据，画出F1, F2的声学元音分布图  
>>`draw_vowel_map.Praat`:根据提取的大量共振峰数据，画出F1, F2的声学元音分布图  
<div align=center><img width="720" height="480" src="images/vowel.png"/></div>

## 实例一_绘制中文声调图

## 实例二_元音分布图

## 实例三_句子语调图