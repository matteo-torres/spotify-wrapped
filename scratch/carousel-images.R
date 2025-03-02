# load packages ----
library(slickR)

# image path ----
image_list <- list.files("shinydashboard/www/images", full.names = TRUE, pattern = "jpeg")

# slickR carousel ----
slickR(image_list,
       height = 350,
       width = "100%",
       slideId = "Carousel") + 
  settings(slidesToShow = 1,
           slidesToScroll = 1,
           arrows = FALSE,
           autoplay = TRUE,
           autoplaySpeed = 3000,
           fade = TRUE)