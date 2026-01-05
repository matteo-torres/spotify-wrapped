# dashboardHeader ----
header <- dashboardHeader(
  
  # dashboard logo
  title = div(style = "display: flex; justify-content: center; align-items: center; height: 100%;",
              img(src = "logos/spotify-logo.png", height = 130, width = 230)),
  
  # navbar adjustments
  tags$li(class = "dropdown",
          tags$style(".main-header .logo {height: 140px;}"),
          tags$style(".sidebar-toggle {color: #FFFFFF; font-size: 30px; padding-top: 10px !important;}"))
  
) # END dashboardHeader

# dashboardSidebar ----
sidebar <- dashboardSidebar(
  
  # import google fonts
  tags$head(tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css2?family=Bowlby+One+SC&display=swap"),
            tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css2?family=Manrope:wght@200..800&display=swap")),
  
  # sidebar adjustments
  tags$style(HTML(".left-side, .main-sidebar {padding-top: 140px; font-size: 18px; font-family: Manrope;}
                  @media (max-width: 768px) {.left-side, .main-sidebar {padding-top: 207px; font-size: 16px;}}")),
  tags$head(tags$style(HTML(".skin-blue .main-sidebar .sidebar .sidebar-menu a:hover {border-left: 3px solid #EAE8F5;}"))),
  
  # sidebarMenu
  sidebarMenu(
    
    menuItem(text = "Home", tabName = "home"),
    menuItem(text = "Monthly Streaming", tabName = "monthly")
    
  ), # END sidebarMenu
  
  # linked icons
  div(style = "position: absolute; bottom: 30px; width: 100%; display: flex; justify-content: space-between; padding: 0 50px; font-size: 40px;",
      HTML('<a href="https://github.com/matteo-torres/spotify-wrapped" target="_blank" title="GitHub"><i class="fa-brands fa-github-alt"></i></a>'),
      HTML('<a href="https://open.spotify.com/user/matteotorres27?si=536ec6db511d4b19" target="_blank" title="Spotify"><i class="fa-brands fa-spotify"></i></a>'))
  
) # END dashboardSidebar

# dashboardBody ----
body <- dashboardBody(
  
  # fresh theme
  use_theme("dashboard-fresh-theme.css"),
  
  # body adjustments
  tags$head(tags$style(HTML(".content-wrapper, .right-side {padding-top: 100px; padding-bottom: 30px;}
                            @media (min-width: 768px) {.content-wrapper, .right-side {padding-top: 70px;}}"))),
  
  # read more
  tags$script(HTML("$(document).on('click', '#read_more_welcome', function() {$('#more_text_welcome').toggle();});")),
  
  # tabItems
  tabItems(
    
    # home tabItem ----
    tabItem(tabName = "home",
            
            # first fluidRow
            fluidRow(style = "padding-bottom: 25px; padding-top: 20px;",
                     
                     # left buffer column
                     column(width = 1),
                     
                     # column
                     column(width = 10,
                            
                            # welcome text box
                            box(width = 6,
                                style = "height: 500px; border: 4px solid #EAE8F5; overflow: hidden;",
                                
                                # container
                                div(style = "height: 100%; display: flex; flex-direction: column; padding: 10px;",
                                    
                                    # title
                                    div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; text-align: center;",
                                        "Welcome"),
                                    
                                    # intro
                                    div(style = "font-family: Manrope; font-size: 18px;",
                                        "Welcome to my Spotify Wrapped 2025 Shiny dashboard! This project aims to analyze my monthly streaming activity."),
                                    
                                    # read more
                                    actionLink(style = "color: #74AC08; font-weight: bold; font-size: 18px; font-family: Manrope; padding-top: 10px; padding-bottom: 10px;",
                                               inputId = "read_more_welcome",
                                               label = "Read More"),
                                    
                                    # markdown container
                                    div(id = "more_text_welcome",
                                        style = "display: none; overflow-y: auto; flex-grow: 1; font-size: 18px; font-family: Manrope; ",
                                        includeMarkdown("text/welcome.md"))
                                    
                                ) # END container
                                
                            ), # END welcome text box
                            
                            # spotify playlist
                            column(width = 6,
                                   
                                   # spotify preview
                                   tags$iframe(style="border-radius:12px", 
                                               src="https://open.spotify.com/embed/playlist/7CvSIl6mwMGNTaCCpmAQH7?utm_source=generator&theme=0", 
                                               width="100%", 
                                               height="500px", 
                                               frameBorder="0", 
                                               allowfullscreen="", 
                                               allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture", 
                                               loading="lazy")
                                   
                            ), # END spotify playlist
                            
                     ), # END column
                     
                     # right buffer column
                     column(width = 1)
                     
            ), # END first fluidRow
            
            # second fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # column
              column(width = 10,
                     
                     # hall of fame box
                     box(width = 12,
                         style = "height: 500px; border: 4px solid #EAE8F5;",
                         
                         # title
                         div(style = "text-align: center; font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px;",
                             "Hall of Fame"),
                         
                         # text
                         div(style = "text-align: center; font-family: Manrope; font-size: 18px; padding-bottom: 10px;",
                             "Click on an album to read my review!"),
                         
                         # stars
                         div(style = "text-align: center; padding-bottom: 25px; color: #74AC08; -webkit-text-stroke: 1px black;",
                             icon("star", class = "fa-solid fa-star fa-1x"),
                             icon("star", class = "fa-solid fa-star fa-1x"),
                             icon("star", class = "fa-solid fa-star fa-1x"),
                             icon("star", class = "fa-solid fa-star fa-1x"),
                             icon("star", class = "fa-solid fa-star fa-1x")),
                         
                         # slickR carousel images
                         slickROutput(outputId = "carousel_images_output", width = NULL)
                         
                     ), # END hall of fame box
                     
              ), # END column
              
              # right buffer column
              column(width = 1),
              
            ), # END second fluidRow
            
    ), # END home tabItem
    
    # monthly tabItem ----
    tabItem(tabName = "monthly",
            
            # first fluidRow
            fluidRow(style = "padding-bottom: 20px; padding-top: 20px;",
                     
                     # left buffer column
                     column(width = 1),
                     
                     # column
                     column(width = 10,
                            
                            # mobile adjustments
                            tags$style(HTML("
                            @media (max-width: 768px) {
                            
                            .monthly-title {
                            font-size: 24px !important;
                            }
                            
                            .monthly-subtitle {
                            font-size: 16px !important;
                            }
                            
                            .yunjin-img {
                            width: 80px !important;
                            height: 80px !important;
                            }
                            
                            .fa-circle-check {
                            font-size: 2em !important;
                            }
                            
                            }")),
                            
                            # monthly streaming image and text
                            div(style = "display: flex; justify-content: space-between; align-items: center;",
                                
                                div(style = "display: flex; align-items: center;",
                                    
                                    img(class = "yunjin-img",
                                        style = "border-radius: 10px;",
                                        src = "images/yunjin.jpeg", width = "100px", height = "100px"),
                                    
                                    div(style = "display: flex; flex-direction: column; padding: 15px;",
                                        
                                        div(class = "monthly-title",
                                            style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 35px;",
                                            "Monthly Streaming"),
                                        
                                        div(class = "monthly-subtitle",
                                            style = "font-family: Manrope; font-size: 18px;",
                                            "Choose A Month"))),
                                
                                tags$i(class = "fas fa-circle-check", style = "color: #74AC08; text-align: right; font-size: 3em"))
                            
                     ), # END column
                     
                     # right buffer column
                     column(width = 1)
                     
            ), # END first fluidRow
            
            # second fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # column
              column(width = 10,
                     
                     # sliderInput customizations
                     tags$style(".js-irs-0 .irs-bar {background: #8ACE00; border: 1px #8ACE00; box-shadow: none !important;}"),
                     tags$style(".js-irs-0 .irs-line {background: black; border: 1px solid black;}"),
                     tags$style(".js-irs-0 .irs-grid-pol {background-color: black;}"),
                     tags$style(".js-irs-0 .irs-grid-text {color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-min {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-max {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-single {background: #8ACE00; color: black; font-family: Bowlby+One+SC; font-weight: bold; font-size: 12px;}"),
                     tags$style(".js-irs-0 .irs-handle {background: #8ACE00; border: #8ACE00;}"),
                     tags$style(".js-irs-0 .irs-handle:hover {background-color: #8ACE00;}"),
                     tags$head(tags$script(HTML("$(document).on('shiny:connected', function() {var slider = $('#month_input').data('ionRangeSlider'); slider.update({grid: true, grid_num: 11});});"))),
                     
                     # monthy sliderInput
                     sliderInput(inputId = "month_input",
                                 label = NULL,
                                 min = 1,
                                 max = 12,
                                 value = 12,
                                 step = 1,
                                 ticks = FALSE,
                                 width = "100%"),
                     
                     # button icons
                     div(style = "display: flex; justify-content: space-between; align-items: center; color: black; padding-bottom: 30px;",
                         
                         icon("shuffle", class = "fa-2x"),
                         
                         div(style = "display: flex; gap: 20px; justify-content: center; align-items: center; flex: 1;",
                             icon("backward-step", class = "fa-3x"),
                             icon("circle-play", class = "fas fa-circle-play fa-5x"),
                             icon("forward-step", class = "fa-3x")),
                         
                         icon("repeat", class = "fa-2x"))
                     
              ), # END column
              
              # right buffer column
              column(width = 1)
              
            ), # END second fluidRow
            
            # third fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # first box
              box(width = 10,
                  style = "border: 4px solid #EAE8F5;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 4,
                           style = "padding-top: 15px;",
                           
                           # rank valueBox
                           div(style = "padding: 20px;",
                               valueBoxOutput("rank_output",
                                              width = 12)),
                           
                           # total streams valueBox
                           div(style = "padding: 20px;",
                               valueBoxOutput("streams_output",
                                              width = 12)),
                           
                           # song valueBox
                           div(style = "padding: 20px;",
                               valueBoxOutput("track_output",
                                              width = 12)),
                           
                           # artist valueBox
                           div(style = "padding: 20px;",
                               valueBoxOutput("artist_output",
                                              width = 12))
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 8,
                           
                           # first fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             # column
                             column(width = 10,
                                    
                                    # radioGroupButtons
                                    div(style = "display: flex; justify-content: center; text-align:center; padding-top: 10px; font-family: Manrope;",
                                        radioGroupButtons(inputId = "table_input",
                                                          choices = c("Top 10 Artists", "Top 10 Songs"),
                                                          selected = "Top 10 Artists",
                                                          size = "normal",
                                                          label = "Choose An Option:")),
                                    
                                    # DT
                                    div(style = "font-family: Manrope; padding-top: 10px; padding-bottom: 25px;", 
                                        DTOutput(outputId = "table_output") %>%
                                          withSpinner(color = "black", type = 1, size = 1))
                                    
                             ), # END column
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END first fluidRow
                           
                           # second fluidRow
                           fluidRow(
                             
                             # left buffer column
                             column(width = 1),
                             
                             # top song box
                             box(width = 10,
                                 style = "border: 3px solid #EAE8F5;; text-align: center;",
                                 
                                 # title
                                 div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 20px; color: #6ca200; margin-bottom: 10px;",
                                     "Top Song by Top Artist"),
                                 
                                 # output
                                 div(style = "font-family: Manrope; font-size: 15px;",
                                     uiOutput("song_output"))
                                 
                             ), # END top song box
                             
                             # right buffer column
                             column(width = 1)
                             
                           ), # END second fluidRow
                           
                    ) # END right-hand column
                    
                  ) # END fluidRow
                  
              ), # END first box
              
              # right buffer column
              column(width = 1)
              
            ), # END second fluidRow
            
            # third fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # second box
              box(width = 10,
                  style = "border: 4px solid #EAE8F5;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 5,
                           
                           # mobile adjustments
                           tags$style(HTML("
                           @media (max-width: 768px) {
                           
                           .key-findings-container {
                           font-size: 13px !important;
                           }
                           
                           
                           .key-findings-container > div {
                           gap: 0px !important;
                           }
                           
                           }")),
                           
                           # title
                           div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 30px; color: #6ca200; text-align: center; margin-top: 10px; margin-bottom: 30px;",
                               "Key Findings"),
                           
                           # key findings
                           div(class = "key-findings-container",
                               style = "display: flex; flex-direction: column; gap: 50px; font-family: Manrope; font-size: 15px;",
                               
                               # highest streaming day
                               div(style = "display: flex; align-items: center; gap: 15px;",
                                   div(style = "width: 50px; text-align: center;", icon("star", class = "fa-solid fa-2x")),
                                   uiOutput("peak_output") ),
                               
                               # percent
                               div(style = "display: flex; align-items: center; gap: 15px;",
                                   div(style = "width: 50px; text-align: center; color: #6ca200;", icon("percent", class = "fa-2x")),
                                   uiOutput("pct_output")),
                               
                               # lowest streaming day(s)
                               div(style = "display: flex; align-items: center; gap: 15px;",
                                   div(style = "width: 50px; text-align: center;", icon("circle", class = "fa-2x")),
                                   uiOutput("low_output")),
                               
                               # average daily streams
                               div(style = "display: flex; align-items: center; gap: 15px;",
                                   div(style = "width: 50px; text-align: center; color: #6ca200;", icon("headphones", class = "fa-2x")),
                                   uiOutput("avg_output")))
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 7,
                           
                           # title
                           div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 30px; color: #6ca200; text-align: center; margin-top: 10px;",
                               "Daily Streams"),
                           
                           # daily streams lineplot
                           plotOutput(outputId = "month_output") %>%
                             withSpinner(color = "black", type = 1, size = 1)
                           
                    ) # END right-hand column
                    
                  ) # END fluidRow
                  
              ), # END second box
              
              # right buffer column
              column(width = 1)
              
            ), # END third fluidRow
            
            # fourth fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # third box
              box(width = 10,
                  style = "border: 4px solid #EAE8F5;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # left-hand column
                    column(width = 7,
                           
                           # title
                           div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 30px; color: #6ca200; text-align: center; margin-top: 10px;",
                               "Highest Streaming Day"),
                           
                           # highest streaming day histogram
                           plotOutput(outputId = "day_output") %>%
                             withSpinner(color = "black", type = 1, size = 1)
                           
                    ), # END left-hand column
                    
                    # right-hand column
                    column(width = 5,
                           
                           # mobile adjustments
                           tags$style(HTML("
                           @media (max-width: 768px) {
                           
                           .lorde-img{
                           height: 325px !important;
                           }
                           
                           }")),
                           
                           # lorde output
                           div(style = "font-family: Manrope; font-size: 15px; text-align:center; padding-top: 10px; padding-bottom: 10px; margin-top: 25px;",
                               uiOutput(outputId = "time_output"))
                           
                    ) # END right-hand column
                    
                  ) # END fluidRow
                  
              ), # END third box
              
              # right buffer column
              column(width = 1)
              
            ) # END fourth fluidRow
            
    ) # END monthly tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body, title = "Spotify Wrapped")