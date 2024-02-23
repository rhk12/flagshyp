#!/bin/bash
 
#### specify the job and project name
#SBATCH --job-name=flagshyp
#SBATCH --account=rhk12
 
#### specify the required resources
#SBATCH --account=open
#SBATCH --partition=open
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=128GB
#SBATCH --time=00:10:00
 
source ~/.bashrc
module load matlab
# Change to the directory containing the job file
cd $SLURM_SUBMIT_DIR

matlab -nodisplay -nosplash -nodesktop -r "FLagSHyP('y','strip_with_a_hole.dat');exit;"

