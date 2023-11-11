# Define the server logic for the Shiny app
function(input, output) {
  
  # Render the leaflet map based on user input
  output$reactorMap <- renderLeaflet({
    # Get the selected reactor types from the checkbox group
    selectedReactors <- input$checkGroup
    
    # Filter the dataframe based on selected reactor types
    df_filtered <- df[df$ReactorType %in% selectedReactors,]
    
    # Create and render the reactor map
    createReactorMap(df_filtered, input$yearSlider)
  })
  
  # Render the capacity plot
  output$plotCapacity <- renderPlot({
    capacityPlot()
  })
  
  # Render the reactor type plot
  output$plotReactor <- renderPlot({
    reactorType()
  })
}