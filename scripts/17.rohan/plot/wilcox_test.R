setwd("/data2/projects/dyao/compare/rohan/plot")


# 读取数据
dat <- read.table("merge.het.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")
dat_pachy <- dat$Pachycara_sp
dat_pho <- dat$Pholis_nebulosa
result <- wilcox.test(dat_pachy, dat_pho, alternative = "two.sided", exact = FALSE)
print(result)

dat_Dic <- dat$Dictyosoma_tongyeongensis
result_pachy_dic <- wilcox.test(dat_pachy, dat_Dic, alternative = "two.sided", exact = FALSE)
print(result_pachy_dic)



dat_Basso <- dat$Bassozetus_sp
dat_Bmul <- dat$Brotula_multibarbata
result_basso <- wilcox.test(dat_Basso, dat_Bmul, alternative = "two.sided", exact = FALSE)
print(result_basso)
