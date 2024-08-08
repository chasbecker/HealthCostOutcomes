# Utility function which transposes a wide csv into a long data.frame
# INPUT: a csv file with variables names in the first column
# and data values in columns 2 -> n
# RETURNS: a data.frame in long format with variable names in the header


wide2long <- function(widecsv){
  widedf <- read_csv(widecsv, col_names=FALSE )
  t_df_headers <- t(widedf[,1])
  t_df_data <- data.frame(t(widedf[,-1]))
  colnames(t_df_data) <- t_df_headers
  return(t_df_data)
}
