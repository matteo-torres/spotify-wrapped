server <- function(input, output) {
  
  # image path ----
  image_list <- reactive({
    
    list.files("www/albums", full.names = TRUE, pattern = "jpeg")
    
  })
  
  # build slickR carousel ----
  output$carousel_images_output <- renderSlickR({
    
    # links
    links <- c("reviews/Addison.html",
               "reviews/Blackout.html",
               "reviews/BRAT.html",
               "reviews/Choke.html",
               "reviews/Desire.html",
               "reviews/EQ.html",
               "reviews/EUSEXUA.html",
               "reviews/HOT.html",
               "reviews/Immunity.html",
               "reviews/LUX.html",
               "reviews/Melodrama.html",
               "reviews/OIL.html",
               "reviews/Pop2.html",
               "reviews/Virgin.html")
    
    # slickR carousel ----
    slickR(image_list(),
           height = "300px",
           slideId = "Carousel",
           objLinks = links) +
      settings(slidesToShow = 3,
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
  
  # filter spotify data ----
  spotify_data_df <- reactive({
    
    req(input$month_input)
    spotify_data[[input$month_input]]
    
  })
  
  # build rank valueBox ----
  output$rank_output <- renderValueBox({
    
    rank_df <- data.frame(month = seq_along(spotify_data),
                          total_streams = sapply(spotify_data, nrow)) %>%
      arrange(desc(total_streams)) %>%
      mutate(rank = ifelse(row_number() == 1, "1st",
                           ifelse(row_number() == 2, "2nd",
                                  ifelse(row_number() == 3, "3rd",
                                         paste0(row_number(), "th")))))
    
    valueBox(rank_df$rank[rank_df$month == input$month_input],
             subtitle = "Rank",
             color = "black")
    
  })
  
  # build total streams valueBox ----
  output$streams_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               summarize(total_streams = n()),
             subtitle = "Total Streams",
             color = "black")
    
  })
  
  # build song valueBox ----
  output$track_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(track) %>%
               summarize(total_songs= n()),
             subtitle = "Songs",
             color = "black")
    
  })
  
  # build artist valueBox ----
  output$artist_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(artist) %>%
               summarize(total_artists = n()),
             subtitle = "Artists",
             color = "black")
    
  })
  
  # build table ----
  output$table_output <- renderDT({
    
    # DT
    if (input$table_input == "Top 10 Artists") {
      spotify_data_df() %>%
        group_by(artist) %>%
        summarize(total_streams = n()) %>%
        arrange(desc(total_streams)) %>%
        ungroup() %>%
        slice_head(n = 10) %>%
        datatable(colnames = c("ARTIST", "STREAMS"), 
                  class = "row-border",
                  selection = "none",
                  options = list(dom = "t", 
                                 scrollY = 250, 
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    } else if (input$table_input == "Top 10 Songs") {
      spotify_data_df() %>%
        group_by(track, artist) %>%
        summarize(total_streams = n()) %>%
        arrange(desc(total_streams)) %>%
        ungroup() %>%
        slice_head(n = 10) %>%
        datatable(colnames = c("SONG", "ARTIST", "STREAMS"),
                  class = "row-border", 
                  selection = "none",
                  options = list(dom = "t", 
                                 scrollY = 250, 
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    }
    
  })
  
  # top track from top artist message ----
  output$song_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(artist) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      inner_join(spotify_data_df(), by = "artist") %>%
      group_by(artist, track) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste(paste0("<b>", '"', track, '"', "</b>"), "<br>",
                             "by", artist)) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # peak day message ----
  output$peak_output <- renderUI({
    
    spotify_data_df() %>%
      group_by(month, day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste0("Highest Streaming Day: ", "<b>", month, "</b>", " ", "<b>", day, "</b>", "<br>",
                              "Total Streams: ", "<b>", total_streams, "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # percent streams day message ----
  output$pct_output <- renderUI({
    
    spotify_data_df() %>%
      group_by(month, day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      summarize(month = month[1], day = day[1], pct = max(total_streams)/sum(total_streams)*100) %>%
      mutate(message = paste0("The highest streaming day accounted for ", "<b>", signif(pct, digits = 3), "</b>", "<b>%</b>", " of streams.")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # low day message ----
  output$low_output <- renderUI({
    
    spotify_data_df() %>%
      group_by(month, day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      filter(total_streams == min(total_streams)) %>%
      mutate(days_list = paste0(month, " ", day, collapse = ", ")) %>%
      slice_head(n = 1) %>%
      mutate(message = paste0("Lowest Streaming Day(s): ", "<b>", days_list, "</b>", "<br>",
                              "Total Streams: ", "<b>", total_streams, "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # average daily streams message ----
  output$avg_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      summarize(avg_daily_streams = mean(total_streams)) %>%
      mutate(message = paste("Average Daily Streams:", "<b>", signif(avg_daily_streams, digits = 2), "</b>")) %>%
      pull(message) %>%
      HTML()
    
  })
  
  # build lineplot ----
  output$month_output <- renderPlot({
    
    # max day
    max <- spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      slice_max(order_by = total_streams)
    
    # min day
    min <- spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      slice_min(order_by = total_streams)
    
    # plot monthly streaming habits
    spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      ggplot(aes(x = day, y = total_streams)) +
      geom_line(color = "#6ca200", linewidth = 2, lineend = "round") +
      geom_star(data = max, size = 5, fill = "black") +
      geom_point(data = min, shape = 1, size = 5, stroke = 1.5) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
      coord_cartesian(clip = "off") +
      labs(x = "Day",
           y = "Total Streams") +
      theme_bw() +
      theme(axis.title.x = element_text(size = 14, margin = margin(t = 10)),
            axis.title.y = element_text(size = 14, margin = margin(r = 10)),
            axis.text = element_text(size = 12),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_blank(),
            panel.background = element_rect(color = "lightgrey", fill = NA),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # build histogram ----
  output$day_output <- renderPlot({
    
    # plot highest streaming activity
    spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      ggplot(aes(x = time)) +
      geom_histogram(fill = "#6ca200", bins = 24) +
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
           y = "Total Streams") +
      theme_bw() +
      theme(axis.title.x = element_text(size = 14, margin = margin(t = 10)),
            axis.title.y = element_text(size = 14, margin = margin(r = 10)),
            axis.text = element_text(size = 12),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_blank(),
            panel.background = element_rect(color = "lightgrey", fill = NA),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # part of day images
  output$time_output <- renderUI({
    
    # determine part of day
    peak_time <- spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      mutate(hour = hour(time),
             time_of_day = case_when(
               hour >= 5 & hour < 12 ~ "morning",
               hour >= 12 & hour < 18 ~ "afternoon",
               hour >= 18 & hour < 22 ~ "evening",
               hour >= 22 | hour < 5 ~ "night"
             )) %>% 
      group_by(time_of_day) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
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