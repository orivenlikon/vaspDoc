#!/bin/sh
if [[ ! -f "WAVECAR" ]];then
touch cache
else
mv WAVECAR cache
fi
for i in 150 200 250 300 350 400 450 500 550 600 
do
cat > encut <<!
SYSTEM = Copt
ENCUT = $i 
!
cat INCARcOpt encut > INCAR
echo "ENCUT=$i eV"
qsub vasp.5.4.1.pbs
sleep 10
E=$(grep "TOTEN" OUTCAR | tail -n 1)
echo $i $E >>encutTest
done
