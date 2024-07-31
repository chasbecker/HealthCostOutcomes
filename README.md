This project is a simplistic analysis of the relationship between healthcare spending as a % of GDP
and healthcare outcomes as measured by life expectancy.  As explained in main.R, I located US gov't
data on spending and life expectancy, then applied the ETL process as described.  I plotted the data
for life expectancy and spending on the same x and y scales, which didn't really mean or show much.
So I normalized the life expectancy data by "LifeExpectancy/(68.9/5)" which is the ratio of life
expectancy to percent GDP spending in 1966 (the year after LBJ signed Medicare into law, denoted by
te vertical black line on the graph).

Quite obviously, there are a lot of legitimate questions about this methodology.  But as a 30,000 ft level
overview of how healthcare outcomes have tracked healthcare spending I believe it's worth considering.
