#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderinput",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = c(30,40)),
            
            selectInput(
              inputId = "paid_board_date_min",
              label = "Select time period start point:",
              choices = c(1:5),
              multiple = FALSE,
              selectize = FALSE
            ), # end selectInput paid_board_date_min
            
            selectInput(
              inputId = "paid_board_date_max",
              label = "Select time period start point:",
              choices = c(1:5),
              multiple = FALSE,
              selectize = FALSE
            ), # end selectInput paid_board_date_min
        ),

        # Show a plot of the generated distribution
        mainPanel(
          verbatimTextOutput("sliderout"),
          verbatimTextOutput("selectout")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$sliderout <- renderText({ input$sliderinput })
  output$selectout <- renderText({ c(input$paid_board_date_min, input$paid_board_date_max) })
}

# Run the application 
shinyApp(ui = ui, server = server)
