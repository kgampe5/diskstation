source=/volume1/photo_alt/BilderCanon1100D/
dest=/volume1/photo_alt/BilderCanonAllInOne
for file in $(find $source -type f ! -path "*eaDir*"); do
    newname=`exiv2 -g Exif.Image.DateTime -Pv $file | sed s/://g | sed "s/ /-/"`
    cp $file $dest/$newname-$(basename $file)
	echo "$file copied to $dest/$newname-$(basename $file)"
done