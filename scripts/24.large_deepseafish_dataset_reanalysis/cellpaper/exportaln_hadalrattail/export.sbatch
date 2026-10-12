#!/bin/bash
#SBATCH -p blade
#SBATCH -o slurmlog/export_slurm-%a.out
#SBATCH -e slurmlog/export_slurm-%a.err
#SBATCH -a 0-119
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

mkdir -p output

module load clusterbasics
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15


php exportAln_multiref_withorigseq.php -N ${SLURM_ARRAY_TASK_COUNT} -f ${SLURM_ARRAY_TASK_ID} 

exit

