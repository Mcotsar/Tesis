
for i in {1..100}
do
    echo $i;
    python apemcc.py -t 10000 -f horiH_E$i -w 5
done;
