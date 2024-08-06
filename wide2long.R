# testing methods for wide-to-long transpose

rm(list=ls())
library(tidyverse)

df_wide <- read_csv("data/WideVsLong/wide.csv", col_names=FALSE)
cn <- t(df_wide[,1])
cn[1,]#is_tibble(df_wide)
cn[1,1]

df_long <- data_frame(t(df_wide[,-1]))
#is_tibble(df_long)
colnames(df_long) <- t(df_wide[1,])

colnames(df_long) <- t(df_wide[,1])
df_long$Year <- as.numeric(df_long$Year)
#is_tibble(df_long)

t(df_wide[,1])
