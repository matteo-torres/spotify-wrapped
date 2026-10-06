# load packages ----
library(DT)
library(hms)
library(fresh)
library(shiny)
library(slickR)
library(ggstar)
library(markdown)
library(htmltools)
library(lubridate)
library(tidyverse)
library(shinyWidgets)
library(shinydashboard)
library(shinycssloaders)

# read data ----
spotify_data <- read_csv("data/clean_data.csv")