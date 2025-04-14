# dashboardHeader ----
header <- dashboardHeader(
  
  title = span("Spotify Wrapped", style = "font-size: 26px")
  
) # END dashboardHeader

# dashboardSidebar ----
sidebar <- dashboardSidebar(
  
  # sidebarMenu ----
  sidebarMenu(
    
    menuItem(text = "Home", tabName = "home", icon = icon("house")),
    menuItem(text = "Monthly Stats", tabName = "stats", icon = icon("arrow-trend-up")),
    menuItem(text = "Data", tabName = "data", icon = icon("headphones"))
    
  ) # END sidebarMenu
  
) # END dashboardSidebar

# dashboardBody ----
body <- dashboardBody(
  
  use_theme("dashboard-fresh-theme.css"),
  
  tags$head(tags$style(HTML(".main-sidebar {font-size: 16px;}"))),
  
  # tabItems ----
  tabItems(
    
    # home tabItem ----
    tabItem(tabName = "home",
            
            # left buffer column ----
            column(width = 1),
            
            # left-hand column ----
            column(width = 5,
                   
                   includeMarkdown("text/welcome.md")
                   
            ), # END left-hand column
            
            # center buffer column ----
            column(width = 1),
            
            # right-hand column ----
            column(width = 4,
                   
                   # first fluidRow ----
                   fluidRow(
                     
                     slickROutput(outputId = "carousel_images_output",
                                  width = "80%")
                     
                   ), # END first fluidRow
                   
                   # second fluidRow ----
                   fluidRow(
                     
                     tags$div(style = "text-align: center;",
                              tags$img(src = "https://media4.giphy.com/media/j25atM0JZYLeEvyEc7/giphy.gif",
                                       width = "40%")),
                     
                     tags$iframe(style="border-radius:12px", 
                                 src="https://open.spotify.com/embed/playlist/7CvSIl6mwMGNTaCCpmAQH7?utm_source=generator&theme=0", 
                                 width="100%", 
                                 height="450", 
                                 frameBorder="0", 
                                 allowfullscreen="", 
                                 allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture", 
                                 loading="lazy")
                     
                   ) # END second fluidRow
                   
            ), # END right-hand column
            
            # right buffer column
            column(width = 1)
            
    ), # END home tabItem
    
    # stats tabItem ----
    tabItem(tabName = "stats",
            
            # left buffer column ---
            column(width = 1),
            
            # left-hand column ----
            column(width = 4,
                   
                   # month input box ----
                   box(width = NULL,
                       
                       pickerInput(inputId = "month_input",
                                   label = "Select a month:",
                                   choices = names(spotify_data),
                                   selected = names(spotify_data)[3],
                                   multiple = FALSE,
                                   options = pickerOptions(actionsBox = TRUE,
                                                           size = 2))
                       
                   ), # END month input box
                   
                   # DT box ----
                   box(width = NULL,
                       
                       radioGroupButtons(inputId = "table_input", 
                                         label = "Choose an option:", 
                                         choices = c("Top 10 Artists", "Top 10 Tracks"), 
                                         selected = "Top 10 Artists",
                                         size = "normal"),
                       
                       DTOutput(outputId = "table_output") %>%
                         withSpinner(color = "black", type = 1, size = 1)
                       
                   ), # END DT box
                   
                   # top song box ----
                   box(width = NULL,
                       
                       uiOutput("song_output")
                       
                   ), # top song box END
                   
                   # valueboxes box
                   box(width = NULL,
                       
                       valueBoxOutput("artist_output",
                                      width = 6),
                       
                       valueBoxOutput("track_output",
                                      width = 6)
                   ) # END valueBoxes box
                   
            ), # END left-hand column
            
            # center buffer column ----
            column(width = 1),
            
            # right-hand column ----
            column(width = 5,
                   
                   # month output box ----
                   box(width = NULL,
                       
                       plotOutput(outputId = "month_output") %>%
                         withSpinner(color = "black", type = 1, size = 1)
                       
                   ), # END month output box
                   
                   # peak day box ----
                   box(width = NULL,
                       
                       uiOutput("peak_output")
                       
                   ), # END peak day box
                   
                   # day output box ----
                   box(width = NULL,
                       
                       plotOutput(outputId = "day_output") %>%
                         withSpinner(color = "black", type = 1, size = 1)
                       
                   ), # END day output box
                   
            ), # END right-hand column
            
            # right buffer column ----
            column(width = 1)
            
    ), # END stats tabItem
    
    # data tabItem ----
    tabItem(tabName = "data",
            
            tags$h1(strong("COMING SOON..."))
            
    ) # END data tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)