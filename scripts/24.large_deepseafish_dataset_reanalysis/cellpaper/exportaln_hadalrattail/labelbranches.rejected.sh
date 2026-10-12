
arrOutgroupSpp='Scleropages_formosus';
arrUnusedClades='root'; #c('Aplocheilidae', 'root'); #mark as unused clades "only for hyphy relax"
arrMarkUnusedCladeChildren='F'; #c(T , F);

module load R/4.3.0
#######################################################################
arrForegroundClades='Pachycara'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Pachycara.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Pachycara";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#######################################################################
arrForegroundClades='Pseudoliparis'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Pseudoliparis.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Pseudoliparis";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#######################################################################
arrForegroundClades='Bassozetus'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Bassozetus.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Bassozetus";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


#######################################################################
arrForegroundClades='DeepseaBeryciformes'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_DeepseaBeryciformes.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_DeepseaBeryciformes";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


#######################################################################
arrForegroundClades='Anoplogaster_cornuta'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_singletip.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Anoplogaster_cornuta";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#######################################################################
arrForegroundClades='Macrourus_sp'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_singletip.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Macrourus_sp";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


#######################################################################
arrForegroundClades='DeepseaAulopiformes'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_DeepseaAulopiformes.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_DeepseaAulopiformes";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#######################################################################
arrForegroundClades='Ilyophis'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Ilyophis.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="rjtRelax_Ilyophis";

mkdir -p $sOutDIR
Rscript labelbranches.rjt.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &


wait
