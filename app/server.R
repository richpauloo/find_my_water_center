# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # combine strings to form address
  address_reactive <- eventReactive(input$go, {
    address <- paste(input$street, input$city, "California", input$zip)
    geocode(address, output = "latlon", source = "google")
  })
  
  # distance matrix
  close <- eventReactive(input$go, {
    top5 <- nn2(data = c@coords,
               query = data.frame(x = address_reactive()$lon,
                                  y = address_reactive()$lat),
               k = 5, searchtype = "radius", radius = 2)
    c[as.vector(top5$nn.idx), ]
  })
  # 
  #top5 <-  # top 5 closest spatial points
  
  # Map
  output$map <- renderLeaflet({
    # subset data according to user input - might need to isolate this if it takes forever
  
    # generate leaflet
    c %>%
      leaflet() %>% 
      addTiles %>% 
      addCircleMarkers(
        radius = 7, # fixed radius size
        stroke = FALSE,
        fillOpacity = 0.8,
        popup = paste0(c@data$name, "<br>",
                       c@data$addr_line0,"<br>",
                       c@data$address_ci, ", ", c@data$address_zi, "<br>",
                       c@data$gmap_url)
      ) %>%
      addCircleMarkers(lng = address_reactive()$lon,
                       lat = address_reactive()$lat,
                       radius = 16, color = "orange",
                       label = paste0(input$street, " ",
                                      input$city,", ", "CA ",
                                      input$zip)) %>% 
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

      # addLegend("topright", pal = pal, # use custom palette
      #           values = ~Result,
      #           title = "TDS", # legend displays time frame and depth class as title
      #           labFormat = labelFormat(suffix = " mg/L"),
      #           opacity = 1
      # ) %>%
      
      addProviderTiles("CartoDB.Positron" #providers$Esri.WorldTerrain
                       
      )  %>% setView(lng = address_reactive()$lon, 
                     lat = address_reactive()$lat, zoom=10)
  })
  
  
  # text
  output$text <- eventReactive(input$go, {
    paste0("The closest water system to your address is: ", 
           close()@data$name[1], ", located at ", 
           close()@data$addr_line0[1], " ", close()@data$address_ci[1], 
           ", ", close()@data$address_zi[1], " (", HTML(close()@data$gmap_url[1]), ")", 
           ". Your closest 5 water systems are shown as red points on the map, which you can click to explore.")
  })
  
  # Data Table
  #output$dt <- DT::renderDataTable({ temp() })
  
  # Download Selected Data
  output$download_data <- downloadHandler(
    # This function returns a string which tells the client browser what name to use when saving the file.
    filename = function() {
      paste0(
        paste(input$database, input$depth_class, input$time_bin, input$result[1], input$result[2], sep = "."),
        ".csv")
    },
    
    # This function should write data to a file given to it by the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.table(temp(), file, sep = ",", row.names = FALSE)
    }
  )
  
  # Download All Data
  output$download_all_data <- downloadHandler(
    # This function returns a string which tells the client browser what name to use when saving the file.
    filename = function() {
      paste0("all_TDS_dat", ".csv")
    },
    
    # This function should write data to a file given to it by the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.table(dat, file, sep = ",", row.names = FALSE)
    }
  )
  
}
