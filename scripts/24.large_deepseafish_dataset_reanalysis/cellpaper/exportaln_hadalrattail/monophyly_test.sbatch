#!/bin/bash
#SBATCH -p blade,gpu,himem,hugemem
#SBATCH -o slurmlog/monophylytest-%a.out
#SBATCH -e slurmlog/monophylytest-%a.err
#SBATCH -a 0-119
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

module load clusterbasics
mkdir -p genetrees_improved


php monophyly_test.php -N ${SLURM_ARRAY_TASK_COUNT} -f ${SLURM_ARRAY_TASK_ID}



