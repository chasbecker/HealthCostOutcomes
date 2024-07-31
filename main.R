# explanation of data ETL below the code

# start with a clean workspace :-/
rm(list=ls())
library(tidyverse)
library(sqldf)

nhe_wide <- read_csv("data/NHE22_cleaned.csv" )
nhe_long <- pivot_longer(nhe_wide, cols = everything() )
colnames(nhe_long) <- c("Year", "PCTGDP")
nhe_long$Year <- as.numeric(nhe_long$Year)

nchs_long <- read_csv("data/NCHS_cleaned.csv")

#str(nhe_long)
#str(nchs_long)

# this works and it's concise but also very R-specific
#CostOutcome <- merge( nhe_long, nchs_long, by = "Year")

# using SQL to facilitate future migration to an SQL db.
CostOutcome <- sqldf("SELECT nhe_long.Year, nhe_long.PCTGDP, nchs_long.LifeExpectancy FROM nhe_long, nchs_long WHERE nhe_long.Year = nchs_long.Year")

#========================================================
# add a column for life expectancy scaled to %gdp
# 1966 life expectancy = 68.9 years, %GDP spending = 5%
CostOutcome$Scaled <- CostOutcome$LifeExpectancy/(68.9/5)
#========================================================

CostVsOutcome <- CostOutcome %>% 
  ggplot(aes(x = Year)) +
  geom_line(aes(y = PCTGDP, color = "PCTGDP"), linewidth=1) +
  geom_line(aes(y = LifeExpectancy, color = "LifeExp"), linewidth=0.5) +
  geom_line(aes(y = Scaled, color = "ScaledLE"), linewidth=1) +
  guides(color = guide_legend(title = "Params")) +
  geom_vline(xintercept = 1966) +
  labs( title = "Healthcare: Spending vs Outcomes, since 1966", x = "Cost up 248%  LifeExp up 13%", y = "%GDP & Life Expectacy" ) +
  theme(plot.title = element_text(hjust = 0.5))


# now show the graph
CostVsOutcome



#:::::::: Data source/ETL: https://www.cms.gov/data-research/statistics-trends-and-reports/national-health-expenditure-data/historical
# 
# In retrospect, this is a small and quite messy dataset.  It has freestyle header and footer text and the bulk of the tabular data is not of interest.  
# 
# Downloaded:
#   "NHE Summary, including share of GDP, CY 1960-2022 (ZIP)"
# 
# 1) "Extract all..." applied to the ZIP folder;
# 2) Used Google Sheets to open ("Import") "NHE_Summary.xlsx";
# 3) Deleted all rows except the original Rows 2 and 31 (becoming Rows 1 & 2);
# 4) Deleted Column A to get rid of chr names;
# 6) Saved ("Download") data in CSV format as "NHE_cleaned.csv";
# 7) Read that into an R data.frame and reformatted in R:
#   
#   nhe_wide <- read_csv("data/NHE22_cleaned.csv")
#   nhe_long <- pivot_longer(nhe_wide, cols=everything())
#   colnames(nhe_long) <- c("Year", "PCTGDP")
#   
#:::::::Data source/ETL (life expectancy [all races, both sexes]):
# 
# 1) From https://catalog.data.gov/dataset/nchs-death-rates-and-life-expectancy-at-birth downloaded the CSV format;
# 2) Imported into GSheets;
# 3) Kept Rows 1 - 120 (all races, both sexes);
# 4) Kept only Column A & D (became A & B);
# 5) renamed Column B to "LifeExpectancy";
# 5) Saved/"Download" as "LifeExpectancy_cleaned.csv";
# 6) Column names: nchs_long <- read_csv("data/NCHS_cleaned.csv")
# colnames(nchs_long) <- c("Year", "LifeExp")
# 
#:::::::Data source/ETL (life expectancy [all races, both sexes]):
# 
# 1) From https://www.cms.gov/files/zip/national-health-expenditures-type-service-and-source-funds-cy-1960-2022.zip downloaded the XLSX format.
# 2) Imported into GSheets;
# 3) Did some stuff ... tbd


# That prepared the data for analysis and visualization.