setwd("/data2/projects/dyao/compare/rohan/plot")


library(ggplot2)
library(tidyr)
library(dplyr)

# 读取数据
dat <- read.table("merge.het.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

# 将数据转换为长格式
dat_long <- pivot_longer(dat, 
                         cols = everything(), 
                         names_to = "Species", 
                         values_to = "Value")

# 计算箱型图所需的统计量
stats <- dat_long %>%
  group_by(Species) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    Median = median(Value, na.rm = TRUE),
    Q1 = quantile(Value, 0.25, na.rm = TRUE),
    Q3 = quantile(Value, 0.75, na.rm = TRUE),
    Min = min(Value, na.rm = TRUE),
    Max = max(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE)
  )

# 输出计算的统计量
print(stats)

# 使用 ggplot2 绘制箱型图
ggplot(dat_long, aes(x = Species, y = Value, fill = Species)) + 
  geom_boxplot() + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Boxplot of Species Values", y = "Value", x = "Species")






# 读取数据
dat <- read.table("merge.het.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

# 将数据转换为长格式
dat_long <- pivot_longer(dat, 
                         cols = everything(), 
                         names_to = "Species", 
                         values_to = "Value")

# 计算箱型图所需的统计量
stats <- dat_long %>%
  group_by(Species) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    Median = median(Value, na.rm = TRUE),
    Q1 = quantile(Value, 0.25, na.rm = TRUE),
    Q3 = quantile(Value, 0.75, na.rm = TRUE),
    Min = min(Value, na.rm = TRUE),
    Max = max(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE)
  )

# 输出计算的统计量
print(stats)

# 使用 ggplot2 绘制横向的箱型图
ggplot(dat_long, aes(y = Species, x = Value, fill = Species)) + 
  geom_boxplot() + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.y = element_text(angle = 0, hjust = 1)) +  # 调整y轴标签的角度
  labs(title = "Boxplot of Species Values", y = "Species", x = "Value")

# 使用 ggplot2 绘制横向的箱型图，并调整箱体宽度和位置
ggplot(dat_long, aes(y = Species, x = Value, fill = Species)) + 
  geom_boxplot(width = 0.5, position = position_dodge(width = 0.5)) +  # 调整箱体宽度和位置
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.y = element_text(angle = 0, hjust = 1),  # 调整y轴标签的角度
    panel.grid.major = element_blank(),  # 去掉主网格线
    panel.grid.minor = element_blank(),  # 去掉次网格线
    panel.border = element_blank(),      # 去掉面板边框
    axis.line = element_line(color = "black")  # 只保留x轴和y轴的线
  ) + 
  labs(title = "Boxplot of Species Values", y = "Species", x = "Value")









# 读取数据
dat <- read.table("merge.het.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

# 将数据转换为长格式
dat_long <- pivot_longer(dat, 
                         cols = everything(), 
                         names_to = "Species", 
                         values_to = "Value")

# 设置箱型图物种的顺序
dat_long$Species <- factor(dat_long$Species, levels = c("Bassozetus_sp", "Brotula_multibarbata", "Pachycara_sp", "Pholis_nebulosa", "Dictyosoma_tongyeongensis"))

# 使用 ggplot2 绘制横向的箱型图，并调整箱体宽度和位置
ggplot(dat_long, aes(y = Species, x = Value, fill = Species)) + 
  geom_boxplot(width = 0.5, position = position_dodge(width = 0.5), alpha = 0.7) +  # 调整箱体宽度和位置
  scale_fill_manual(values = c("Pachycara_sp" = "darkblue", 
                               "Bassozetus_sp" = "darkblue", 
                               "Pholis_nebulosa" = "lightblue", 
                               "Dictyosoma_tongyeongensis" = "lightblue", 
                               "Brotula_multibarbata" = "lightblue")) +  # 设置颜色
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.y = element_text(angle = 0, hjust = 1, size = 14),  # 设置纵坐标字体大小
    axis.text.x = element_text(size = 32),  # 设置横坐标字体大小
    panel.grid.major = element_blank(),  # 去掉主网格线
    panel.grid.minor = element_blank(),  # 去掉次网格线
    panel.border = element_blank(),      # 去掉面板边框
    axis.line = element_line(color = "black")  # 只保留x轴和y轴的线
  ) + 
  labs(title = "Boxplot of Species Values", y = "Species", x = "Value")

