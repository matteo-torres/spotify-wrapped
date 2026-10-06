server <- function(input, output) {
  
  # image path ----
  image_list <- reactive({
    
    list.files("www/albums", full.names = TRUE, pattern = "\\.jpeg$", ignore.case = TRUE)
    
  })
  
  # build slickR carousel ----
  output$carousel_images_output <- renderSlickR({
    
    # links
    links <- c("https://open.spotify.com/album/2ffVa2UhHUDwMHnr685zJ4?si=Dqh1U26wSaG1IF_iIJztHg",
               "https://open.spotify.com/album/3x8qThM7qP41LYoEhVerfm?si=l16fRea6SfKJgwxqhlGuyw",
               "https://open.spotify.com/album/1ePkYcH5ZQCb1b4tQeiEDj?si=KnZJVPGfS8qMztv4g0kLYA",
               "https://open.spotify.com/album/316O0Xetgx2NJLRgJBw4uq?si=WpDO9nhYQ6mMFZpcUneKKg",
               "https://open.spotify.com/album/2YS8Z0Vc7FTOYBLgUoN2Lo?si=EWqLdgmJSm2oKata_IySJQ",
               "https://open.spotify.com/album/6L2qELGG144WItEUaAwVme?si=Rysecrs8QMyjT5bfjIcVnA",
               "https://open.spotify.com/album/22PkV1Le9P3X4RY4xtmK0q?si=OnuhAMK_TtWy98gIbI-05w",
               "https://open.spotify.com/album/1sWzJ2hL5b64u7n9a8owqc?si=5WNi0ophS0CXMxyNNV8hQw",
               "https://open.spotify.com/album/5RYtK8KtwWxs64BrnpOYqI?si=SN98Pe5lTVCDjLvs69O7-w",
               "https://open.spotify.com/album/3o1TOhMkU5FFMSJMDhXfdF?si=tyl_0BI_QqKNRtR7-vpu1g",
               "https://open.spotify.com/album/0v1sQbOCM2xDdIYA0XYapM?si=-t-Kku6NT8CTJQK0LC3P8A",
               "https://open.spotify.com/album/6dqOhJMQS0llsd4Lq2MgGj?si=ipKYXyyaRM60DpLaOF93ng",
               "https://open.spotify.com/album/2XeflvA0dNvjpX0vxukgiv?si=T5DPMkwJROO7D1Ny4mtCHg",
               "https://open.spotify.com/album/3lyRrGhXCCMbt4jVO9Wur2?si=ZjlxuJMITQiq1yfXkFKqrg",
               "https://open.spotify.com/album/0TIiUHKaFu347OToFlHjW2?si=0TPuavgyS5WZpgvrWqporw",
               "https://open.spotify.com/album/3SUEJULSGgBDG1j4GQhfYY?si=I4iQPP3RRCeubWOWCwNHYw",
               "https://open.spotify.com/album/2B87zXm9bOWvAJdkJBTpzF?si=CezgOgSsScO91bvKKS2RmQ",
               "https://open.spotify.com/album/6jbtHi5R0jMXoliU2OS0lo?si=7912b923a6034fe6",
               "https://open.spotify.com/album/4bR7pd6TVS53l24qFV4wI8?si=P7SkfOh_QJW3BLwTQBLVsA",
               "https://open.spotify.com/album/6Rv8V4QeLgfEC01czqJsiI?si=Ipt8Nab-SKCESCgBgqpo3g",
               "https://open.spotify.com/album/2HIwUmdxEl7SeWa1ndH5wC?si=vdcf_WIFSRuU9RAUFNzhMw",
               "https://open.spotify.com/album/6cuNyrSmRjBeekioLdLkvI?si=8OnokBPbS4aGBlHkgA6jXQ",
               "https://open.spotify.com/album/0LPWPtswtDiBc9lD7mydld?si=MecfaHOUQEO5CUi7VyBIjg",
               "https://open.spotify.com/album/0IojfyxFQMggZW9aNCeaV7?si=sby7QdfFQn6KTIgtWLnI8g",
               "https://open.spotify.com/album/5lgqJ8vLfDGbL1AFHgj2o1?si=lLSXRuaIQWWV834oNctj3w",
               "https://open.spotify.com/album/1qSS0T6Ffrb3rFVpizzOuk?si=hN00N4IHTMqzS30VcGinGw",
               "https://open.spotify.com/album/28bHj2enHkHVFLwuWmkwlQ?si=70fr6ZKUToyWvLP4Kac78g",
               "https://open.spotify.com/album/0mQPq9INcTC48siErksOrl?si=MScHK96ASWa9Q7Whjl5WYg")
    
    # slickR carousel ----
    slickR(image_list(),
           objLinks = links,
           height = "300px",
           slideId = "Carousel") +
      settings(arrows = TRUE,
               slidesToShow = 3,
               slidesToScroll = 1,
               centerMode = TRUE,
               centerPadding = "0px",
               focusOnSelect = TRUE,
               autoplay = TRUE,
               autoplaySpeed = 5000,
               responsive = JS("[
               {breakpoint: 1024,
               settings: {
               slidesToShow: 3,
               centerMode: true,
               centerPadding: '0px'}},
               {breakpoint: 768,
               settings: {
               slidesToShow: 1,
               centerMode: true,
               centerPadding: '40px'}},
               {breakpoint: 480,
               settings: {
               slidesToShow: 1,
               centerMode: true,
               centerPadding: '0px'}}
               ]"))
    
  })
  
  # build monthly summary ----
  monthly_summary <- reactive({
    
    spotify_data %>%
      group_by(month_num) %>%
      summarize(streams = n(),
                tracks = length(unique(track_name)),
                artists = length(unique(artist_name)),
                .groups = "drop") %>%
      arrange(desc(streams)) %>%
      mutate(rank = case_when(
        row_number() == 1 ~ "1st",
        row_number() == 2 ~ "2nd",
        row_number() == 3 ~ "3rd",
        TRUE ~ paste0(row_number(), "th")))
    
  })
  
  # build rank valueBox ----
  output$rank_output <- renderValueBox({
    
    valueBox_df <- monthly_summary() %>%
      filter(month_num == input$month_input)
    
    valueBox(valueBox_df$rank,
             subtitle = "Rank",
             color = "black")
    
  })
  
  # build streams valueBox ----
  output$streams_output <- renderValueBox({
    
    valueBox_df <- monthly_summary() %>%
      filter(month_num == input$month_input)
    
    valueBox(valueBox_df$streams,
             subtitle = "Streams",
             color = "black")
    
  })
  
  # build tracks valueBox ----
  output$track_output <- renderValueBox({
    
    valueBox_df <- monthly_summary() %>%
      filter(month_num == input$month_input)
    
    valueBox(valueBox_df$tracks,
             subtitle = "Tracks",
             color = "black")
    
  })
  
  
  # build artists valueBox ----
  output$artist_output <- renderValueBox({
    
    valueBox_df <- monthly_summary() %>%
      filter(month_num == input$month_input)
    
    valueBox(valueBox_df$artists,
             subtitle = "Artists",
             color = "black")
    
  })
  
  # filter spotify data by month ----
  monthly_spotify_data <- reactive({
    
    req(input$month_input)
    
    spotify_data %>%
      filter(month_num == input$month_input)
    
  })
  
  # build DTs ----
  output$table_output <- renderDT({
    
    # DT
    if (input$table_input == "Top 10 Artists") {
      monthly_spotify_data() %>%
        group_by(artist_name) %>%
        summarize(streams = n(), .groups = "drop") %>%
        slice_max(streams, n = 10, with_ties = FALSE) %>%
        datatable(colnames = c("ARTIST", "STREAMS"), 
                  class = "row-border",
                  selection = "none",
                  options = list(dom = "t",
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    } else if (input$table_input == "Top 10 Tracks") {
      monthly_spotify_data() %>%
        group_by(track_name, artist_name) %>%
        summarize(streams = n(), .groups = "drop") %>%
        slice_max(streams, n = 10, with_ties = FALSE) %>%
        datatable(colnames = c("TRACK", "ARTIST", "STREAMS"),
                  class = "row-border", 
                  selection = "none",
                  options = list(dom = "t", 
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    }
    
  })
  
  # top track by top artist ----
  output$song_output <- renderUI({
    
    # song names and links
    songs <- data.frame(track_name = c("Delicious (feat. Tommy Cash)",
                                       "Backseat (feat. Carly Rae Jepsen)",
                                       "Club classics",
                                       "I Got It (feat. Brooke Candy, CupcakKe and Pabllo Vittar)",
                                       "New York",
                                       "Shapeshifter",
                                       "take me by the hand",
                                       "viscus (feat. FKA twigs)",
                                       "Sushi",
                                       "Hammer"),
                        link = c('<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/740PUPhgdtWhxGYbQzM3do?utm_source=generator&theme=0&si=1b1292240ab34f29" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/4HjtHraeKy5wA4DA9o92HZ?utm_source=generator&theme=0&si=663857dce9844f9f" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/7BoOmRrtNCbIT9yQ4xidk5?utm_source=generator&si=00548503b7f74d51" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/7tjQl5EC72HBJRAKxP3Bvm?utm_source=generator&theme=0&si=8f24b9254e2c4978" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/0Q9kIg9o8w1XKepXWmDUmT?utm_source=generator&si=add7e3fa3d464095" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/0vtgMfyOVM2Y97DcVVJw3m?utm_source=generator&si=9be9f633fd3f42ad" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/2u0lpoSMeShFB7ZB6ndDHJ?utm_source=generator&si=88080ee5b75d4aab" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/3q0pwG3XZoxDWbm4jzZddS?utm_source=generator&si=efc31dd6d0a940cd" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/0hHDMvLvoJh8gYbJIi182A?utm_source=generator&theme=0&si=57d1650e940b4287" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>',
                                 '<iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/track/01U0X0ToQhK0AgvNUdyXQe?utm_source=generator&si=cc3c71d9b7a448b0" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>'))
    
    monthly_spotify_data() %>%
      group_by(artist_name) %>%
      summarize(streams = n(), .groups = "drop") %>%
      slice_max(streams, n = 1, with_ties = FALSE) %>%
      inner_join(monthly_spotify_data(),
                 by = "artist_name") %>%
      group_by(artist_name, track_name) %>%
      summarize(streams = n(), .groups = "drop") %>%
      slice_max(streams, n = 1, with_ties = FALSE) %>%
      inner_join(songs, by = "track_name") %>%
      pull(link) %>%
      HTML()
    
  })
  
  # top album ----
  output$album_output <- renderUI({
    
    # album images
    albums <- data.frame(album_name = c("DeBÍ TiRAR MáS FOToS",
                                        "EUSEXUA",
                                        "HOT",
                                        "Women In Music Pt. III",
                                        "choke enough",
                                        "Addison",
                                        "Virgin",
                                        "EUSEXUA Afterglow"),
                         link = c("https://i.scdn.co/image/ab67616d0000b273bbd45c8d36e0e045ef640411",
                                  "https://i.scdn.co/image/ab67616d0000b2731ea443f7a8512680563ce75d",
                                  "https://i.scdn.co/image/ab67616d0000b2731fc0f4faafaa183cc70297e5",
                                  "https://i.scdn.co/image/ab67616d0000b273d2631fe4c90aae7dec8fb0df",
                                  "https://i.scdn.co/image/ab67616d0000b2730b68095c4016bdeabd032e89",
                                  "https://i.scdn.co/image/ab67616d0000b273089511953028cbfeb095c593",
                                  "https://i.scdn.co/image/ab67616d0000b27323d41bf736920a032e222a78",
                                  "https://i.scdn.co/image/ab67616d0000b2736089c0f46246e83c090eb0ad"))
    
    # top album
    top_album <- monthly_spotify_data() %>%
      group_by(artist_name, album_name) %>%
      summarize(streams = n(), .groups = "drop") %>%
      slice_max(streams, n = 1, with_ties = FALSE) %>%
      inner_join(albums, by = "album_name")
    
    tags$div(style = "text-align: center;",
             
             tags$img(src = top_album$link,
                      height = "300px",
                      style = "border-radius: 8px;"),
             
             tags$h4(top_album$album_name),
             tags$p(top_album$artist_name))
    
  })
  
  # build lineplot ----
  output$month_output <- renderPlot({
    
    max <- monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n()) %>%
      slice_max(order_by = streams)
    
    min <- monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n()) %>%
      slice_min(order_by = streams)
    
    x_scale_max <- monthly_spotify_data() %>%
      slice_head(n = 1) %>%
      pull(datetime) %>%
      days_in_month()
    
    avg <- monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      complete(day = 1:x_scale_max, fill = list(streams = 0)) %>%
      summarize(avg_streams = mean(streams))
    
    # daily streams line plot
    monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      complete(day = 1:x_scale_max, fill = list(streams = 0)) %>%
      ggplot() +
      geom_line(aes(x = day, y = streams), color = "#6ca200", linewidth = 2, lineend = "round") +
      geom_hline(data = avg, aes(yintercept = avg_streams), linewidth = 1.5, lineend = "round", linetype = "dashed", color = "#FF69B4") +
      geom_star(data = max, aes(x = day, y = streams), size = 6, fill = "#FFD700", color = "#FFD700") + 
      geom_point(data = min, aes(x = day, y = streams), shape = 1, size = 6, stroke = 1.5, color = "#47a4cf") +
      scale_x_continuous(expand = c(0, 0), limits = c(1, x_scale_max)) +
      scale_y_continuous(expand = c(0,0), limits = c(0, NA)) +
      coord_cartesian(clip = "off") +
      labs(x = "Day",
           y = "Streams") +
      theme_bw() +
      theme(text = element_text(family = "Manrope"),
            axis.title.x = element_text(size = 16, margin = margin(t = 10)),
            axis.title.y = element_text(size = 16, margin = margin(r = 10)),
            axis.text = element_text(size = 14),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_blank(),
            panel.background = element_rect(color = "lightgrey", fill = NA),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # highest streaming day
  output$peak_output <- renderUI({
    
    monthly_spotify_data() %>%
      group_by(month, day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      slice_max(order_by = streams) %>%
      mutate(message = paste0("Highest Streaming Day: <b>", month, " ", day, "</b><br>",
                              "Streams: <b>", streams, "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # percentage of streams for highest streaming day
  output$pct_output <- renderUI({
    
    monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n()) %>%
      summarize(pct = max(streams)/sum(streams)*100) %>%
      mutate(message = paste0("The highest streaming day accounted for ", "<b>",
                              signif(pct, digits = 3), "</b>", "<b>%</b>", " of total streams.")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # lowest streaming day(s)
  output$low_output <- renderUI({
    
    monthly_spotify_data() %>%
      group_by(month, day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      slice_min(order_by = streams) %>%
      summarize(message = paste0("Lowest Streaming Day(s): <b>", paste0(month, " ", day, collapse = ", "), "</b><br>",
                                 "Stream(s): <b>", streams[1], "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # quiet day(s)
  output$quiet_output <- renderUI({
    
    x_scale_max <- monthly_spotify_data() %>%
      slice_head(n = 1) %>%
      pull(datetime) %>%
      days_in_month()
    
    monthly_spotify_data() %>%
      group_by(month, day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      complete(day = 1:x_scale_max, fill = list(streams = 0)) %>%
      fill(month, .direction = "downup") %>%
      filter(streams == 0) %>%
      summarize(message = paste0("Quiet Day(s): <b>", paste0(month, " ", day, collapse = ", "), "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # streaming streak
  output$streak_output <- renderUI({
    
    x_scale_max <- monthly_spotify_data() %>%
      slice_head(n = 1) %>%
      pull(datetime) %>%
      days_in_month()
    
    monthly_spotify_data() %>%
      group_by(month, day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      complete(day = 1:x_scale_max,
               fill = list(streams = 0)) %>%
      fill(month, .direction = "downup") %>%
      mutate(streak_group = cumsum(streams == 0)) %>%
      filter(streams > 0) %>%
      count(streak_group) %>%
      summarize(streak = max(n)) %>%
      mutate(message = paste0("Longest Streaming Streak: <b>",
                              streak," days</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # average streams per day
  output$avg_output <- renderUI({
    
    x_scale_max <- monthly_spotify_data() %>%
      slice_head(n = 1) %>%
      pull(datetime) %>%
      days_in_month()
    
    monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n(), .groups = "drop") %>%
      complete(day = 1:x_scale_max, fill = list(streams = 0)) %>%
      summarize(avg_streams = mean(streams)) %>%
      mutate(message = paste("Average Streams:", "<b>", signif(avg_streams, digits = 2), "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # build histogram ----
  output$day_output <- renderPlot({
    
    max <- monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n()) %>%
      slice_max(order_by = streams)
    
    # highest streaming day histogram
    monthly_spotify_data() %>%
      filter(day == max$day) %>%
      ggplot() +
      geom_histogram(aes(x = time), fill = "#6ca200", bins = 24, boundary = 0, color = "black") +
      scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M"),
                   limits = c(as_hms("00:00:00"), as_hms("24:00:00"))) +
      scale_y_continuous(expand = c(0, 0)) +
      coord_cartesian(clip = "off") +
      geom_vline(xintercept = as_hms("05:00:00"), linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = as_hms("12:00:00"), linetype = "dotted", linewidth = 1) + 
      geom_vline(xintercept = as_hms("18:00:00"), linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = as_hms("22:00:00"), linetype = "dotted", linewidth = 1) +
      annotate("text", x =  as_hms("04:30:00"), y = 0, hjust = 0, label = "Morning", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("11:30:00"), y = 0, hjust = 0, label = "Afternoon", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("17:30:00"), y = 0, hjust = 0, label = "Evening", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("21:30:00"), y = 0, hjust = 0, label = "Night", size = 5, fontface = "bold", angle = 90) +
      labs(x = "Time",
           y = "Streams") +
      theme_bw() +
      theme(text = element_text(family = "Manrope"),
            axis.title.x = element_text(size = 16, margin = margin(t = 10)),
            axis.title.y = element_text(size = 16, margin = margin(r = 10)),
            axis.text = element_text(size = 14),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_blank(),
            panel.background = element_rect(color = "lightgrey", fill = NA),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # part of day images
  output$time_output <- renderUI({
    
    max <- monthly_spotify_data() %>%
      group_by(day) %>%
      summarize(streams = n()) %>%
      slice_max(order_by = streams)
    
    # determine part of day
    peak_time <- monthly_spotify_data() %>%
      filter(day == max$day) %>%
      mutate(hour = hour(time),
             time_of_day = case_when(hour >= 5 & hour < 12 ~ "morning",
                                     hour >= 12 & hour < 18 ~ "afternoon",
                                     hour >= 18 & hour < 22 ~ "evening",
                                     hour >= 22 | hour < 5 ~ "night")) %>%
      group_by(time_of_day) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste0("You mostly listened to music during the ", time_of_day,".")) %>%
      pull(time_of_day)
    
    # message
    message_text <- HTML(paste0("You mostly listened to music during the ", "<b>", peak_time, "</b>", "."))
    
    # select image
    img_src <- switch(peak_time,
                      "morning"   = "pod/morning.jpg",
                      "afternoon" = "pod/afternoon.jpg",
                      "evening"   = "pod/evening.jpg",
                      "night"     = "pod/night.jpg")
    
    # image and text
    tagList(tags$img(src = img_src, class = "lorde-img", style = "height: 350px; border-radius: 10px;"),
            div(style = "padding-top: 20px;", message_text))
    
  })
  
}