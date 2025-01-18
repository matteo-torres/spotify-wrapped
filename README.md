# Spotify Wrapped

<p align="center">
  <img src="images/kyle.jpg" alt="Kyle MacLachlan as Lorde" width="500" />
</p>

## About

This project is inspired by the iconic Spotify Wrapped that takes place at the end of each year. Instead of waiting for the yearly summary, I will assess my monthly streaming habits, ultimately leading to my end-of-the-year Wrapped summary. Monthly results will be posted on my [website](https://matteo-torres.github.io), so be sure to check it out!

- Utilizing an API to extract streaming data
- Developing functions to tidy and organize monthly data
- Visualizing statistics through various plots

## Repository Structure

```bash
spotify-wrapped
├── README.md
├── .gitignore
├── spotify-wrapped.qmd
├── Rmd/Proj files
└── images
    └── kyle.jpg
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
