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
    menuItem(text = "Monthly Streaming", tabName = "monthly", icon = icon("arrow-trend-up")),
    menuItem(text = "Data", tabName = "data", icon = icon("headphones"))
    
  ) # END sidebarMenu
  
) # END dashboardSidebar

# dashboardBody ----
body <- dashboardBody(
  
  tags$style(".content-wrapper, .right-side {padding-top: 25px;}"),
  
  use_theme("dashboard-fresh-theme.css"),
  
  tags$head(tags$style(HTML(".main-sidebar {font-size: 18px;}"))),
  
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
                           
                           img(src = "welcome.png",
                               width = "25%"),
                           
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
    
    # monthly tabItem ----
    tabItem(tabName = "monthly",
            
            # first fluidRow ----
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # pickerInput box ----
              box(width = 10,
                  
                  # first fluidRow
                  fluidRow(
                    
                    column(width = 1),
                    
                    column(width = 10,
                           
                           img(src = "month.png",
                               width = "15%"),
                           
                           tags$style(".js-irs-0 .irs-bar {background: #8ACE00;}"),
                           tags$style(".js-irs-0 .irs-line {background: black;}"),
                           tags$style(".js-irs-0 .irs-single {background: #8ACE00; color: black; font-weight: bold; font-size: 12px;"),
                           tags$style(".js-irs-0 .irs-grid-text {color: black; font-size: 12px; font-weight: bold;"),
                           tags$style(".js-irs-0 .irs-grid-pol {background-color: black;"),
                           tags$style(".js-irs-0 .irs-min {background: #8ACE00; color: black; font-weight: bold; font-size: 12px;"),
                           tags$style(".js-irs-0 .irs-max {background: #8ACE00; color: black; font-weight: bold; font-size: 12px;"),
                           tags$style(".js-irs-0 .irs-handle {background-image: url('spotify_black_logo_icon_147079.webp');
                  background-size: cover; background-position: center; width: 40px; height: 40px; border-radius: 100%;"),
                           
                           sliderInput(
                             inputId = "month_input",
                             label = NULL,
                             min = 1,
                             max = 4,
                             value = 4,
                             step = 1,
                             ticks = TRUE)
                           
                           ),
                    
                    column(width = 1)
                    
                  ), # END first fluidRow
                  
                  # second fluidRow
                  fluidRow(
                    
                    column(width = 5),
                    
                    column(width = 2,
                           
                           img(src = "play.png",
                               width = "100%")
                           
                           ),
                    
                    column(width = 5)
                    
                  ), # END second fluidRow
                  
              ), # END pickerInput box
              
              # right buffer column
              column(width = 1)
              
            ), # END first fluidRow
            
            # second fluidRow ----
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # DT box ----
              box(width = 10,
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 4,
                           
                           # first fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    
                                    radioGroupButtons(inputId = "table_input", 
                                                      choices = c("Top 10 Artists", "Top 10 Tracks"), 
                                                      selected = "Top 10 Artists",
                                                      size = "normal")
                                    
                                    ),
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END first fluidRow
                           
                           # second fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                               
                               valueBoxOutput("artist_output",
                                              width = NULL)
                               
                             ),
                             
                             column(width = 1)
                             
                             
                           ), # END second fluidRow
                           
                           # third fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    
                                    valueBoxOutput("track_output",
                                                   width = NULL)
                                    
                             ),
                             
                             column(width = 1)
                             
                           ) # END third fluidRow
                           
                           ), # END left-hand column
                    
                    # right-hand column
                    column(width = 8,
                           
                           tags$style("table.dataTable tbody tr:hover {background-color: #8ACE00 !important;}"),
                           tags$style("table.dataTable tbody tr.selected td, table.dataTable tbody td.selected {box-shadow: inset 0 0 0 9999px black !important;}"),
                           tags$style("table.dataTable tbody tr:active td {color: black !important;}"),
                           tags$style(":root {--dt-row-selected: transparent !important;}"),
      
                           
                           DTOutput(outputId = "table_output") %>%
                             withSpinner(color = "black", type = 1, size = 1),
                           
                           uiOutput("song_output")
                           
                           ) # END right-hand column
                    
                  ) # END fluidRow
                  
                  ), # END DT box
              
              # right buffer column
              column(width = 1)
              
            ), # END second fluidRow
            
            # third fluidRow ----
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # plots box ----
              box(width = 10,
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 6,
                           
                           plotOutput(outputId = "month_output") %>%
                             withSpinner(color = "black", type = 1, size = 1),
                           
                           uiOutput("peak_output")
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 6,
                           
                           plotOutput(outputId = "day_output") %>%
                             withSpinner(color = "black", type = 1, size = 1),
                           
                           uiOutput(outputId = "time_output")
                           
                    ) # END right-hand column
                    
                  ) # END fluidRow
                  
              ), # END plots box
              
              # right buffer column
              column(width = 1)
              
            ), # END third fluidRow
            
    ), # END monthly tabItem
    
    # data tabItem ----
    tabItem(tabName = "data") # END data tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)