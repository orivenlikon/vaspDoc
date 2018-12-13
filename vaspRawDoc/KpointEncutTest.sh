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
for enc in 350
do
cat > INCAR <<!
SYSTEM = encutOpt
ENCUT = $enc
ISTART = 0
ICHRGE =2
ISMEAR = -5
PREC = Accurate 

!
echo "ENCUT= $enc eV"
Enc=$enc
for k in  2 3 4 5 6 7 8 9 10
do
cat > KPOINTS <<!
Automatic generation
0
Gama Centered
$k 	$k 	$k
0.0 0.0 0.0
!
echo "k mesh = $k x $k x $k"
qsub vasp.5.4.1.pbs
sleep 3
T=$(grep "Elapsed time" OUTCAR | tail -n 1)
while [ -z "$T" ];do
	sleep 1
	T=$(grep "Elapsed time" OUTCAR | tail -n 1)
#       echo "t= $T"
done
E=$(grep "TOTEN" OUTCAR | tail -n 1)
KP=$(grep "irreducible" OUTCAR | tail -n 1)
echo $Enc $k $KP $E $T >>kpointOrEncutTest
done
done
