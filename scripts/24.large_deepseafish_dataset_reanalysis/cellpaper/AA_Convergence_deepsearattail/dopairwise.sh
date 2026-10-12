module load clusterbasics
mkdir -p logs
php annotateAAchange_percentcutoff.php Pachycara Pseudoliparis > logs/Pachycara.Pseudoliparis.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara Bassozetus > logs/Pachycara.Bassozetus.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara DeepseaBeryciformes > logs/Pachycara.DeepseaBeryciformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara Anoplogaster > logs/Pachycara.Anoplogaster.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara DeepseaCoryphaenoides > logs/Pachycara.DeepseaCoryphaenoides.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara DeepseaAulopiformes > logs/Pachycara.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pachycara Ilyophis > logs/Pachycara.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis Bassozetus > logs/Pseudoliparis.Bassozetus.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis DeepseaBeryciformes > logs/Pseudoliparis.DeepseaBeryciformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis Anoplogaster > logs/Pseudoliparis.Anoplogaster.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis DeepseaCoryphaenoides > logs/Pseudoliparis.DeepseaCoryphaenoides.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis DeepseaAulopiformes > logs/Pseudoliparis.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis Ilyophis > logs/Pseudoliparis.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php Bassozetus DeepseaBeryciformes > logs/Bassozetus.DeepseaBeryciformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Bassozetus Anoplogaster > logs/Bassozetus.Anoplogaster.log 2>&1 & 
php annotateAAchange_percentcutoff.php Bassozetus DeepseaCoryphaenoides > logs/Bassozetus.DeepseaCoryphaenoides.log 2>&1 & 
php annotateAAchange_percentcutoff.php Bassozetus DeepseaAulopiformes > logs/Bassozetus.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Bassozetus Ilyophis > logs/Bassozetus.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaBeryciformes Anoplogaster > logs/DeepseaBeryciformes.Anoplogaster.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaBeryciformes DeepseaCoryphaenoides > logs/DeepseaBeryciformes.DeepseaCoryphaenoides.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaBeryciformes DeepseaAulopiformes > logs/DeepseaBeryciformes.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaBeryciformes Ilyophis > logs/DeepseaBeryciformes.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php Anoplogaster DeepseaCoryphaenoides > logs/Anoplogaster.DeepseaCoryphaenoides.log 2>&1 & 
php annotateAAchange_percentcutoff.php Anoplogaster DeepseaAulopiformes > logs/Anoplogaster.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php Anoplogaster Ilyophis > logs/Anoplogaster.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaCoryphaenoides DeepseaAulopiformes > logs/DeepseaCoryphaenoides.DeepseaAulopiformes.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaCoryphaenoides Ilyophis > logs/DeepseaCoryphaenoides.Ilyophis.log 2>&1 & 
php annotateAAchange_percentcutoff.php DeepseaAulopiformes Ilyophis > logs/DeepseaAulopiformes.Ilyophis.log 2>&1 & 
wait;
