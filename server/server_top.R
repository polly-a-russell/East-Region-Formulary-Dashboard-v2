# server for Top 10 Non Formulary items tab 

# dynamic select inputs -----
#bnf section select input for top data 

output$bnf_section_top_select <- renderUI({
  
  bnf_section_selector(top_non_formulary_paid, 
                       input$BNF_chapter_top, 
                       "BNF_section_top")
})

#bnf subsection select input for top data 

output$bnf_sub_section_top_select <- renderUI({
  
  bnf_sub_section_selector(top_non_formulary_paid, 
                           input$BNF_chapter_top, 
                           input$BNF_section_top, 
                           'BNF_sub_section_top')
})


############################################################################
# Reset button ----
observeEvent(
  input$reset_top, {
    updateSelectInput(session, 'BNF_chapter_top', selected = "All BNF Chapters")
    updatePickerInput(session, "measure_top", selected = "Number of items")
    updatePickerInput(session, "top_board", selected = "Region")
    updateSelectInput(session, 'top_quarter', selected = max(top_non_formulary_paid$`Financial Quarter`))
  }
)

############################################################################
# Dataframe ---- 

top_chartdata <- reactive({
  req(input$BNF_chapter_top)  # Ensure input is initialized
  
  # Filter data by chapter, board, time
  data <- top_non_formulary_paid  %>%
  filter(NHSBoard == input$top_board,
         rank_by == input$measure_top,
          `Financial Quarter` == input$top_quarter)  %>%
   group_by(NHSBoard)
  
  
if (!is.null(input$BNF_chapter_top) && input$BNF_chapter_top != "" ) {
#Filter by selected Section
  if (!is.null(input$BNF_section_top) && input$BNF_section_top != 'All BNF Sections' && input$BNF_chapter_top != 'All BNF Chapters') {
    data <- data %>%
      filter(BNF_section == input$BNF_section_top) %>% 
      group_by(BNF_section)
    
    # Filter by selected Sub-Section
    if (!is.null(input$BNF_sub_section_top) && input$BNF_sub_section_top != 'All BNF Sub Sections') {
      data <- data %>%
        filter(BNF_sub_section == input$BNF_sub_section_top) %>% 
        group_by(BNF_sub_section)
      
    } else {
      data <- data %>% 
        group_by(BNF_section)
    }
    
  } else {
    # Default to Chapter if no Section or Subsection is selected
    data <- data %>% filter(BNF_chapter == input$BNF_chapter_top) %>% 
      group_by(BNF_chapter)
  }
}  else {
    data <- data
}
  #shorten drug names
  data$`Product Name` <- sapply(data$`Product Name`,
                             FUN = function(x) str_replace(x, "MICROGRAMS", "μg"))
 # data$Product_Name <- wrap.labels(data$Product_Name, 20)

  # Return the data
  return(data)
})

# Make chart
## limit chart and table to 20 top items

output$top_chart  <- renderPlotly({
  # Ensure the input is available
  req(input$measure_top)
  
  data <- top_chartdata()
  
  #take 20 rows
  data <- data[0:20,] 
 
  # Check which measure is selected and plot accordingly
  if (input$measure_top == "Number of Items" ) {  
    
    plot_ly(data = data,
            type = 'bar', 
            orientation= 'h',
            x = ~`Number of Items`,
            y = ~`Product Name`, 
            width = 1100, height = 500,
            hovertext = ~paste(NHSBoard, "<br>",
                               `Financial Quarter`, "<br>",
                               `Product Name`, "<br>",
                              "Number of items: ", `Number of Items`
                              ),
            hoverinfo = "text",
            marker = list(color = phs_colours("phs-teal")
            )) %>%
          layout(
            yaxis = list(title = "", 
                         dtick = 0.5,
                          categoryorder = "total ascending"),
            xaxis = list(title = 'Number of items'),
            margin = list(left = -500,
                          #right= -200,
                          pad= 10)
                )  %>% 
      format_plotly()
      
} else {
        plot_ly(data = data,
                type = 'bar', 
                orientation= 'h',
                x = ~`Gross Ingredient Cost (£)`,
                y = ~`Product Name`, 
                width = 1100, height = 500,
                hovertext = ~paste(NHSBoard, "<br>",
                                   `Financial Quarter`, "<br>",
                                    `Product Name`, "<br>",
                                   "Cost (£): ", `Gross Ingredient Cost (£)`
                                   ),
                hoverinfo = "text",
                marker = list(color = phs_colours("phs-teal")
                              )
                ) %>%
          layout(
            yaxis = list(title = "", dtick = 0.5,
                         categoryorder = "total ascending"),
            xaxis = list(title = 'Total cost  per Treated Patient (£)'),
            margin = list(left = -500, #right= -200,
                          pad= 10)
            
            ) %>% 
    format_plotly()
        
  }
          
})

##Text options for chart title
metric_text_top <- reactive({

  if(input$measure_top == "Number of Items") {
    text <- "Number of Items"
  } else {
    text <- "Total Cost per Treated Patient (£)" 
  }
  return(text)

})

bnf_text_top <- reactive({
  if (!is.null(input$BNF_chapter_top) && input$BNF_chapter_top != "") {
    # Check if Section input is available and valid
    if (!is.null(input$BNF_section_top) && input$BNF_section_top != 'All BNF Sections' && input$BNF_chapter_top != 'All BNF Chapters') {
      if (!is.null(input$BNF_sub_section_top) && input$BNF_sub_section_top != 'All BNF Sub Sections') {
        bnf_text <- input$BNF_sub_section_top
      } else {
        bnf_text <- input$BNF_section_top
      }
    } else {
      # Default to Chapter if no Section or Subsection is selected
      bnf_text <- input$BNF_chapter_top
    }
  } else {
    bnf_text <- NULL  # or some default value if necessary
  }
})


# chart title by plot
output$top_plot_title <- renderText({
  NHSBoard <- input$top_board
  `Financial Quarter` <- input$top_quarter
  
  HTML(paste0("<h4> ", metric_text_top(), ", ",
              bnf_text_top(), ", ",
              NHSBoard, ", ",
              `Financial Quarter`,
              " </h4>" ))
})

## Data table ---- ######################################################

output$top_table <- DT::renderDataTable({
  
  if("Number of Items" %in% input$measure_top) {
    
    top_table <- top_chartdata() %>% 
      select(-`Gross Ingredient Cost (£)` ) 
    
  } else {
    top_table <- top_chartdata() %>% 
      select(-`Number of Items`)
  }
  
  top_table <- top_chartdata() %>% 
    select(-c(rank_by, bnf_level)) %>% 
    relocate(`Financial Quarter`) 

  #take 20 rows
  top_table <- top_table[0:20,] 
  
  #write out micrograms
  top_table$`Product Name` <- sapply(top_table$`Product Name`,
                           FUN = function(x) str_replace(x,  "μg", "MICROGRAMS"))
  
  make_table(top_table)
})


####################################################################
# Data download under each chart ----  
## allow up to 100 items 

output$download_top <- downloadHandler(
  
  filename = function() {
    paste("Top_Non_Formulary_data", "csv", sep=".")
  },
  content = function(file) {
    write.csv(top_chartdata(), file)
  }
)

####################################################################
## info button

observeEvent(input$top_more_info, {
  showModal(modalDialog(
    title = "Top 20 Non-Formulary Items",
    
    HTML(paste(
    "This data shows top twenty medicines prescribed outwith the Formulary
    based on Paid data (from PIS).<br>",
    
   "Number of items ranks items by number of paid items 
    and Cost ranks medications by highest total cost per treated patient.<br>",
  
   "The cost measure is calculated as the sum of GIC (Gross Ingredient Cost, excl. Broken Bulk) divided 
   by the number of patients prescribed the medicines in question.<br>",
   
   "The graph shows Product Name (the description of the product as prescribed) from PIS and whether it was prescribed as VMP (Virtual Medicinal Product,
   a generic description of the medicine) or AMP (Actual Medicinal Product, branded products or generic products from specific suppliers). 
   The table also shows the VMP name.<br>",
 
   "There may be some medicines in the chart/table that appear at first glance to be listed on the Formulary,
   but are listed as non-formulary for the following reasons:<br>",
     
  "- Prescriptions where the VMP name is in the formulary, but where the prescription is for an AMP with a non-formulary product name, are classed as non-formulary.<br>",
  "- Prescriptions where the Product Name is in the formulary as an AMP but prescribed as a VMP and the VMP listed is non-formulary are also classed as non-formulary.",
  
    sep = "<br/>"),
     collapse = "<br><br>"),
    easyClose = TRUE
  ))
})

#####################################################
### guided tour----

# start introjs when button is pressed with custom options and events

observeEvent(input$help_top, {
  
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "top","auto"), #"auto",
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#BNF_chapter_top",
                                  # "#top_quarter",
                                   "#top_chart",
                                   "#download_top"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                      # "Use this dropdown to select which financial year/quarter you want to see data for.",
                                 
                    "Hover over the bars on lines to see exact figures.",
                                 
                      "You can download a csv file of the dataset according to 
                      your active selections using this button. The download gives you the top 100 items."
                       ))
  ))
})