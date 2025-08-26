sed '/^>/d' Pachycara.pseudo.cds_1.fa | tr -d '\n' > Pachycara.pseudo.cds_1_aglin.fa
sed -i '1s/^/>Pachy_pseudo_1\n/' Pachycara.pseudo.cds_1_aglin.fa
sed '/^>/d' Pachycara.pseudo.cds_2.fa | tr -d '\n' > Pachycara.pseudo.cds_2_aglin.fa
sed -i '1s/^/>Pachy_pseudo_2\n/' Pachycara.pseudo.cds_2_aglin.fa
