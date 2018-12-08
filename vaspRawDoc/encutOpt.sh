#!/bin.sh
rm WAVECAR
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
E='grep "TOTEN" OUTCAR | tail -n 1' | awk'{printf "%12.6" \n", $5}''
eho $1 $E >>CencutTest
done