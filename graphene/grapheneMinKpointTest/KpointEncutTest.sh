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
#echo $Enc $k $KP $E $T >>EncutTest
echo $Enc $k $KP $E $T >>KpointTest
done
done
