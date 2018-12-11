#!/bin/sh

if [[ ! -f "WAVECAR" ]];then
touch cache
else
mv WAVECAR cache
fi
if [[ ! -f "OUTCAR" ]];then
touch OUTCARcache
else
mv OUTCAR OUTCARcache
fi
for i in 2 4 6 8 10
do
cat > KPOINTS <<!
Automatic generation
0
Gama Centered
$i 	$i 	$i
0.0 0.0 0.0
!
echo "k mesh = $i x $i x $i"
qsub vasp.5.4.1.pbs
sleep 2
T=$(grep "Elapsed time" OUTCAR | tail -n 1)
#echo "T= $T "
while [ -z "$T" ];do
	sleep 1
	T=$(grep "Elapsed time" OUTCAR | tail -n 1)
#       echo "t= $T"
done
E=$(grep "TOTEN" OUTCAR | tail -n 1)
KP=$(grep "irreducible" OUTCAR | tail -n 1)

echo $i $KP $E $T >> KpointTest
done