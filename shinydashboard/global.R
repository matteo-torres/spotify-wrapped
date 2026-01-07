# load packages ----
library(DT)
library(hms)
library(fresh)
library(shiny)
library(ggstar)
library(slickR)
library(markdown)
library(tidyverse)
library(shinyWidgets)
library(shinydashboard)
library(shinycssloaders)

# read data ----
monthly_spotify_data <- read_rds("data/monthly_spotify_data.rds")