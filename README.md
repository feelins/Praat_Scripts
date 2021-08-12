# Praat_Scripts 

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

[中文版](./README_cn.md)

This project includes some commonly used scripts of `Praat`, combined with simple examples to explain how to use these scripts, each independent directory contains sample files and result files, which are suitable for those who have some understanding of the basic operations of `Praat`, beginners who have a good understanding of basic acoustic parameters such as `Duration`, `fundamental frequency` and `formant`. 

The project includes the following:

1. Basic operation of `Praat`;
2. Operation of `Praat` on files, including annotation file `TextGrid` and audio file `wav`;
3. `Praat` operations on specific label information, such as `tier`, `interval`, including replacement, addition, delete, etc.;
4. Use `Praat` to extract the main acoustic parameters, `duration`, `fundamental frequency`, `formant`;
5. How to use these parameters to make a simple tone and intonation map; 

I hope to be helpful to the experimental phonetics beginners who get started with `Praat`, and more practical `Praat scripts` are being updated continuously.

## Background  

##### name  
>`Praat` means talking or talking in Dutch, and `doing phonetics by computer` means using computers to study phonetics. As the name of the software, it is translated into `Praat Phonetics Software` for simplicity.   

##### author  
>The authors of `Praat` are Professor Paul Boersma and Assistant Professor David Weenink, chair of the Institute of Speech Science, Faculty of Humanities, University of Amsterdam, the Netherlands.   

##### website
>[http://www.praat.org](http://www.praat.org)  


This part of the information comes from [Baidu.com] (https://baike.baidu.com/item/praat/7852897?fr=aladdin)。  

# How to use Praat-Scripts code on github

[https://github.com/feelins/Praat_Scripts](https://github.com/feelins/Praat_Scripts)

If you are familiar with code and script operations, you can download, install, and configure `github for windows` on your computer to download the code to this machine through `git clone`, and update the code in time with the main website. 
```shell
git clone https://github.com/feelins/Praat_Scripts.git
```

If you are not familiar with this operation, you can directly download all the codes of this site by clicking, `Code`-`Download ZIP`, downloading all the files in this project.  

Please read the description of each script on this page before use. If there are any errors or problems, you can consult the email in the script.

# Table of Contents  

* [01-resample_sound_files](01-resample_sound_files/Resample_Sound_Files.Praat)
* [02-get_file_names](02-get_file_names\Get_FileNames_of_One_Directory.Praat)
* [03-long_sound_file_split](03-long_sound_splits/Split_Long_Sound_Files.Praat)
* [04-replace_labels](04-replace_labels/Replace_Intervals.praat)
* [05-add_some_tiers](05-add_some_tiers/add_tiers.Praat)
* [06-modify_one_tier](06-modify_one_tier/add_remove_duplicate_set_tier.Praat)
* [07-compute_total_duration](07-compute_total_duration/Get_Duration_From_Sound_Files.praat)
* [08-get_duration_of_one_tier](08-get_duration_of_one_tier/Get_Duration_of_One_Tier.praat)
* [09-get_duration_and_pitch](09-get_duration_and_pitch/Get_Duration_and_Pitch.Praat)
* [10-get_duration_and_formant](10-get_duration_and_formant/Get_Duration_and_Formant.Praat)
* [11-draw_vowel_map](11-draw_vowel_map/Draw_Vowel_Map.Praat)
* [12-intonation_pattern_drawing](12-intonation_pattern/Get_Duration_and_Pitch_Sentence.Praat)
* [13-cut_silence](13-cut_silence/Cut_Wav_TextGrid.Praat)
* [14-useful_dynamic_menus](./14-helpful_customized_menu/)
* [16-compute_VC](16-compute_VC/Compute_Rythms_By_VC.Praat)
* [17-split_one_phoneme_into_two](17-split_one_phoneme_into_two/Split_One_Phoneme_into_Two.praat)
* [18-adjust_peak](18-adjust_peak/Adjust_Sound_Peak.Praat)
* [19-save_one_channel_sound_files](19-save_one_channel_sound_files/Save_Channel_Sound_Files.Praat)
* [20-stats_basic_infomation](20-stats_basic_infomation/Get_basic_infos.praat)
* [21-get_selected_files](21-get_selected_files/Get_Files_of_Selected_List.Praat)
* [22-get_duration_and_intensity](22-get_duration_and_intensity/Get_Duration_and_Intensity.Praat)
* [23-auto_annotation_01](23-auto_annotation_01/simple_auto_annotation.Praat)  
* [24-tobi_auto_annotation](24-tobi_auto_annotation)  
* [25-merge_tiers_of_different_dir](25_merge_tiers_of_different_dir/Merge_tiers_of_different_TextGrids.praat)  
* [26-auto_annotation_02](26_Easy_align/homepage.txt)
* [28_merge_sound_files](28_merge_sound_files/combo_sound_files.Praat)

# Run Script

After mastering the basic operation of `Praat`, you need to know how to run a script.   

1. Double click Praat.exe to open `Praat`.
<div align=center><img width="314" height="417" border="1px" src="images/praat_open.png"/></div>

2. Click `Praat`, `Open praat script...`，
<div align=center><img width="314" height="417" border="1px" src="images/praat_open_7.png"/></div>

3. Locate the script's directory you need to run, and select it.
<div align=center><img width="650" height="488" border="1px" src="images/praat_open_8.png"/></div>

4. Click `Run`, `Run`
<div align=center><img width="650" height="488" border="1px" src="images/praat_open_9.png"/></div>


