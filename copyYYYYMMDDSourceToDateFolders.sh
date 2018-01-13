source=/volume1/photo_alt/BilderCanonAllInOne
destination=/volume1/photo/allbydate
#destination2=/volume1/photo/KarstenHandy
for i in `ls $source/`; do
    if [ -f $source/$i ]; then
       year="$( echo $i | sed -r 's/^([0-9]{4}).*$/\1/g' )" 
       month="$( echo $i | sed -r 's/^([0-9]{4})([0-9]{2}).*$/\2/g' )"
       mkdir -p $destination/$year/$month/
       cp -n $source/$i $destination/$year/$month
	   #mv $source/$i $destination2
       echo $source/$i copied to $destination/$year/$month/$i #and moved to $destination2/
	fi
done
#sudo chown -R PhotoStation:PhotoStation $destination
#sudo chmod -R 775 $destination
