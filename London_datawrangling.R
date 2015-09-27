### Load data
# lnd84.Rds from https://github.com/Robinlovelace/Creating-maps-in-R
# csv files from http://data.london.gov.uk/dataset (9/25/2015)
london_map <- readRDS(file = 'data/lnd84.rds')
crime_data <- read.csv("data/boro.csv", stringsAsFactors = FALSE)
### Total crimes by category
suppressMessages(library(dplyr))
crimes <- crime_data %>%
          group_by(Borough, Crime = MajorText) %>%
          summarize(Count = sum(CrimeCount))
### Add population data
borough_data <- read.csv("data/london-borough-profiles.csv", stringsAsFactors = FALSE)
population <- borough_data %>%
              select(Borough = Area.name, Population = GLA.Population.Estimate.2015)
crimes <- left_join(crimes, population, by = 'Borough')
### Calculate crime rate by borough for each category of crime
crimes <- crimes %>%
          mutate(CrimeRate = Count / Population * 100) %>%
          select(Borough, Crime, CrimeRate)
### Transform to wide form
library(reshape2)
crimes <- dcast(crimes, Borough ~ Crime, value.var = 'CrimeRate')
### Add a total column
crimes$Total <- rowSums(crimes[, 2:length(names(crimes))])
### Add crime rates to spatial data
london_map@data <- london_map@data %>%
                   select(Borough = name)
london_crime_map <- london_map
suppressWarnings(
    london_crime_map@data <- left_join(london_map@data, crimes, by = 'Borough')
)
london_crime_map$Total[length(london_crime_map$Total)] <- 0 # set a zero value to give a floor to color scale
### Save the results
saveRDS(object = london_crime_map, file = 'data/crime.Rds')
# Grace Pehl, PhD
