module load gromacs

for i in 0 40 60 80 120 140
do 
	echo 0 | gmx trjconv -f GenConfig.trr -s GenConfig.tpr -b $i -e $i -o config_${i}ps.gro
done

