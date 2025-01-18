# Spotify Wrapped

![Kyle MacLachlan as Lorde](images/kyle.jpg)

## About

This project is inspired by the iconic Spotify Wrapped event that occurs at the end of each year. Instead of waiting for the yearly summary, this initiative evaluates my monthly streaming habits, ultimately leading to my annual wrapped summary. Monthly results will be posted on my website. [Check it out!](https://matteo-torres.github.io/about.html)

- Utilizing an API to extract streaming data
- Developing functions to tidy and organize monthly data
- Visualizing statistics through various plots

## Repository Structure

```bash
spotify-wrapped
├── README.md
├── .gitignore
├── spotify-wrapped.qmd
└── Rmd/Proj files
```

## Data

All of the streaming data is logged onto a Google Sheet using an applet from IFTTT. You can access the raw Google Sheet using the code provided below.

```bash
url <- "https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?usp=sharing"
spotify_data_raw <- read_sheet(url)
```

## References

IFTTT. (n.d.). My Spotify Wrapped [Applet]. https://ifttt.com/applets/ptQiGLyZ-my-spotify-wrapped

Torres, M. (2025). Spotify Wrapped 2025 [Google Sheets]. Google. https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?gid=0#gid=0
