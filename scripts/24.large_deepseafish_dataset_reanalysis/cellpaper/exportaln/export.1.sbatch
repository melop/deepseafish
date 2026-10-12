#!/bin/bash
#SBATCH -p himem,hugemem,gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

mkdir -p output

module load clusterbasics
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

for i in {98..101}; do
php exportAln_multiref_withorigseq.php -N 120 -f $i > slurmlog/export_slurm-${i}.out 2> slurmlog/export_slurm-${i}.err &
done
wait
exit

