# load packages ----
library(DT)
library(hms)
library(fresh)
library(shiny)
library(slickR)
library(ggstar)
library(treemap)
library(markdown)
library(tidyverse)
library(ggwordcloud)
library(shinyWidgets)
library(shinydashboard)
library(shinycssloaders)

# read data ----
monthly_spotify_data <- read_rds("data/monthly_spotify_data.rds")
spotify_data <- read_csv("data/spotify_data.csv")