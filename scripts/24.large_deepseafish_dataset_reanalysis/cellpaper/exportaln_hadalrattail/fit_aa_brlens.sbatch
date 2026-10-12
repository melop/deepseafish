#!/bin/bash
#SBATCH -p blade,gpu,himem,hugemem
#SBATCH -o slurmlog/fitaabrlen-%a.out
#SBATCH -e slurmlog/fitaabrlen-%a.err
#SBATCH -a 0-119
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

module load clusterbasics
mkdir -p genetrees_improved


php fit_aa_brlens.php -N ${SLURM_ARRAY_TASK_COUNT} -f ${SLURM_ARRAY_TASK_ID}



