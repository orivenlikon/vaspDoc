#!/bin/sh
#mv WAVECAR wave
for i in 150 200 250 300 350 400 450 500 550 600 
do
cat > INCAR <<!
SYSTEM = Copt
ENCUT = $i
ISTART = 0
ICHAGE = 2
ISMEAR = -5
PREC = Medium 
!
echo "ENCUT=$i eV"
qsub vasp.5.4.1.pbs
E=$(grep "TOTEN" OUTCAR)
echo $i $E >>encutTest
done