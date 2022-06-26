#!/bin/bash
filelist="./backup.txt"
outputDir="./config/"

abs_filepath_prefix="/home/sultan"

# Check if filelist exists
if test ! -f $filelist
then
	echo "🚫 Filelist does not exist!"
	exit 1
fi

# Delete old backup
echo "🚮 Deleting old files.."
rm -rf $outputDir
mkdir $outputDir

# Create new backup
echo "🏁 Copying files.."

while read -r file
do
	# Convert relative to absolute path
	FILE="${file//\~/$abs_filepath_prefix}"

	# Skip the file if string is empty
	if [ -z $FILE ] 
	then
		continue
	fi
	
	# Check if file exists and the string is not empty
	if [ -f $FILE ]  
	then
		echo "	${file}"
		
		cp --recursive "${FILE}" "${outputDir}"
	else
		echo "	❌ File was not found${file}"
	fi
done < "$filelist"

echo "✅ Done!"
