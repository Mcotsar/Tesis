#script to run expe 
time=30001
exp=$1
mkdir $exp
echo "" > logsimulatsions
for m in "HT" "VT" "HTD";
do
	echo "Running simulation for model $m"
	mkdir "$exp"/"$m";
	for i in {1..200}; do 
        #echo sim$i ; 
        if [ $m == "HT" ]
        then

            a=-1
        fi
        if [ $m == "VT" ]
        then

            a=1
        fi
        if [ $m == "HTD" ]
        then

            a=.5
        fi
        echo $a
        echo $m
        python main.py -i file -w 5 -t $time -f "$exp"/"$m"/"$m"_"$i" -m -1  -a "$a" >> logsimulatsions
    done ; 
done
