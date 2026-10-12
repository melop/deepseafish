
arrOutgroupSpp='Scleropages_formosus';
arrUnusedClades='root'; #c('Aplocheilidae', 'root'); #mark as unused clades "only for hyphy relax"
arrMarkUnusedCladeChildren='F'; #c(T , F);

module load R/4.3.0

#######################################################################
arrForegroundClades='Coryphaenoides_yaquinae'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Coryphaenoides_yaquinae.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="Relax_Coryphaenoides_yaquinae";

mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


#######################################################################
arrForegroundClades='Bathypterois_sp'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Bathypterois.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="Relax_Bathypterois_sp";

mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &



#######################################################################
arrForegroundClades='DeepseaCoryphaenoides'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Coryphaenoides.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="Relax_DeepseaCoryphaenoides";

mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


wait