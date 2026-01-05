# Spotify Wrapped

<p align="center">
  <img src="shinydashboard/www/images/kyle.jpg" alt="Kyle MacLachlan as Lorde" width="350" />
  <br>
  <em>Kyle MacLachlan as Lorde</em> 
</p>

## About

This project is inspired by the iconic Spotify Wrapped. For 2025, I decided to take a closer look at my streaming data month-by-month to highlight my top artists, top songs, and listending habits.

- Shiny dashboard
- Mobile-responsive user interface
- Data visualization and communication

## Repository Structure

```bash
spotify-wrapped
├── README.md
├── .gitignore
├── analysis
│   ├── functions
│   ├── fresh theme dashboard
│   ├── spotify_wrapped.qmd
│   └── spotify_wrapped.html
└── shinydashboard
    ├── data
    ├── text
    ├── www
    ├── global.R
    ├── server.R
    └── ui.R
```

## Data

The data was collected using a third-party API, IFTTT. This service allows Spotify users to connect Spotify with Google Sheets to automatically log information about each song streamed.

How to access the data:
```{r}
# load packages
library(here)
library(googlesheets4)
```
```{r}
# read data
raw_data <- read_sheet("https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?usp=sharing")
```
```{r}
# source cleaning function
source(here("analysis", "functions", "clean_data.R"))

# clean data
spotify_data <- clean_data(raw_data)
```
The processed data is available for download in the `data` subfolder of the shinydashboard.
