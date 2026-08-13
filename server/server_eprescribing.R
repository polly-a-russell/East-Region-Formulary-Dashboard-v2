# server for ePrescribing tab


# select inputs -----

#bnf section select input - NHS Board
output$trend_bnf_section_eprescribing <- renderUI({
    bnf_section_selector(board_formulary_eprescribingdata, input$trend_bnf_chapter_eprescribing, 'trend_bnf_section_eprescribing')
})
## section input - cluster
output$trend_bnf_section_epr_cluster <- renderUI({
  bnf_section_selector(cluster_formulary_eprescribingdata, input$trend_bnf_chapter_epr_cluster, 'trend_bnf_section_epr_cluster')
})
## section input - practice
output$trend_bnf_section_epr_practice <- renderUI({
  bnf_section_selector(practice_formulary_eprescribingdata, input$trend_bnf_chapter_epr_practice, 'trend_bnf_section_epr_practice')
})

#bnf sub section select input - board
output$trend_bnf_sub_section_eprescribing <- renderUI({
  bnf_sub_section_selector(board_formulary_eprescribingdata, input$trend_bnf_chapter_eprescribing, input$trend_bnf_section_eprescribing, 'trend_bnf_sub_section_eprescribing')
})
## - cluster
output$trend_bnf_sub_section_epr_cluster <- renderUI({  
  bnf_sub_section_selector(cluster_formulary_eprescribingdata, input$trend_bnf_chapter_epr_cluster, input$trend_bnf_section_epr_cluster, 'trend_bnf_sub_section_epr_cluster')
})
## - practice
output$trend_bnf_sub_section_epr_practice <- renderUI({
  bnf_sub_section_selector(practice_formulary_eprescribingdata, input$trend_bnf_chapter_epr_practice, input$trend_bnf_section_epr_practice, 'trend_bnf_sub_section_epr_practice')
})

############################################################################
# Reset buttons ----
observeEvent(
  input$reset_epr_board, {
    updateSelectInput(session, 'trend_bnf_chapter_eprescribing', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_eprescribing", value = c(min(board_formulary_eprescribingdata$week),
                                                                   max(board_formulary_eprescribingdata$week)),
                                                                    timeFormat="%d %b %Y")
    updatePickerInput(session, "trend_eprescribing_board", selected = "Region")
  }
)

observeEvent(
  input$reset_epr_cluster, {
    updateSelectInput(session, 'trend_bnf_chapter_epr_cluster', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_epr_cluster", value = c(min(cluster_formulary_eprescribingdata$week),
                                                                     max(cluster_formulary_eprescribingdata$week)),
                                                                    timeFormat="%d %b %Y")
    updatePickerInput(session, "trend_eprescribing_cluster", selected = unique(cluster_formulary_eprescribingdata$cluster)[1])
  }
)

observeEvent(
  input$reset_epr_practice, {
    updateSelectInput(session, 'trend_bnf_chapter_epr_practice', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_epr_practice", value = c(min(practice_formulary_eprescribingdata$week),
                                                                      max(practice_formulary_eprescribingdata$week)),
                                                                      timeFormat="%d %b %Y")
    updatePickerInput(session, "trend_eprescribing_practice", selected = unique(practice_formulary_eprescribingdata$practice_name)[1])
  }
)

#####################################################################
# Section 3 - Dataframes  ----

epr_board_chartdata <- reactive({
  
  make_chartdata(board_formulary_eprescribingdata, input$trend_eprescribing_board, 
                 input$trend_bnf_chapter_eprescribing, input$trend_bnf_section_eprescribing, 
                 input$trend_bnf_sub_section_eprescribing, input$trend_Dates_eprescribing, 
                 "NHSBoard", "week")
})

# Cluster data ----

epr_cluster_chartdata <- reactive({
  make_chartdata(cluster_formulary_eprescribingdata, input$trend_eprescribing_cluster, 
                 input$trend_bnf_chapter_epr_cluster, input$trend_bnf_section_epr_cluster, 
                 input$trend_bnf_sub_section_epr_cluster, input$trend_Dates_epr_cluster, 
                 "cluster", "week")
 
})

# Practice data ----

epr_practice_chartdata <- reactive({
 
   make_chartdata(practice_formulary_eprescribingdata, input$trend_eprescribing_practice, 
                 input$trend_bnf_chapter_epr_practice, input$trend_bnf_section_epr_practice, 
                 input$trend_bnf_sub_section_epr_practice, input$trend_Dates_epr_practice,
                 "practice_name", "week"
   ) 
})


#####################################################################
# Section 4 - Chart and data table  ----

##Board
output$trendchart_eprescribing  <- renderPlotly({
  
  data <- epr_board_chartdata()
  req(nrow(data) > 0)  # Ensure data has rows

    plot_ly(data = data,
            type = 'scatter', 
            mode = 'lines+markers',
            x = data$week,
            y = data$percent_formulary_items,

            color = ~data$NHSBoard,
            colors = ~plot_colours(data$NHSBoard),
            text = ~paste0(data$NHSBoard,
                           '<br>w/b', format(data$week,"%d-%m-%Y"),
                           '<br>Percentage: ', data$percent_formulary_items, '%'),
            hoverinfo = 'text' ) %>% 
      layout(
        yaxis = list(title = 'Percentage of formulary items'),
        xaxis = list(title = "Week beginning", 
                     type = 'date', tickformat = "%d-%m-%Y"),
        legend = list(title = list(text = 'NHS Board'))
      )%>% 
      format_plotly()
})
##Cluster
output$trendchart_epr_cluster  <- renderPlotly({

  data <- epr_cluster_chartdata()
  req(nrow(data) > 0)  # Ensure data has rows
  
  plot_ly(data = data,
          type = 'scatter', 
          mode = 'lines+markers',
          x = data$week,
          y = data$percent_formulary_items,

          color = ~data$cluster,
          colors =~ plot_colours(unique(data$cluster)),
          text = ~paste0(data$cluster,
                        '<br>w/b', format(data$week,"%d-%m-%Y"),
                        '<br>Percentage: ', data$percent_formulary_items, '%'),
          hoverinfo = 'text' ) %>% 
    layout(
      yaxis = list(title = 'Percentage of formulary items'),
      xaxis = list(title = "Week beginning", 
                   type = 'date', tickformat = "%d-%m-%Y"),
      legend = list(title = list(text = 'Cluster'))
    ) %>% 
    format_plotly()
  
})
##Practice
output$trendchart_epr_practice  <- renderPlotly({

  data <- epr_practice_chartdata()
  req(nrow(data) > 0)  # Ensure data has rows
  
  plot_ly(data = data,
          type = 'scatter', 
          mode = 'lines+markers',
          x = data$week,
          y = data$percent_formulary_items,
          color = ~data$practice_name,
          colors =~ plot_colours(unique(data$practice_name)),
          text = ~paste0(data$practice_name,
                        '<br>w/b', format(data$week,"%d-%m-%Y"),
                        '<br>Percentage: ', data$percent_formulary_items, '%'),
          hoverinfo = 'text' ) %>% 
    layout(
      yaxis = list(title = 'Percentage of formulary items'),
      xaxis = list(title = "Week beginning", 
                   type = 'date', tickformat = "%d-%m-%Y"),
      legend = list(title = list(text = 'GP Practice'))
    ) %>% 
    format_plotly()
})


# Chart titles ----
output$eprescribing_plot_title <- renderText({
  HTML(paste0("<h4>Percentage of formulary items, ",
              bnf_text(input$trend_bnf_chapter_eprescribing,
                       input$trend_bnf_section_eprescribing,
                       input$trend_bnf_sub_section_eprescribing),
              " </h4>"))
})

# chart title by plot
output$epr_cluster_plot_title <- renderText({
  HTML(paste0("<h4>Percentage of formulary items, ",
              bnf_text(input$trend_bnf_chapter_epr_cluster,
                       input$trend_bnf_section_epr_cluster,
                       input$trend_bnf_sub_section_epr_cluster),
              " </h4>"))
})


# chart title by plot
output$epr_practice_plot_title <- renderText({
  HTML(paste0("<h4>Percentage of formulary items, ",
              bnf_text(input$trend_bnf_chapter_epr_practice,
                       input$trend_bnf_section_epr_practice,
                       input$trend_bnf_sub_section_epr_practice),
              " </h4>"))
})

# Tables ----
#Board
output$epr_board_table <- DT::renderDataTable({

  make_table(epr_board_chartdata() %>%
               rename(`Week beginning` = week) %>% 
               select(-c(bnf_level, formulary_items, items)) %>% 
               relocate(`Week beginning` ))
})

#Cluster
  
output$epr_cluster_table <- DT::renderDataTable({
    make_table(epr_cluster_chartdata() %>%
               rename(Cluster = cluster, `Week beginning` = week) %>% 
                 select(-c(bnf_level, formulary_items, items)) %>% 
               relocate(`Week beginning`)

  )
})
#Practice

output$epr_practice_table <- DT::renderDataTable({
  
  make_table(epr_practice_chartdata() %>%
               rename(`Practice name` = practice_name, `Week beginning` = week) %>% 
               select(-c(bnf_level, formulary_items, items)) %>% 
               relocate(`Week beginning`)
  )
  
})

#Downloads ----
output$download_epr_board <- downloadHandler(
  
  filename = function() {
    paste("Formulary_eprescribing_data", "csv", sep=".")
  },
  content = function(file) {
    write.csv(epr_board_chartdata(), file)
  }
)
output$download_epr_cluster <- downloadHandler(
  
  filename = function() {
    paste("Formulary_eprescribing_data", "csv", sep=".")
  },
  content = function(file) {
    write.csv(epr_cluster_chartdata(), file)
  }
)
output$download_epr_practice <- downloadHandler(
  
  filename = function() {
    paste("Formulary_eprescribing_data", "csv", sep=".")
  },
  content = function(file) {
    write.csv(epr_practice_chartdata(), file)
  }
)
####################################################################
## info button

observeEvent(input$epr_more_info, {
  showModal(modalDialog(
    title = "e-Prescribing",
    
    HTML(paste(
    "This data shows the percentage of medicines prescribed in compliance with the Formulary as percentage of all items
     in each NHS Board or the East Region.<br>",

     "The data comes from electronic messages submitted to PIS (Prescribing Information System).<br>",
     
     "e-Prescribing data covers prescriptions only and can include items prescribed but never dispensed. 
     Paid data only includes prescriptions that have been prescribed, dispensed, and then claimed for. Therefore there may be 
     slight differences in the figures in the Paid data tab and e-Prescribing data tab.<br>",
    
    "Practice code 99999 refers to prescriber locations that have GP Practice codes in PIS but no registered patients, including dummy GP practice codes 
    and admin practices.",
    
    sep = "<br/>"),
    collapse = "<br><br>"),
    easyClose = TRUE
  ))
})
####################################################################
### guided tour ----

# start introjs when button is pressed with custom options and events

#Board page

observeEvent(input$help_epr, {
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "auto", "top", "auto"),
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#trend_bnf_chapter_eprescribing",
                                   "#trend_Dates_eprescribing",
                                   "#trendchart_eprescribing",
                                   "#download_epr_board"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                           "Use this slider to define the start and end weeks for the data.",
                           
                           "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                        e.g. a specific month.",
                                 
                                 "You can download a csv file of the dataset according to 
                              your active selections using this button."
                       ))
  ))
})

#Function to show walkthrough button for Board page
observe({
  req(input$epresc_select)
  shinyjs::hide("help_epr") #actionButton id

  if(input$epresc_select == 'NHS Board') #radiogroupbutton input
    shinyjs::show("help_epr")
})

#Cluster page
observeEvent(input$help_epr_cluster, {
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "auto", "top", "auto"),
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#trend_bnf_chapter_epr_cluster",
                                   "#trend_Dates_epr_cluster",
                                   "#trendchart_epr_cluster",
                                   "#download_epr_cluster"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                                 "Use this slider to define the start and end weeks for the data.",
                                 
                                 "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                        e.g. a specific month.",
                                 
                                 "You can download a csv file of the dataset according to 
                              your active selections using this button."
                       ))
  ))
})
#Function to show walkthrough button 
observe({
  req(input$epresc_select)
  shinyjs::hide("help_epr_cluster") #actionButton id

  if(input$epresc_select == 'GP Cluster') #radiogroupbutton input
    shinyjs::show("help_epr_cluster")
})
#Practice page
observeEvent(input$help_epr_practice, {
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "auto", "top", "auto"),
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#trend_bnf_chapter_epr_practice",
                                   "#trend_Dates_epr_practice",
                                   "#trendchart_epr_practice",
                                   "#download_epr_practice"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                                 "Use this slider to define the start and end weeks for the data.",
                                 
                                 "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                        e.g. a specific month.",
                                 
                                 "You can download a csv file of the dataset according to 
                              your active selections using this button."
                       ))
  ))
})
#Function to show walkthrough button 
observe({
  req(input$epresc_select)
  shinyjs::hide("help_epr_practice") #actionButton id

  if(input$epresc_select == 'GP Practice') #radiogroupbutton input
    shinyjs::show("help_epr_practice")
})