# load packages ----
library(DT)
library(hms)
library(fresh)
library(shiny)
library(slickR)
library(markdown)
library(tidyverse)
library(shinyWidgets)
library(shinydashboard)
library(shinycssloaders)

# read data ----
spotify_data <- read_rds("data/spotify_data.rds")