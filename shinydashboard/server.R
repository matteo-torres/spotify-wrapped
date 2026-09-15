server <- function(input, output) {
  
  # image path ----
  image_list <- reactive({
    
    list.files("www/albums", full.names = TRUE, pattern = "jpeg")
    
  })
  
  # build slickR carousel ----
  output$carousel_images_output <- renderSlickR({
    
    # links
    #links <- c("reviews/Addison.html",
               #"reviews/Blackout.html",
               #"reviews/BRAT.html",
               #"reviews/Choke.html",
               #"reviews/Desire.html",
               #"reviews/EQ.html",
               #"reviews/EUSEXUA.html",
               #"reviews/HOT.html",
               #"reviews/Immunity.html",
               #"reviews/LUX.html",
               #"reviews/Melodrama.html",
               #"reviews/OIL.html",
               #"reviews/Pop2.html",
               #"reviews/Virgin.html")
    
    # slickR carousel ----
    slickR(image_list(),
           height = "300px",
           slideId = "Carousel") +#,
           #objLinks = links) +
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
  monthly_spotify_data_df <- reactive({
    
    req(input$month_input)
    monthly_spotify_data[[input$month_input]]
    
  })
  
  # build rank valueBox ----
  output$rank_output <- renderValueBox({
    
    rank_df <- data.frame(month = seq_along(monthly_spotify_data),
                          total_streams = sapply(monthly_spotify_data, nrow)) %>%
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
    
    valueBox(monthly_spotify_data_df() %>%
               summarize(total_streams = n()),
             subtitle = "Total Streams",
             color = "black")
    
  })
  
  # build song valueBox ----
  output$track_output <- renderValueBox({
    
    valueBox(monthly_spotify_data_df() %>%
               distinct(track) %>%
               summarize(total_songs= n()),
             subtitle = "Songs",
             color = "black")
    
  })
  
  # build artist valueBox ----
  output$artist_output <- renderValueBox({
    
    valueBox(monthly_spotify_data_df() %>%
               distinct(artist) %>%
               summarize(total_artists = n()),
             subtitle = "Artists",
             color = "black")
    
  })
  
  # build table ----
  output$table_output <- renderDT({
    
    # DT
    if (input$table_input == "Top 10 Artists") {
      monthly_spotify_data_df() %>%
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
      monthly_spotify_data_df() %>%
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
    
    message <- monthly_spotify_data_df() %>%
      group_by(artist) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      inner_join(monthly_spotify_data_df(), by = "artist") %>%
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
    
    monthly_spotify_data_df() %>%
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
    
    monthly_spotify_data_df() %>%
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
    
    monthly_spotify_data_df() %>%
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
    
    message <- monthly_spotify_data_df() %>%
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
    max <- monthly_spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      slice_max(order_by = total_streams)
    
    # min day
    min <- monthly_spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      slice_min(order_by = total_streams)
    
    # plot monthly streaming habits
    monthly_spotify_data_df() %>%
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
    monthly_spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      ggplot(aes(x = time)) +
      geom_histogram(fill = "#6ca200", bins = 24, boundary = 0, color = "black") +
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
    peak_time <- monthly_spotify_data_df() %>%
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
  
  # monthly streams
  output$monthly_output <- renderPlot({
    
    first_place <- spotify_data %>%
      group_by(month) %>%
      summarize(total_streams = n()) %>%
      slice_max(order_by = total_streams)
    
    second_place <- spotify_data %>%
      group_by(month) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice(2:2)
    
    third_place <- spotify_data %>%
      group_by(month) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice(3:3)
    
    last_place <- spotify_data %>%
      group_by(month) %>%
      summarize(total_streams = n()) %>%
      slice_min(order_by = total_streams)
    
    spotify_data %>%
      group_by(month) %>%
      summarize(total_streams = n()) %>%
      ggplot(aes(x = total_streams, y = fct_rev(factor(month, levels = month.name)))) +
      geom_segment(aes(x = 0, xend = total_streams), linewidth = 1.5, lineend = "round") +
      geom_star(data = first_place, size = 7, starstroke = 1, fill = "#D6AF36", angle = 90) +
      geom_star(data = second_place, size = 7, starstroke = 1, fill = "#A7A7AD", angle = 90) +
      geom_star(data = third_place, size = 7, starstroke = 1, fill = "#A77044", angle = 90) +
      geom_point(data = last_place, size = 7, shape = 21, color= "red", stroke = 2) +
      scale_x_continuous(expand = c(0, 0), limits = c(0, 1800), n.breaks = 7) +
      labs(x = "Total Streams") +
      theme_bw() +
      theme(axis.title.y = element_blank(),
            axis.title.x = element_text(size = 12, margin = margin(t = 10)),
            axis.text = element_text(size = 12),
            axis.ticks.y = element_blank(),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_blank(),
            panel.background = element_rect(color = "lightgrey", fill = NA),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # top 10 artists
  output$artists_10_output <- renderPlot({
    
    # artist color palette
    artist_colors <- c("#f6b23a", "#fcbacd", "#b64d3c", "#8ACE00", "#a7a4cb", "#b85dc6", "#2191c7", "#71a5b4", "#d51f2c", "#fa1bd5")
    
    spotify_data %>%
      group_by(artist) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 10) %>%
      treemap(index = "artist", 
              vSize = "total_streams",
              type = "index",
              palette = artist_colors,
              fontcolor.labels = "black",
              border.lwds = 3,
              title = "")
    
  })
  
  # artists streamed
  output$artists_output <- renderPlot({
    
    spotify_data %>%
      group_by(artist) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice(-(1:10)) %>%
      ggplot() +
      geom_text_wordcloud(aes(label = artist, size = total_streams), shape = "circle") +
      theme_void()
    
  })
  
  # top 10 songs
  output$songs_10_output <- renderPlot({
    
    artist_palette <- c("#f6b23a", "#b9b9b9", "#8ACE00", "#b85dc6", "#2191c7")
    
    spotify_data %>%
      group_by(track, artist) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 10) %>%
      ggplot() +
      geom_col(aes(x = total_streams, y = reorder(track, total_streams), fill = artist), color = "black", linewidth = 0.8) +
      geom_text(aes(x = total_streams, y = reorder(track, total_streams), label = total_streams), hjust = 1.5, family = "Manrope") +
      scale_x_continuous(expand = c(0, 0), limits = c(0, 180), n.breaks = 7) +
      scale_y_discrete(expand = c(0, 0), labels = function(x) stringr::str_wrap(x, width = 30)) +
      scale_fill_manual(values = artist_palette) +
      coord_cartesian(clip = "off") +
      labs(x = "Total Streams",
           fill = "Artist") +
      theme_bw() +
      theme(axis.title.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text = element_text(size = 10, family = "Manrope"),
            axis.title = element_text(size = 12, family = "Manrope", face = "bold"),
            legend.title = element_text(size = 12, hjust = 0.5, family = "Manrope", face = "bold"),
            legend.text = element_text(size = 10, family = "Manrope"),
            plot.margin = margin(b = 5, t = 5, unit = "mm"))
    
  })
  
  # song of the summer
  output$sots_output <- renderPlot({
    
    palette <- c("#ff0000", "#ff6700", "#ffa700")
    
    spotify_data %>%
      filter(date >= "2025-06-20 00:00:00" & date <= "2025-11-22 23:59:59") %>%
      group_by(track, artist) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 3) %>%
      mutate(fraction = total_streams/sum(total_streams),
             ymax = cumsum(fraction),
             ymin = c(0, head(ymax, n = -1)),
             position = (ymax + ymin)/2,
             label = total_streams) %>%
      ggplot() +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0, yend = 0), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0, yend = 0), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.0625, yend = 0.0625), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.0625, yend = 0.0625), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.125, yend = 0.125), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.125, yend = 0.125), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.1875, yend = 0.1875), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.1875, yend = 0.1875), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.25, yend = 0.25), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.25, yend = 0.25), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.3125, yend = 0.3125), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.3125, yend = 0.3125), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.375, yend = 0.375), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.375, yend = 0.375), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.4375, yend = 0.4375), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.4375, yend = 0.4375), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.5, yend = 0.5), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.5, yend = 0.5), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.5625, yend = 0.5625), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.5625, yend = 0.5625), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.625, yend = 0.625), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.625, yend = 0.625), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.6875, yend = 0.6875), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.6875, yend = 0.6875), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.75, yend = 0.75), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.75, yend = 0.75), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.8125, yend = 0.8125), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.8125, yend = 0.8125), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_segment(aes(x = 4, xend = 5.5, y = 0.875, yend = 0.875), color = "black", linewidth = 3, lineend = "round") +
      geom_segment(aes(x = 3, xend = 5.5, y = 0.875, yend = 0.875), color = "#ffa700", linewidth = 1, lineend = "round") +
      
      geom_segment(aes(x = 4, xend = 4.5, y = 0.9375, yend = 0.9375), color = "black", linewidth = 3, lineend = "square") +
      geom_segment(aes(x = 3, xend = 4.5, y = 0.9375, yend = 0.9375), color = "#ffa700", linewidth = 1, lineend = "square") +
      
      geom_rect(aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, fill = track), color = "black", linewidth = 1) +
      coord_polar(theta = "y", start = -pi/2) +
      xlim(c(2, 5.5)) +
      geom_text(x = 2, y = 2, label = "Lorde Summer", size = 3, family = "Manrope") +
      geom_text(aes(x = 3.5, y = position, label = label), size = 4, color = "black", family = "Manrope") +
      scale_fill_manual(values = palette) +
      theme_void() +
      theme(legend.position = "bottom",
            legend.title.position = "top",
            legend.text.position = "bottom",
            legend.key.width = unit(3.5, "cm"),
            legend.key.height = unit(1, "cm"),
            legend.title = element_blank(),
            legend.text = element_text(size = 10, family = "Manrope"),
            plot.margin = margin(t = 0, r = 10, b = 5, l = 10, unit = "mm"),
            plot.background = element_rect(fill = "skyblue", color = "skyblue"))
    
  })
  
  # streaming activity
  output$streaming_output <- renderPlot({
    
    ggplot(data = spotify_data, aes(x = time)) +
      geom_histogram(fill = "#6ca200", bins = 24, boundary = 0, color = "black") +
      scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M"),
                   limits = c(as_hms("00:00:00"), as_hms("24:00:00"))) +
      scale_y_continuous(expand = c(0, 0)) +
      coord_cartesian(clip = "off") +
      geom_vline(xintercept = as_hms("05:00:00"), linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = as_hms("12:00:00"), linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = as_hms("18:00:00"), linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = as_hms("22:00:00"), linetype = "dotted", linewidth = 1) +
      annotate("text", x =  as_hms("04:30:00"), y = 1300, hjust = 1, label = "Morning", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("11:30:00"), y = 1300, hjust = 1, label = "Afternoon", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("17:30:00"), y = 1300, hjust = 1, label = "Evening", size = 5, fontface = "bold", angle = 90) +
      annotate("text", x =  as_hms("21:30:00"), y = 1300, hjust = 1, label = "Night", size = 5, fontface = "bold", angle = 90) +
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
  
}