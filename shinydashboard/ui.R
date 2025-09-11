# dashboardHeader ----
header <- dashboardHeader(
  
  # title
  title = div(style = "display: flex; justify-content: center; align-items: center; height: 100%;",
              img(src = "spotify-logo.png", height = 130, width = 230)),
  
  # navbar adjustments
  tags$li(class = "dropdown",
          tags$style(".main-header .logo {height: 130px;}"),
          tags$style(".sidebar-toggle {color: #FFFFFF; font-size: 30px; padding-top: 10px !important;}"))
  
) # END dashboardHeader

# dashboardSidebar ----
sidebar <- dashboardSidebar(
  
  # google fonts
  tags$head(tags$link(rel = "stylesheet", 
                      href="https://fonts.googleapis.com/css2?family=Bowlby+One+SC&display=swap"),
            tags$link(rel = "stylesheet", 
                      href="https://fonts.googleapis.com/css2?family=Manrope:wght@200..800&display=swap")),
  
  # sidebar adjustments
  tags$style(".left-side, .main-sidebar {padding-top: 130px; font-size: 18px; font-family: Manrope;}"),
  tags$head(tags$style(HTML(".skin-blue .main-sidebar .sidebar .sidebar-menu a:hover {border-left: 3px solid #EAE8F5;}"))),
  
  # sidebarMenu
  sidebarMenu(
    
    menuItem(text = "Home", tabName = "home"),
    menuItem(text = "Monthly Streaming", tabName = "monthly")
    
  ), # END sidebarMenu
  
  # linked icons
  div(style = "position: absolute; bottom: 30px; width: 100%; display: flex; justify-content: space-between; padding: 0 50px; font-size: 50px;",
      HTML('<a href="https://github.com/matteo-torres/spotify-wrapped" target="_blank" title="GitHub"><i class="fa-brands fa-github-alt"></i></a>'),
      HTML('<a href="https://open.spotify.com/user/matteotorres27?si=536ec6db511d4b19" target="_blank" title="Spotify"><i class="fa-brands fa-spotify"></i></a>'))
  
) # END dashboardSidebar

# dashboardBody ----
body <- dashboardBody(
  
  # fresh theme
  use_theme("dashboard-fresh-theme.css"),
  
  # body adjustments
  tags$style(".content-wrapper, .right-side {padding-top: 70px; padding-bottom: 40px;"),
  
  # tabItems
  tabItems(
    
    # home tabItem ----
    tabItem(tabName = "home",
            
            # second fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # welcome text
              column(width = 6,
                     
                     # title
                     div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; padding-bottom: 10px;",
                         "Welcome"),
                     
                     # welcome markdown
                     div(style = "font-family: Manrope; font-size: 18px; padding-bottom: 10px;",
                         includeMarkdown("text/home/welcome.md"))
                     
              ), # END welcome text
              
              # gif column
              column(width = 4,
                     
                     # spotify gif
                     div(style = "text-align: center; padding-top: 30px;",
                         tags$img(src = "https://media4.giphy.com/media/j25atM0JZYLeEvyEc7/giphy.gif",
                                  class = "mx-auto d-block",
                                  width = "60%"))
                     
              ), # END gif column
              
              # right buffer column
              column(width = 1)
              
            ), # END second fluidRow
            
            # third fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # line column
              column(width = 10,
                     
                     # line
                     tags$hr(style = "border-top: 4px solid; color: #EAE8F5; padding-top: 10px; padding-bottom: 10px;")
                     
              ), # END line column
              
              # right buffer column
              column(width = 1)
              
            ), # END third fluidRow
            
            # fourth fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # iframe text box
              box(width = 5,
                  style = "height: 500px; border: 4px solid #EAE8F5;",
                  
                  # title
                  div(style = "text-align: center; font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; padding-bottom: 10px;",
                      HTML('Playlist <i class="fa-solid fa-music"></i>')),
                  
                  div(style = "font-family: Manrope; font-size: 18px;",
                      includeMarkdown("text/home/playlist.md"))
                  
              ), # END iframe text box
              
              # iframe column
              column(width = 5,
                     
                     # spotify preview
                     tags$iframe(style="border-radius:12px", 
                                 src="https://open.spotify.com/embed/playlist/7CvSIl6mwMGNTaCCpmAQH7?utm_source=generator&theme=0", 
                                 width="100%", 
                                 height="500px", 
                                 frameBorder="0", 
                                 allowfullscreen="", 
                                 allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture", 
                                 loading="lazy")
                     
              ), # END iframe column
              
              # right buffer column
              column(width = 1),
              
            ), # END fourth fluidRow
            
            # fifth fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # slickR column
              column(width = 5,
                     
                     # slickR carousel images
                     slickROutput(outputId = "carousel_images_output", width = NULL)
                     
              ), # END slickR column
              
              # slickR text box
              box(width = 5,
                  style = "height: 500px; border: 4px solid #EAE8F5;",
                  
                  # container
                  div(style = "font-size: 18px; font-family: Bowlby+One+SC; height: 100%; display: flex; flex-direction: column;",
                      
                      # title
                      div(style = "text-align: center; font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; padding-bottom: 10px;",
                          HTML('Hall of Fame <i class="fa-solid fa-compact-disc"></i>')),
                      
                      div(style = "text-align: center; padding-bottom: 10px; color: #74AC08; -webkit-text-stroke: 1px black;",
                          icon("star", class = "fa-solid fa-star fa-1x"),
                          icon("star", class = "fa-solid fa-star fa-1x"),
                          icon("star", class = "fa-solid fa-star fa-1x"),
                          icon("star", class = "fa-solid fa-star fa-1x"),
                          icon("star", class = "fa-solid fa-star fa-1x")),
                      
                      # markdown container
                      div(style = "overflow-y: auto; flex-grow: 1; padding-right: 10px; padding-left: 5px; border: 3px solid #EAE8F5; border-radius: 8px; font-family: Manrope;",
                          includeMarkdown("text/home/albums.md"))
                      
                  ) # END container
                  
              ), # END slickR text box
              
              # right buffer column
              column(width = 1)
              
            ) # END fifth fluidRow
            
    ), # END home tabItem
    
    # monthly tabItem ----
    tabItem(tabName = "monthly",
            
            # first fluidRow
            fluidRow(style = "padding-bottom: 20px;",
                     
                     # left buffer column
                     column(width = 1), 
                     
                     # image column
                     column(width = 1,
                            
                            # cover art
                            div(img(src = "yunjin.jpeg", width = "100px", height = "100px", style = "border-radius: 10px;"))
                            
                     ), # END image column
                     
                     # title column
                     column(width = 8,
                            
                            # title
                            div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; padding-bottom: 10px; padding-left: 10px;",
                                "Monthly Streaming"),
                            
                            # subtitle
                            div(style = "font-family: Manrope; font-size: 20px; padding-left: 10px;",
                                "Choose A Month")
                            
                     ), # END title column
                     
                     # icon column
                     column(width = 1,
                            
                            # saved icon
                            tags$i(class = "fas fa-circle-check fa-3x", style = "color: #74AC08; padding-top: 30px;")
                            
                     ), # END icon column
                     
                     # right buffer column
                     column(width = 1)
                     
            ), # END first fluidRow
            
            # second fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # center column
              column(width = 10,
                     
                     # sliderInput customizations
                     tags$style(".js-irs-0 .irs-bar {background: #8ACE00; border: 1px #8ACE00; box-shadow: none !important;}"),
                     tags$style(".js-irs-0 .irs-line {background: black; border: 1px solid black;}"),
                     tags$style(".js-irs-0 .irs-grid-pol {background-color: black;}"),
                     tags$style(".js-irs-0 .irs-grid-text {color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-min {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-max {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-single {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-handle {background: white; background-image: url('spotify_black_logo_icon_147079.webp');
                                background-size: cover; background-position: center; width: 40px; height: 40px; border-radius: 100%; border: 1px solid black;}"),
                     tags$style(".js-irs-0 .irs-handle:hover {background-color: white; background-image: url('spotify_black_logo_icon_147079.webp'); 
                                background-size: cover; background-position: center;}"),
                     
                     # monthy sliderInput
                     sliderInput(inputId = "month_input",
                                 label = NULL,
                                 min = 1,
                                 max = 8,
                                 value = 8,
                                 step = 1,
                                 ticks = TRUE,
                                 width = "100%"),
                     
                     # button icons
                     div(style = "display: flex; justify-content: space-between; align-items: center; color: black; padding-bottom: 30px;",
                         
                         icon("shuffle", class = "fa-2x"),
                         
                         div(style = "display: flex; gap: 20px; justify-content: center; align-items: center; flex: 1;",
                             icon("backward-step", class = "fa-3x"),
                             icon("circle-play", class = "fas fa-circle-play fa-5x"),
                             icon("forward-step", class = "fa-3x")),
                         
                         icon("repeat", class = "fa-2x"))
                     
              ), # END center column
              
              # right buffer column
              column(width = 1)
              
            ), # END second fluidRow
            
            # third fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # DT box
              box(width = 10,
                  style = "border: 4px solid #EAE8F5;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 4,
                           
                           # first fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             # radioGroupButtons column
                             column(width = 10,
                                    style = "display: flex; justify-content: center; padding-top: 10px; font-family: Manrope;",
                                    
                                    # radioGroupButtons
                                    radioGroupButtons(inputId = "table_input",
                                                      choices = c("Top 10 Artists", "Top 10 Tracks"),
                                                      selected = "Top 10 Artists",
                                                      size = "normal")
                                    
                             ), # END radioGroupButtons column
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END first fluidRow
                           
                           # second fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    style = "padding-top: 10px; font-family: Manrope;",
                                    
                                    valueBoxOutput("artist_output",
                                                   width = 12)
                                    
                             ),
                             
                             column(width = 1)
                             
                             
                           ), # END second fluidRow
                           
                           # third fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    style = "padding-top: 10px; font-family: Manrope;",
                                    
                                    valueBoxOutput("track_output",
                                                   width = 12)
                                    
                             ),
                             
                             column(width = 1)
                             
                           ) # END third fluidRow
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 8,
                           
                           # first fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    
                                    div(style = "font-family: Manrope; padding-top: 10px;", 
                                        DTOutput(outputId = "table_output") %>%
                                          withSpinner(color = "black", type = 1, size = 1))
                                    
                             ),
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END first fluidRow
                           
                           # second fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             column(width = 10,
                                    
                                    div(style = "font-family: Manrope; text-align:center; padding-top: 20px; padding-bottom: 10px;",
                                        uiOutput("song_output"))
                                    
                             ),
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END second fluidRow
                           
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
                  style = "border: 4px solid #EAE8F5;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 6,
                           
                           plotOutput(outputId = "month_output") %>%
                             withSpinner(color = "black", type = 1, size = 1),
                           
                           div(style = "font-family: Manrope; text-align:center; padding-top: 10px; padding-bottom: 10px;",
                               uiOutput("peak_output"))
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 6,
                           
                           plotOutput(outputId = "day_output") %>%
                             withSpinner(color = "black", type = 1, size = 1),
                           
                           div(style = "font-family: Manrope; text-align:center; padding-top: 10px; padding-bottom: 10px;",
                               uiOutput(outputId = "time_output"))
                           
                    ) # END right-hand column
                    
                  ) # END fluidRow
                  
              ), # END plots box
              
              # right buffer column
              column(width = 1)
              
            ), # END third fluidRow
            
    ) # END monthly tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body, title = "Spotify Wrapped")