genome=/data/projects/dyao/Data/youwei/03_nextpolish/purge/youwei_curated.fasta

genome=`realpath $genome`

mkdir -p references
ln -sf $genome references/ref.fa
bwa index references/ref.fa
fastahack -i references/ref.fa

mkdir -p restriction_sites
cut -f1,2 references/ref.fa.fai > restriction_sites/ref.chrom.sizes

cd restriction_sites
python /data/software/juicer/misc/generate_site_positions.py DpnII ref ../references/ref.fa

