# Rewritten with 'wide2long' function in library(CLBUtils) for transposing wide data to long (duh).  Or can still use "source(wide2long)".

setwd("G:/My Drive/R/HealthcareCostVsOutcomes")
# start with a clean workspace :-/
rm(list=ls())
library(tidyverse)
library(sqldf)
# either this
library(CLBUtils)
# or that
source("wide2long.R")

nhe_long <- wide2long("data/NHE_PctGDP.csv")

nchs_long <- read_csv("data/NCHS_LifeExpectancyAllRacesBothSexes.csv") # already in long format

# this works and it's concise but also R-specific
#CostOutcome <- merge( nhe_long, nchs_long, by = "Year")


# using SQL to facilitate future migration to an SQL db.

CostOutcome <- sqldf("SELECT nhe_long.Year, nhe_long.PCTGDP, nchs_long.AvgLifeExpect FROM nhe_long, nchs_long WHERE nhe_long.Year = nchs_long.Year")

#========================================================
# add a column for life expectancy scaled to %GDP
# medicare goes into effect 1966,
# life expectancy = 70.2 years, %GDP spending = 5.6%
CostOutcome$Scaled <- CostOutcome$AvgLifeExpect/(70.2/5.6)
#========================================================

CostVsOutcome <- CostOutcome %>% 
  ggplot(aes(x = Year)) +
  geom_line(aes(y = PCTGDP, color = "PCTGDP"), linewidth=1) +
  geom_line(aes(y = AvgLifeExpect, color = "LifeExp"), linewidth=0.5) +
  geom_line(aes(y = Scaled, color = "ScaledLE"), linewidth=1) +
  guides(color = guide_legend(title = "Params")) +
  geom_vline(xintercept = 1966) +
  labs( title = "Healthcare: Spending vs Outcomes, since 1966", x = "Cost up 3.1X  LifeExp up 1.1X", y = "%GDP & Life Expectacy" ) +
  theme(plot.title = element_text(hjust = 0.5))


# now show the graph
CostVsOutcome



#:::::::: Data source/ETL (see "Sources.txt" ::::::::
# 
# In retrospect, this is a small and quite messy dataset.  It has freestyle header and footer text and the bulk of the tabular data is not of interest.  
# 
# Downloaded:
#   https://www.cms.gov/files/zip/nhe-summary-including-share-gdp-cy-1960-2022.zip
# 
# 1) "Extract all..." applied to the ZIP folder;
# 2) Used Google Sheets to open ("Import") "NHE_Summary.xlsx";
# 3) Deleted all rows except the original Rows 2 and 31 (becoming Rows 1 & 2);
# 4) Deleted Column A to get rid of chr names;
# 6) Saved ("Download") data in CSV format as "data/NHE_PctGDP.csv";
# 7) Read that into an R data.frame and reformatted in R using "wide2long":
#   nhe_long <- wide2long("data/NHE_PctGDP.csv")
#   
#   
#:::::::Data source/ETL (by year, life expectancy [all races, both sexes]):
# 
# 1) From https://catalog.data.gov/dataset/nchs-death-rates-and-life-expectancy-at-birth downloaded the CSV format;
# 2) Imported into GSheets;
# 3) Kept Rows 1 - 120 (all races, both sexes);
# 4) Kept Columns: Year,Race,Sex,AvgerageLifeExpectancy
# 5) renamed AvgLifeExpect";
# 5) Saved/"Download" as "LifeExpectancyAllRacesBothSexes.csv";
# 6) Read into a data.frame with nchs_long <- read_csv("data/LifeExpectancyAllRacesBothSexes.csv")
# EOF