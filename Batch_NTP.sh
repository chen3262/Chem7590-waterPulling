# project name
#PBS -N Batch_NTP

# wall time hh:mm:ss
#PBS -l walltime=00:02:00

# nodes and processors
#PBS -l nodes=1:ppn=28

# output log file
#PBS -o NTP.log

# combine output and error in one log file
#PBS -j oe

# send email when job ends
#(Put your email addres in a file called ".forward" in your home dir.)
#PBS -m abe

# shell script
#PBS -S /bin/bash

# define folders for input and output
INP=$HOME/Chem7590/waterPulling
OUT=$INP/Output_NTP
if [ -d $OUT ];
then
   echo "Output folder $OUT exists."
   echo "Warning: contents may be overwritten!"
else
   echo "Output folder $OUT will be created."
   mkdir $OUT
fi
echo ------------------------------------------------------
echo 'contents of Input folder'
ls $INP
echo ------------------------------------------------------

# move data and executable to tmp folder
pbsdcp $INP/'*' $TMPDIR

# echo useful information

echo ------------------------------------------------------
echo -n 'Job is running on node '; cat $PBS_NODEFILEe
echo ------------------------------------------------------
echo PBS: qsub is running on $PBS_O_HOST
echo PBS: originating queue is $PBS_O_QUEUE
echo PBS: executing queue is $PBS_QUEUE
echo PBS: working directory is $PBS_O_WORKDIR
echo PBS: tmp directory is $TMPDIR
echo PBS: execution mode is $PBS_ENVIRONMENT
echo PBS: job identifier is $PBS_JOBID
echo PBS: job name is $PBS_JOBNAME
echo PBS: node file is $PBS_NODEFILE
echo PBS: current home directory is $PBS_O_HOME
echo PBS: PATH = $PBS_O_PATH
echo ------------------------------------------------------

# we will use gromacs
module load gromacs

# enter tmp folder
cd $TMPDIR
echo ------------------------------------------------------
echo 'contents of TMPDIR'
ls
echo ------------------------------------------------------

gmx grompp -f waterNTP.mdp -c water.gro -n water.ndx -p water.top -o NTP.tpr
gmx mdrun -v -deffnm NTP

# retrieve output
pbsdcp -g $TMPDIR/'NTP.*' $OUT
