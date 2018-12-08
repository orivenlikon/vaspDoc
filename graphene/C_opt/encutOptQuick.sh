#!/bin/sh
if [[ ! -f "WAVECAR" ]];then
touch cache
else
mv WAVECAR cache
fi
for i in 150 200 250 300 350 400 450 500 550 600 
do
cat > INCAR <<!
SYSTEM = Copt
ENCUT = $i
ISTART = 0
ICHRGE =2
ISMEAR = -5
PREC = Accurate 
!
echo "ENCUT=$i eV"
qsub vasp.5.4.1.pbs
sleep 3
E=$(grep "TOTEN" OUTCAR | tail -n 1)
echo $i $E >>encutTest
done
