# Spotify Wrapped

<p align="center">
  <img src="images/kyle.jpg" alt="Kyle MacLachlan as Lorde" width="500" />
  <br>
  <em>Kyle MacLachlan as Lorde</em> 
</p>

## About

This project is inspired by the iconic Spotify Wrapped, but with a twist: rather than waiting for the annual summary, I'll be analyzing my streaming habits on a monthly basis. These monthly insights will build up to my year-end Wrapped, providing a more frequent look at my listening trends. The results will be shared on my [website](https://matteo-torres.github.io/about.html), so make sure to check it out!

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

All of my streaming data is logged onto a Google Sheet using an applet from IFTTT. You can access the raw Google Sheet with my streaming data through the link below. If you're interested, feel free to replace the link with your own to analyze your data!

```bash
spotify_data_raw <- read_sheet("https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?usp=sharing")
```

## References

IFTTT. (n.d.). My Spotify Wrapped [Applet]. https://ifttt.com/applets/ptQiGLyZ-my-spotify-wrapped

Spotify. (n.d.). *Spotify* [Music streaming service]. Retrieved from https://www.spotify.com

Torres, M. (2025). Spotify Wrapped 2025 [Google Sheets]. Google. https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?gid=0#gid=0
