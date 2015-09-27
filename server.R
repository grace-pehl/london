library(shiny)
suppressMessages(library(leaflet))
# library(tmap)
suppressMessages(library(dplyr))
london <- readRDS(file = 'data/crime.Rds')
london$sum <- NA

shinyServer(function(input, output) {
    # stuff run as needed
    output$londonmap <- renderLeaflet({
        if (is.null(input$crime_list)) {
            london$sum <- NA
        } else if (length(input$crime_list) == 1) {
            london$sum <- london@data[input$crime_list]
        } else {
            london$sum <- rowSums(london@data[ , input$crime_list])
        }
        pal <- colorNumeric(
            palette = rev("Reds"),
            domain = london$Total,
            na.color = "transparent"
        )
        leaflet(data = london) %>%
            addTiles() %>%
            addPolygons(stroke = TRUE, smoothFactor = 0.2, popup = ~Borough,
                        fillOpacity = .5, fillColor = ~pal(sum), weight = 1,
                        color = "black") %>%
            addLegend(pal = pal, values = ~Total,
                      title = 'Crime Rate<br>per Hundred<br>Persons')
    })
})
