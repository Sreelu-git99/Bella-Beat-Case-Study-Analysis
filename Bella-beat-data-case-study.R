#installing and loading required packages
install.packages("tidyverse")
library(tidyverse)
install.packages("ggplot2") # to create plots 
library(ggplot2)
install.packages("janitor")
library(janitor)
install.packages("skimr")
library(skimr)
install.packages('dplyr') # to change data (mutate, filter, arrange, etc)
library(dplyr)

#setting current working directory
setwd("C:/Users/sreelu/Desktop/Fitbit_data/Fitabase Data 4.12.16-5.12.16")

#Ensure we're in the right working directory
getwd()

#Reading the csv files
daily_activity_data <- read_csv("dailyActivity_merged.csv")
head(daily_activity_data)
daily_calories_data <- read_csv("dailyCalories_merged.csv")
head(daily_calories_data)
daily_intensities_data <- read_csv("dailyIntensities_merged.csv")
head(daily_intensities_data)
daily_steps_data <- read_csv("dailySteps_merged.csv")
head(daily_steps_data)
heart_rate_data <- read_csv("heartrate_seconds_merged.csv")
head(heart_rate_data)
sleep_data <- read_csv("sleepDay_merged.csv")
head(sleep_data)
weight_log_data <- read_csv("weightLogInfo_merged.csv")
head(weight_log_data)

#Package to run SQL syntax on R data frames
install.packages("sqldf")
library(sqldf)

#Selecting only required columns for calories
daily_activity_data_calories <- daily_activity_data %>% 
  select(Id, ActivityDate, Calories)

head(daily_activity_data_calories)

#Checking if all data contained in calories data frame is present in daily activity data frame
common_calories_data <- sqldf("SELECT * FROM daily_activity_data_calories INTERSECT SELECT * FROM daily_calories_data")
head(common_calories_data)
nrow(common_calories_data)
nrow(daily_activity_data_calories)

#Selecting only required columns for intensities
daily_activity_data_intensities <- daily_activity_data %>% 
  select(Id, ActivityDate, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes, SedentaryActiveDistance, LightActiveDistance, ModeratelyActiveDistance, VeryActiveDistance)

head(daily_activity_data_intensities)

#Checking if all data contained in intensities data frame is present in daily activity data frame
common_intensities_data <- sqldf("SELECT * FROM daily_activity_data_intensities INTERSECT SELECT * FROM daily_intensities_data")
nrow(common_intensities_data)==nrow(daily_activity_data_intensities)

#Selecting only required columns for intensities
daily_activity_data_steps <- daily_activity_data %>% 
  select(Id, ActivityDate, TotalSteps)

head(daily_activity_data_steps)

#Checking if all data contained in intensities data frame is present in daily activity data frame
common_steps_data <- sqldf("SELECT * FROM daily_activity_data_steps INTERSECT SELECT * FROM daily_steps_data")
nrow(common_steps_data)==nrow(daily_activity_data_steps)
head(common_steps_data)

#Getting the summary from our data
daily_activity_data %>% 
  select(TotalSteps, TotalDistance, Calories, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes) %>% 
  summary()

min_date <- min(daily_activity_data$ActivityDate)
max_date <- max(daily_activity_data$ActivityDate)
num_of_people <- n_distinct(daily_activity_data$Id)


ggplot(data=daily_activity_data, aes(x=TotalSteps, y=Calories)) + geom_point(colour='blue', size=2) + geom_smooth(method = lm, colour='black', size=1.5) + labs(title="Relationship between Total Steps and Calories burnt", caption=paste0("Data from: ", min_date, " to ", max_date, " of ", num_of_people, " people"))

rmarkdown::render("C:/Users/sreelu/Desktop/Fitbit_data/Bella-beat-data-case-study.R", "pdf_document")
