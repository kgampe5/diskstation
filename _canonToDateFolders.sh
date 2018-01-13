source=/volume1/photo/upload/Canon/
dest=/volume1/photo/allbydate
for file in $(find $source -type f ! -path "*eaDir*"); do
    newname=`exiv2 -g Exif.Image.DateTime -Pv $file | sed s/://g | sed "s/ /-/"`
    year="$( echo $newname | sed -r 's/^([0-9]{4}).*$/\1/g' )" 
    month="$( echo $newname | sed -r 's/^([0-9]{4})([0-9]{2}).*$/\2/g' )"
    mkdir -p $dest/$year/$month/
    cp $file $dest/$year/$month/$newname-$(basename $file)
	echo "$file copied to $dest/$year/$month/$newname-$(basename $file)"
done