# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # combine strings to form address
  address_reactive <- eventReactive(input$go, {
    address <- paste(input$street, input$city, "California", input$zip)
    geocode(address, output = "latlon", source = "google")
  })
  
  #distance matrix
  close <- eventReactive(input$go, {
    top5 <- nn2(data = c@coords,
               query = data.frame(x = address_reactive()$lon,
                                  y = address_reactive()$lat),
               k = 5, searchtype = "radius", radius = 5)
    c[as.vector(top5$nn.idx), ]
  })
  
  # address inputs recoded as reactive variables
  add <- eventReactive(input$go, {
    data.frame(street = input$street, 
               city = input$city,
               zip = input$zip)
  })

  
  # Map
  output$map <- renderLeaflet({
    # subset data according to user input - might need to isolate this if it takes forever
  
    # generate leaflet
    c %>%
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        radius = 7, # fixed radius size
        stroke = FALSE,
        fillOpacity = 0.8,
        popup = paste0(c@data$name, "<br>",
                       c@data$addr_line0,"<br>",
                       c@data$address_ci, ", ", c@data$address_zi, "<br>",
                       c@data$gmap_url)) %>%
      #addPolygons(data = p, stroke = FALSE) %>%
      addMarkers(lng = address_reactive()$lon,
                 lat = address_reactive()$lat,
                 #radius = 16, color = "orange",
                 label = paste0(add()$street, " ",
                                add()$city,", ", "CA ",
                                add()$zip)) %>%
      addCircleMarkers(data = close(),
        radius = 7, # fixed radius size
        stroke = FALSE,
        fillOpacity = 0.8,
        color = "red",
        popup = paste0(close()@data$name, "<br>",
                       close()@data$addr_line0,"<br>",
                       close()@data$address_ci, ", ", close()@data$address_zi, "<br>",
                       close()@data$gmap_url)
        ) %>%
      setView(lng = address_reactive()$lon, 
              lat = address_reactive()$lat, zoom=10)
  })
  
  # text
  output$text <- eventReactive(input$go, {
    paste0("The closest water system to your address is: ", 
           close()@data$name[1], ", located at ", 
           close()@data$addr_line0[1], " ", close()@data$address_ci[1], 
           ", ", close()@data$address_zi[1], " (", HTML(close()@data$gmap_url[1]), ").", "<br>", "<br>",
           "Your closest 5 water systems are shown as red points on the map, which you can click to explore.")
  })
  

}
