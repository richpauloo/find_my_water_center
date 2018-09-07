# Define UI for application that draws a histogram
ui <- 
  dashboardPage(
    dashboardHeader(title = "California Water System Locater",
                    titleWidth = 350),
    dashboardSidebar(
      width = 350,
      textInput("street", 
                label = h4("Begin by Entering an Address"), 
                placeholder = "Street Number"),
      textInput("city", 
                label = "", 
                placeholder = "City"),
      textInput("zip", 
                label = "", 
                placeholder = "Zip Code"),
      actionButton("go","Enter")
      
      
      
    ),
    
    # Body
    dashboardBody(
      # tags$head(
      #   tags$style(HTML("
      #                   blockquote {
      #                   padding: 10px 20px;
      #                   margin: 0 0 20px;
      #                   font-size: 13px;
      #                   border-left: 5px solid #eee;
      #                   }
      #                   "))),
      fluidRow(
        tabBox(width = 12, height = NULL,
               tabPanel("Map", 
                        #tags$style(type = "text/css", "#map {height: calc(100vh - 100px) !important;}"),
                        leafletOutput("map")),
               tabPanel(title = "About", 
                        includeMarkdown("about.md"))
        )
      ),
      fluidRow(
        box(width = 12, height = NULL,
            htmlOutput("text"))
      )
    )
  )
