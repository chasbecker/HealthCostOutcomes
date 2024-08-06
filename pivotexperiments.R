rm(list=ls())

# Expects a wide dataframe with variabble names in the first column (1)
# and values in the rest of the columns (2-n).  Returns a neatly
# transposed long dataframe.  Does no error checking, use at your own risk.

wide2long <- function(widedf){
  t_df_headers <- t(widedf[,1])
  t_df_data <- data.frame(t(widedf[,-1]))
  colnames(t_df_data) <- t_df_headers
  return(t_df_data)
}

df_wide <- read_csv("data/WideVsLong/wide.csv", col_names=FALSE)

finis <- wide2long(df_wide)

# Let's see...
str(finis)
plot(finis$Year, finis$PCTGDP, xlab="Year", ylab="PCTGDP", type="b")


###################### RESIDUALS ######################################
# "wide.csv" is a text file containing these two lines (or similar,
# extracted from a spreadsheet file):
# 
# Year,1960,1961,1962,1963,1964,1965,1966,1967,1968
# PCTGDP,5,5.2,5.3,5.4,5.6,5.6,5.6,6,6.2