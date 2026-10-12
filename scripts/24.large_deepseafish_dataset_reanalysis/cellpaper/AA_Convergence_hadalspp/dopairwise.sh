module load clusterbasics
mkdir -p logs
php annotateAAchange_percentcutoff.php Pseudoliparis Coryphaenoides_yaquinae > logs/Pseudoliparis.Coryphaenoides_yaquinae.log 2>&1 & 
php annotateAAchange_percentcutoff.php Pseudoliparis Bathypterois_sp > logs/Pseudoliparis.Bathypterois_sp.log 2>&1 & 
php annotateAAchange_percentcutoff.php Coryphaenoides_yaquinae Bathypterois_sp > logs/Coryphaenoides_yaquinae.Bathypterois_sp.log 2>&1 & 
wait;
