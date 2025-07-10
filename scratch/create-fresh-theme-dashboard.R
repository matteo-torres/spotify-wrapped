# load libraries ----
library(fresh)

# create theme ----
create_theme(
  
  # dashboardHeader color
  adminlte_color(light_blue = "#8ACE00"),
  
  # dashboardBody color
  adminlte_global(content_bg = "#FFFFFF"),
  
  # dashboardSidebar color
  adminlte_sidebar(dark_bg = "#000000",
                   dark_hover_bg = "#8ACE00",
                   dark_color = "#FFFFFF"),
  
  # Save theme to www directory ----
  output_file = here::here("shinydashboard", "www", "dashboard-fresh-theme.css")
  
)