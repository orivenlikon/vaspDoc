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
for enc in 0.1 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26 0.28 0.30
#for enc in 200 300 400 500 600 700
do
cat > INCAR <<!
SYSTEM = encutOpt
ENCUT = 500
ISTART = 0
ICHRGE =2

PREC = Medium

NELM = 100
NELMIN =5
NELMDL = -5
EDIFF = 1E-04

EDIFFG = -1E-02
NSW = 500
IBRION = 2
ISIF = 2
ISMEAR = 0
#SIGMA = 0.1
SIGMA= $enc
!
#PREC    = Medium  			#** low medium high normal accurate 

#ENCUT     = 300       		#**	default EMAX
#NELM      = 100           #** Max SCF steps,default value 40
#NELMIN    = 5             #** Min SCF steps,default value 2, suggest value 4-8
#NELMDL    = -5            #** relaxation step 
#EDIFF     = 1E-04         #** SCF energy convergence; eV 

#EDIFFG = -1E-02           #** Ionic convergence; eV/AA 
#NSW    = 500              #**  Max ionic steps 
#IBRION =  2               #**  Algorithm: 0-MD; 1-Quasi-New; 2-CG(conjugate gradient ) 
                          #
                          #
#ISIF   =  2               #**  Stress/relaxation: 2-Ions, 3-Shape/Ions/V, 7-Vol 
                          #
#ISYM   =  2              #*  Symmetry: 0=none; 2=GGA; 3=hybrids 
#ISMEAR =  0               #**  Gaussian smearing; metals:1 
                          #		-4 tetrahedron method without bloch -5 with bloch  
                          #
#SIGMA  =  0.1             #**  Smearing value in eV; metals:0.2 

echo "ENCUT= $enc eV"
Enc=$enc
for k in   4
do
cat > KPOINTS <<!
Automatic generation
0
Gama Centered
$k 	$k 	1
0.0 0.0 0.0
!
echo "k mesh = $k x $k x $k"
#qsub vasp.5.4.1.pbs
nohup mpirun  vasp > out &
sleep 3
T=$(grep "Elapsed time" OUTCAR | tail -n 1)
while [ -z "$T" ];do
	sleep 1
	T=$(grep "Elapsed time" OUTCAR | tail -n 1)
#       echo "t= $T"
done
E=$(grep "TOTEN" OUTCAR | tail -n 1)
KP=$(grep "irreducible" OUTCAR | tail -n 1)
SM=$(grep "EENTRO" OUTCAR | tail -n 1)
#echo "0" $Enc $k $KP $E $T >>EncutTest
#echo "0" $Enc $k $KP $E $T >>KpointTest
echo $Enc $SM $k $KP $E $T >> SigmaTest
done
done
