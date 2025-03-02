server <- function(input, output) {
  
  # filter spotify data ----
  spotify_data_df <- reactive({
    
    req(input$month_input)
    spotify_data[[input$month_input]]
    
  })
  
  # build monthly plot ----
  output$month_output <- renderPlot({
    
    # plot monthly streaming habits
    spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      ggplot(aes(x = day, y = total_streams)) +
      geom_line(color = "#b08abe", linewidth = 2) +
      scale_x_continuous(expand = c(0, 0)) +
      labs(x = "Day",
           y = "Total Streams (n)",
           title = "Monthly Streaming Habits",
           subtitle = "Tracking daily listening activity") +
      theme_bw() +
      theme(plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 12, face = "italic"))
    
  })
  
  # build day plot ----
  output$day_output <- renderPlot({
    
    # plot daily streaming habits
    spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      ggplot(aes(x = time)) +
      geom_histogram(fill = "#0c9cd4") +
      scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M")) +
      scale_y_continuous(expand = c(0, 0)) +
      labs(x = "Time",
           y = "Total Streams (n)",
           title = "Streaming Activity During Peak Day",
           subtitle = "Analyzing the distribution of streaming activity throughout the day") +
      theme_bw() +
      theme(plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 12, face = "italic"))
    
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
        datatable(colnames = c("Artist", "Total Streams (n)"), style = "default")
    } else if (input$table_input == "Top 10 Tracks") {
      spotify_data_df() %>%
        group_by(track) %>%
        summarize(total_streams = n()) %>%
        arrange(desc(total_streams)) %>%
        ungroup() %>%
        slice_head(n = 10) %>%
        datatable(colnames = c("Track", "Total Streams (n)"), style = "default")
    } 
    
  })
  
  # build artist valueBox ----
  output$artist_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(artist) %>%
               summarize(total_artists = n()),
             subtitle = "Artists",
             icon = icon("user", style = "color: #8AEC00;"),
             color = "black")
    
  })
  
  # build track valueBox ----
  output$track_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(track) %>%
               summarize(total_songs= n()),
             subtitle = "Tracks",
             icon = icon("play", style = "color: #8AEC00;"),
             color = "black")
    
  })
  
  # image path ----
  image_list <- reactive({
    
    list.files("www/images", full.names = TRUE, pattern = "jpeg")
    
  })
  
  # build slickR carousel ----
  output$carousel_images_output <- renderSlickR({
    
    # slickR carousel ----
    slickR(image_list(),  
           height = 350,  
           width = "100%",  
           slideId = "Carousel") + 
      settings(slidesToShow = 1,
               slidesToScroll = 1,
               arrows = FALSE,
               autoplay = TRUE,
               autoplaySpeed = 3000,
               fade = TRUE)
    
  })
  
}