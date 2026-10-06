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
                                solidHeader = TRUE,
                                style = "height: 350px; border: 4px solid #000000; overflow: hidden;",
                                
                                # container
                                div(style = "height: 100%; display: flex; flex-direction: column; padding: 10px;",
                                    
                                    # title
                                    div(style = "font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px; text-align: center;",
                                        "Welcome"),
                                    
                                    # intro
                                    div(style = "font-family: Manrope; font-size: 18px; text-align: center;",
                                        "Welcome to my Spotify Wrapped Shiny dashboard!"),
                                    
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
                            
                            # mobile adjustments
                            tags$style(HTML("
                            @media (max-width: 768px) {
                            
                            .spotify-img {
                            transform: scale(0.75);
                            transform-origin: center center;
                            }
                            
                            }")),
                            
                            # spotify widget
                            column(width = 6,
                                   
                                   # ipod
                                   tags$div(
                                     style = "height: 300px; display: flex; justify-content: center; align-items: center; overflow: visible;",
                                     
                                     tags$img(class = "spotify-img",
                                              src = "https://spotify-widgetify-3vfdnn5tx-matteo-4e5d.vercel.app/github?theme=ipod&color=FF69B4&style=light",
                                              alt = "Spotify Now Playing"))
                                   
                            ) # END spotify widget
                            
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
                         solidHeader = TRUE,
                         style = "height: 500px; border: 4px solid #000000;",
                         
                         # title
                         div(style = "text-align: center; font-family: Bowlby+One+SC; font-weight: bold; font-size: 40px;",
                             "Hall of Fame"),
                         
                         # stars
                         div(style = "text-align: center; padding-bottom: 10px; color: #74AC08; -webkit-text-stroke: 2px black;",
                             icon("star", class = "fa-solid fa-star fa-2x"),
                             icon("star", class = "fa-solid fa-star fa-2x"),
                             icon("star", class = "fa-solid fa-star fa-2x"),
                             icon("star", class = "fa-solid fa-star fa-2x"),
                             icon("star", class = "fa-solid fa-star fa-2x")),
                         
                         # text
                         div(style = "text-align: center; font-family: Manrope; font-size: 18px; padding-bottom: 25px;",
                             "Click an album and press play!"),
                         
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
              
              # box
              box(width = 10,
                  solidHeader = TRUE,
                  style = "border: 4px solid #000000;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # first column
                    column(width = 3,
                           style = "padding-top: 20px;",
                           
                           # rank valueBox
                           valueBoxOutput("rank_output",
                                          width = 12)
                           
                    ), # END first column
                    
                    # second column
                    column(width = 3,
                           style = "padding-top: 20px;",
                           
                           # streams valueBox
                           valueBoxOutput("streams_output",
                                          width = 12)
                           
                    ), # END second column
                    
                    # third column
                    column(width = 3,
                           style = "padding-top: 20px;",
                           
                           valueBoxOutput("track_output",
                                          width = 12)
                           
                    ), # END third column
                    
                    # fourth column
                    column(width = 3,
                           style = "padding-top: 20px;",
                           
                           valueBoxOutput("artist_output",
                                          width = 12)
                           
                    ), # END fourth column
                    
                  ) # END fluidRow
                  
              ), #END box
              
              # right buffer column
              column(width = 1)
              
            ), # END third fluidRow
            
            # fourth fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # left column
              column(width = 5,
                     
                     # mobile adjustments
                     tags$style(HTML("
                     @media (max-width: 768px) {
                     
                     .spotify-table-box {
                     height: auto !important;
                     overflow: visible !important;
                     }
                     
                     .spotify-table-box .dataTables_wrapper {
                     width: 100% !important;
                     }
                     
                     .spotify-table-box table {
                     width: 100% !important;
                     font-size: 16px !important;
                     }
                     
                     .spotify-table-box table td,
                     .spotify-table-box table th {
                     padding: 8px 5px !important;
                     }
                     
                     }")),
                     
                     # box
                     box(width = NULL,
                         solidHeader = TRUE,
                         class = "spotify-table-box",
                         style = "border: 4px solid #000000; height: 670px;",
                         
                         # radioGroupButtons
                         div(style = "display: flex; justify-content: center; text-align: center; padding-top: 10px; font-family: Manrope;",
                             
                             radioGroupButtons(inputId = "table_input",
                                               choices = c("Top 10 Artists", "Top 10 Tracks"),
                                               selected = "Top 10 Artists",
                                               size = "normal",
                                               label = "Choose An Option:")),
                         
                         # DT
                         div(style = "font-family: Manrope; padding-top: 25px; padding-left: 10px; padding-right: 10px;",
                             
                             DTOutput(outputId = "table_output") %>%
                               withSpinner(color = "black",
                                           type = 1,
                                           size = 1))
                         
                     ) # END box
                     
              ), # END left column
              
              # right column
              column(width = 5,
                     
                     # box
                     box(width = NULL,
                         solidHeader = TRUE,
                         style = "border: 4px solid #000000;",
                         
                         # title
                         div(style = "font-family: Manrope; font-weight: bold; font-size: 18px; text-align: center; padding-bottom: 10px;",
                             "Top Track by Top Artist"),
                         
                         uiOutput("song_output")
                         
                     ), # END box
                     
                     # box
                     box(width = NULL,
                         solidHeader = TRUE,
                         style = "border: 4px solid #000000;",
                         
                         # title
                         div(style = "font-family: Manrope; font-weight: bold; font-size: 18px; text-align: center; padding-bottom: 10px;",
                             "Top Album"),
                         
                         uiOutput("album_output")
                         
                     ) # END box
                     
              ), # END right column
              
              # right buffer column
              column(width = 1)
              
            ), # END fourth fluidRow
            
            # fifth fluidRow
            fluidRow(
              
              # left column
              column(width = 1),
              
              # box
              box(width = 10,
                  solidHeader = TRUE,
                  style = "border: 4px solid #000000;",
                  
                  # title
                  div(style = "font-family: Manrope; font-weight: bold; font-size: 18px; text-align: center; padding-bottom: 10px;",
                      "Daily Streams"),
                  
                  # daily streams lineplot
                  plotOutput(outputId = "month_output") %>%
                    withSpinner(color = "black", type = 1, size = 1)
                  
              ), # END box
              
              # right column
              column(width = 1)
              
            ), # END fifth fluidRow
            
            # sixth fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # box
              box(width = 10,
                  solidHeader = TRUE,
                  style = "border: 4px solid #000000;",
                  
                  # fluidRow
                  fluidRow(
                    
                    # title
                    div(style = "font-family: Manrope; font-weight: bold; font-size: 18px; text-align: center; padding-bottom: 25px;",
                        "Key Findings"),
                    
                    # left column
                    column(width = 6,
                           
                           # highest streaming day
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center; color: #FFD700;", icon("star", class = "fa-solid fa-2x")),
                               uiOutput("peak_output")),
                           
                           # percentage of streams for highest streaming day
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center; color: #AAA9AD;", icon("percent", class = "fa-2x")),
                               uiOutput("pct_output")),
                           
                           # streaming streak
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center; color: #CF1920;", icon("fire-flame-curved", class = "fa-2x")),
                               uiOutput("streak_output"))
                           
                    ), # END left column
                    
                    # right column
                    column(width = 6,
                           
                           # lowest streaming day(s)
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center; color: #47a4cf;", icon("circle", class = "fa-2x")),
                               uiOutput("low_output")),
                           
                           # quiet day(s)
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center;", icon("play", class = "fa-2x")),
                               uiOutput("quiet_output")),
                           
                           # average streams per day
                           div(style = "display: flex; align-items: center; gap: 15px; margin-bottom: 25px; font-family: Manrope; font-size: 12px;",
                               div(style = "width: 50px; text-align: center; color: #FF69B4;", icon("headphones", class = "fa-2x")),
                               uiOutput("avg_output"))
                           
                    ) # END right column
                    
                  ) # END fluidRow
                  
              ), # END box
              
              # right buffer column
              column(width = 1)
              
            ), # END sixth fluiRow
            
            # seventh fluidRow
            fluidRow(
              
              # left buffer column
              column(width = 1),
              
              # box
              box(width = 6,
                  solidHeader = TRUE,
                  style = "border: 4px solid #000000; height: 500px;",
                  
                  # title
                  div(style = "font-family: Manrope; font-weight: bold; font-size: 18px; text-align: center; padding-bottom: 25px;",
                      "Highest Streaming Day"),
                  
                  # highest streaming day histogram
                  plotOutput(outputId = "day_output") %>%
                    withSpinner(color = "black", type = 1, size = 1)
                  
              ), # END box
              
              # box
              box(width = 4,
                  solidHeader = TRUE,
                  style = "border: 4px solid #000000; height: 500px;",
                  
                  # mobile adjustments
                  tags$style(HTML("
                           @media (max-width: 768px) {
                           
                           .lorde-img{
                           height: 325px !important;
                           }
                           
                           }")),
                  
                  # lorde output
                  div(style = "font-family: Manrope; font-size: 14px; text-align:center; padding-top: 10px; padding-bottom: 10px; margin-top: 25px;",
                      uiOutput(outputId = "time_output"))
                  
              ), # END box
              
              # right buffer column
              column(width = 1)
              
            ) # END seventh fluidRow
            
    ) # END monthly tabItem
    
  ) # END tabItems
  
) # END dashboardBody

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body, title = "Spotify Wrapped")