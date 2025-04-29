# dashboardHeader ----
header <- dashboardHeader(
  
  # title ----
  title = span(img(src = "spotify-logo.png", height = 115,)),
  titleWidth = 300,
  
  # navbar adjustments ----
  tags$li(class = "dropdown",
          tags$style(".main-header .logo {height: 115px;}"),
          tags$style(".sidebar-toggle {font-size: 25px; padding-top: 10px !important;}"))
  
) # END dashboardHeader

# dashboardSidebar ----
sidebar <- dashboardSidebar(
  
  # sidebar adjustments ----
  tags$style(".left-side, .main-sidebar {padding-top: 115px; font-size: 15px;}"),
  width = 300,
  
  # sidebarMenu ----
  sidebarMenu(
    
    menuItem(text = "Home", tabName = "home", icon = icon("house")),
    menuItem(text = "Monthly Streaming", tabName = "stats", icon = icon("arrow-trend-up")),
    menuItem(text = "Data", tabName = "data", icon = icon("headphones"))
    
  ) # END sidebarMenu
  
) # END dashboardSidebar

# dashboardBody ----
body <- dashboardBody(
  
  tags$style(".content-wrapper, .right-side {padding-top: 25px;}"),
  
  use_theme("dashboard-fresh-theme.css"),
  
  tags$head(tags$style(HTML(".main-sidebar {font-size: 16px;}"))),
  
  # tabItems ----
  tabItems(
    
    # home tabItem ----
    tabItem(tabName = "home",
            
            # first fluidRow ----
            fluidRow(
              
              # left buffer column ----
              column(width = 1),
              
              # box ----
              box(width = 10,
                  
                  # fluidRow ----
                  fluidRow(
                    
                    # left-hand column ----
                    column(width = 9,
                           
                           includeMarkdown("text/welcome.md")
                           
                    ), # END left-han column
                    
                    # right-hand column ----
                    column(width = 3,
                           
                           div(style = "text-align: center;",
                               tags$img(src = "https://media4.giphy.com/media/j25atM0JZYLeEvyEc7/giphy.gif",
                                        class = "mx-auto d-block",
                                        width = "100%"))
                           
                    ), # END right-hand column
                    
                  ), # END fluidRow
                  
              ), # END box
              
              # center buffer column ----
              column(width = 1),
              
            ), # END first fluidRow
            
            # second fluidRow ----
            fluidRow(
              
              # left buffer column ----
              column(width = 1),
              
              # column  ----
              column(width = 10,
                     
                     # box ----
                     box(width = NULL,
                         
                         # fluidRow ----
                         fluidRow(
                           
                           # left-hand column ----
                           column(width = 6,
                                  
                                  tags$iframe(style="border-radius:12px", 
                                              src="https://open.spotify.com/embed/playlist/7CvSIl6mwMGNTaCCpmAQH7?utm_source=generator&theme=0", 
                                              width="100%", 
                                              height="400", 
                                              frameBorder="0", 
                                              allowfullscreen="", 
                                              allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture", 
                                              loading="lazy")
                                  
                           ), # END left-hand column
                           
                           # right-hand column ----
                           column(width = 6,
                                  
                                  slickROutput(outputId = "carousel_images_output", width = "100%")
                                  
                           ), # END right-hand column
                           
                         ), # END fluidRow
                         
                     ), # END box
                     
              ), # END column
              
              # right buffer column ----
              column(width = 1),
              
            ), # END second fluidRow
            
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
    tabItem(tabName = "data") # END data tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)