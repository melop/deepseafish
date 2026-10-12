#!/bin/bash
#SBATCH -p blade,gpu
#SBATCH -o slurmlog/monophylyrelax-%a.out
#SBATCH -e slurmlog/monophylyrelax-%a.err
#SBATCH -a 0-119
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

module load clusterbasics
mkdir -p genetrees_relaxed


php monophyly_test.php -m monophyly_desc.relaxed.txt -o genetrees_relaxed  -N ${SLURM_ARRAY_TASK_COUNT} -f ${SLURM_ARRAY_TASK_ID}



