# This Praat script will change the sample rate of all sound files in a given directory
# and save files with the new rate to another directory.
# (See the Praat manual for details on resampling.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2019.03.15 feelins[feipengshao@163.com] 

form ReSample sound files
   sentence Sound_file_extension .wav
   comment Directory path of input files:
   text input_directory  E:\003_ProgramLanguage\Praat_Scripts\01-resample_sound_files\wavs_48k\
   comment Directory path of resampled files (old files will be overwritten!):
   text output_directory  E:\003_ProgramLanguage\Praat_Scripts\01-resample_sound_files\wavs_16k\
   positive New_sample_rate_(Hz) 16000
   positive Precision_(samples) 50
   comment (See the Praat manual for details on resampling.)
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

createDirectory: output_directory$
Create Strings as file list: "fileList", input_directory$ + "*.wav"
numberOfFiles = Get number of strings
for ifile from 1 to numberOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("Sound", 1)
	Resample: new_sample_rate, precision
	Save as WAV file: output_directory$ + objectName$  + ".wav"
	Remove
	selectObject: "Sound " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!