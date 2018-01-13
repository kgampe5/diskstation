# get .jpg or .mp4 files recursively from source, extract date information 
# from filename or EXIF and copy them to destination/year/month folders if not already there
if [ -z "$1" ]; then 
  echo "Parameter Error: Usage: copyExifJPEGSourceToDateFolders [sourcepath] [destinationpath]"
  exit 1
fi
if [ -z "$2" ]; then 
  echo "Parameter Error: Usage: copyExifJPEGSourceToDateFolders [sourcepath] [destinationpath]"
  exit 1
fi
source=$1
dest=$2
IFS=$'\n'
for file in $(find $source -type f \( -name "*.jpg" -o -name "*.JPG" \) ! -path "*eaDir*"); do
    newname=`exiv2 -g Exif.Image.DateTime -Pv $file | sed s/://g | sed "s/ /-/"`
	oldname=$(basename $file)
	if [ -z "$newname" ]; then 
      datetmp="$( echo $oldname | sed -r 's/([0-9]{4})[-_ ]([0-9]{2})[-_ ]([0-9]{2}.*$)/\1\2\3/g' )"
      year="$( echo $datetmp | sed -r 's/^[A-Za-z-]*([0-9]{4})([0-9]{2}).*$/\1/g' )" 
      month="$( echo $datetmp | sed -r 's/^[A-Za-z-]*([0-9]{4})([0-9]{2})([0-9]{2}).*$/\2/g' )"
	  newfilename=$( echo "$oldname" )
    else 
      year="$( echo $newname | sed -r 's/^([0-9]{4}).*$/\1/g' )" 
      month="$( echo $newname | sed -r 's/^([0-9]{4})([0-9]{2}).*$/\2/g' )"
 	  newfilename=$( echo "$oldname" )
    fi
    mkdir -p $dest/$year/
	chown PhotoStation:PhotoStation $dest/$year/
    chmod 775 $dest/$year/
    mkdir -p $dest/$year/$month/
	chown PhotoStation:PhotoStation $dest/$year/$month
    chmod 775 $dest/$year/$month
    cp -n $file $dest/$year/$month/$newfilename
	chown PhotoStation:PhotoStation $dest/$year/$month/$newfilename
    chmod 775 $dest/$year/$month/$newfilename
	echo "JPEG: $file copied to $dest/$year/$month/$newfilename"
done

for file in $(find $source -type f \( -regextype posix-extended -regex '^.*([0-9]{4})[-_ ]*([0-9]{2})[-_ ]*([0-9]{2}).*$' \) ! -path "*eaDir*" ! -name "*.jpg" ! -name "*.JPG" ); do
	oldname=$(basename $file)
    datetmp="$( echo $oldname | sed -r 's/^.*([0-9]{4})[-_ ]([0-9]{2})[-_ ]([0-9]{2}.*$)/\1\2\3/g' )"
    year="$( echo $datetmp | sed -r 's/^[A-Za-z-]*([0-9]{4})([0-9]{2})([0-9]{2}).*$/\1/g' )" 
    month="$( echo $datetmp | sed -r 's/^[A-Za-z-]*([0-9]{4})([0-9]{2})([0-9]{2}).*$/\2/g' )"
    mkdir -p $dest/$year/$month/
	chown PhotoStation:PhotoStation $dest/$year/$month
    chmod 775 $dest/$year/$month
    mkdir -p $dest/$year/
	chown PhotoStation:PhotoStation $dest/$year
    chmod 775 $dest/$year/$month
    cp -n $file $dest/$year/$month/$oldname
	chown PhotoStation:PhotoStation $dest/$year/$month/$oldname
    chmod 775 $dest/$year/$month/$oldname
	echo "MP4: $file copied to $dest/$year/$month/$oldname"
done

mkdir -p $dest/_problems 
chown PhotoStation:PhotoStation $dest/_problems
chmod 775 $dest/_problems
mv $dest/*.jpg $dest/_problems 2>/dev/null
IFS=$' '
