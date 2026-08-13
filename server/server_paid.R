# server for Paid data

# Section 1 - dynamic select inputs -----
#bnf section select input for paid data - board

output$bnf_section_paid_board_select <- renderUI({
  
  bnf_section_selector(board_formulary_paiddata, 
                       input$trend_BNF_chapter_paid_board, 
                       "trend_BNF_section_paid_board")
})

#bnf section select input for paid data - cluster

output$bnf_section_paid_cluster_select <- renderUI({

    bnf_section_selector(cluster_formulary_paiddata, 
                         input$trend_BNF_chapter_paid_cluster, 
                         "trend_BNF_section_paid_cluster")
})  

output$bnf_section_paid_practice_select <- renderUI({
  
  bnf_section_selector(practice_formulary_paiddata, 
                       input$trend_BNF_chapter_paid_practice, 
                       "trend_BNF_section_paid_practice")
})

##BNF Subsection

#bnf sub section select input for paid data - board

output$bnfsubsection_paid_board_select <- renderUI({

  bnf_sub_section_selector(board_formulary_paiddata, 
                           input$trend_BNF_chapter_paid_board, 
                           input$trend_BNF_section_paid_board, 
                           'trend_BNF_sub_section_paid_board')
})
  
#bnf sub section select input for paid data - cluster.
 
output$bnfsubsection_paid_cluster_select <- renderUI({
   
  bnf_sub_section_selector(cluster_formulary_paiddata, 
                            input$trend_BNF_chapter_paid_cluster, 
                            input$trend_BNF_section_paid_cluster, 
                            'trend_BNF_sub_section_paid_cluster')
})
  
#bnf sub section select input for paid data - practice.
output$bnfsubsection_paid_practice_select <- renderUI({

  bnf_sub_section_selector(practice_formulary_paiddata, 
                           input$trend_BNF_chapter_paid_practice, 
                           input$trend_BNF_section_paid_practice, 
                           'trend_BNF_sub_section_paid_practice')

})

############################################################################
# Reset buttons ----

observeEvent(
  input$reset_paid_board, {
    
    updateSelectInput(session, 'trend_BNF_chapter_paid_board', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_paid_board", 
                                value = c(min(board_formulary_paiddata$paid_calendar_month_and_year),
                                 max(board_formulary_paiddata$paid_calendar_month_and_year)),
                                  timeFormat="%b %Y")
    updatePickerInput(session, "trend_measure_paid_board", selected = "Percentage of formulary items")
    updatePickerInput(session, "trend_paid_board", selected = "Region")
    
  }
)

observeEvent(
  
  input$reset_paid_cluster, {
    updateSelectInput(session, 'trend_BNF_chapter_paid_cluster', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_paid_cluster", 
                              value = c(min(cluster_formulary_paiddata$paid_calendar_month_and_year),
                                                                   max(cluster_formulary_paiddata$paid_calendar_month_and_year)),
                                                                    timeFormat="%b %Y")
    updatePickerInput(session, "trend_measure_paid_cluster", selected = "Percentage of formulary items")
    updatePickerInput(session, "trend_paid_cluster", selected = unique(cluster_formulary_paiddata$cluster)[1])
  }
)

observeEvent(
  
  input$reset_paid_practice, {
    updateSelectInput(session, 'trend_BNF_chapter_paid_practice', selected = "All BNF Chapters")
    updateSliderInput(session, "trend_Dates_paid_practice", 
                      value = c(min(practice_formulary_paiddata$paid_calendar_month_and_year),
                                                                   max(practice_formulary_paiddata$paid_calendar_month_and_year)),
                                                                    timeFormat="%b %Y")
    updatePickerInput(session, "trend_measure_paid_practice", selected = "Percentage of formulary items")
    updatePickerInput(session, "trend_paid_practice", selected = unique(practice_formulary_paiddata$practice_name)[1])
  }
)

############################################################################
  # Dataframe - Board ----
paid_board_chartdata <- reactive({
  
  #use function from server_functions
  make_chartdata(board_formulary_paiddata, input$trend_paid_board, 
                 input$trend_BNF_chapter_paid_board, input$trend_BNF_section_paid_board, 
                 input$trend_BNF_sub_section_paid_board, input$trend_Dates_paid_board, 
                 "NHSBoard", "paid_calendar_month_and_year")
})



# Plot board ----
output$chart_paid_board  <- renderPlotly({
    # Ensure the input is available
  req(input$trend_measure_paid_board)
  
  data <- paid_board_chartdata() 
  req(nrow(data) > 0)  # Ensure data has rows
  
  #plot when both measures chosen 
  if("Cost per treated patient" %in% input$trend_measure_paid_board &
     "Percentage of formulary items" %in% input$trend_measure_paid_board){
    
    p1 <- plot_ly( 
  
              data = data,
              type = 'scatter', 
              mode = 'lines+markers',
              x = data$paid_calendar_month_and_year,
              y = data$percent_formulary_items,
              color =~ data$NHSBoard,
              colors = ~plot_colours(data$NHSBoard),
              hovertext =  ~paste0(data$NHSBoard,
                             '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                             '<br>Percentage: ', data$percent_formulary_items, '%'),
              hoverinfo = 'text',
              showlegend = T
            ) %>% 
        layout(
          yaxis = list(title = 'Percentage of formulary items'),
          xaxis = list(type = 'date', tickformat = "%b %Y"),
          legend = list(title = list(text = 'NHS Board'))
          )   %>% 
      format_plotly()
     
    p2 <- plot_ly( 
          
            data = data,
                     type = 'scatter', 
                     mode = 'lines+markers',
                     x = data$paid_calendar_month_and_year,
                     y = data$`Cost per treated patient (£)`,
                     color =~ data$NHSBoard,
                     colors =~plot_colours(data$NHSBoard),
                     hovertext =  ~paste0(data$NHSBoard,
                                    '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                                    '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`),

                     hoverinfo = 'text',
                    showlegend = F
                    ) %>% 
      layout(
        yaxis = list(title = 'Cost per Treated Patient (£)'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'NHS Board'))
        
        )   %>% 
      format_plotly()
     
subplot(p1,p2, nrows = 1, titleY = TRUE,  titleX=TRUE, shareX=FALSE, shareY=FALSE, margin = 0.05) %>% 
               layout(
                 legend = list(title = list(text = 'NHS Board'),
                          showlegend =~ unique(data$NHSBoard))
               )


    } else if("Cost per treated patient" %in% input$trend_measure_paid_board) {
      
   plot_ly(data = data,
              type = 'scatter', 
              mode = 'lines+markers',
              x = data$paid_calendar_month_and_year,
              y = data$`Cost per treated patient (£)`,
              color =~ data$NHSBoard,
              colors =~plot_colours(data$NHSBoard),
              text =  ~paste0(data$NHSBoard,
                             '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                             '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`),

              hoverinfo = 'text' ) %>% 
        layout(
          yaxis = list(title = 'Cost per Treated Patient (£)'),
          xaxis = list(type = 'date', tickformat = "%b %Y"),
          legend = list(title = list(text = 'NHS Board'))
        ) %>% 
        format_plotly()
  }
   else {    #by default, plot %
          
    plot_ly(data = data,
                  type = 'scatter', 
                  mode = 'lines+markers',
                  x = data$paid_calendar_month_and_year,
                  y = data$percent_formulary_items,
                  color =~ data$NHSBoard,
                  colors =~plot_colours(data$NHSBoard),
                  text =  ~paste0(data$NHSBoard,
                                 '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                                 '<br>Percentage: ', data$percent_formulary_items, '%'),
                  hoverinfo = 'text' ) %>% 
            layout(
              yaxis = list(title = 'Percentage of formulary items'),
              xaxis = list(type = 'date', tickformat = "%b %Y"),
              legend = list(title = list(text = 'NHS Board'))
             ) %>% 
       format_plotly()

        }
})


# Plot title ----
output$paid_board_plot_title <- renderText({
  
  if("Cost per treated patient" %in% input$trend_measure_paid_board &
     "Percentage of formulary items" %in% input$trend_measure_paid_board){
  
    HTML(paste0("<h4> ", "Percentage of Formulary Items and Cost per Treated Patient (£), ",  
                              bnf_text(input$trend_BNF_chapter_paid_board,
                               input$trend_BNF_section_paid_board,
                                input$trend_BNF_sub_section_paid_board)," </h4>"))
    
 } else if("Percentage of formulary items" %in% input$trend_measure_paid_board){
   
  HTML(paste0("<h4> ", "Percentage of Formulary Items, ",  
                   bnf_text(input$trend_BNF_chapter_paid_board,
                            input$trend_BNF_section_paid_board,
                            input$trend_BNF_sub_section_paid_board)," </h4>"))

}else {
  
  HTML(paste0("<h4> ", "Cost per Treated Patient, ",  
                      bnf_text(input$trend_BNF_chapter_paid_board,
                             input$trend_BNF_section_paid_board,
                             input$trend_BNF_sub_section_paid_board)," </h4>"))
}
})

#Datatable Board ----

output$paid_board_table <- DT::renderDataTable({

  make_table(
    (# Check which measure is selected and plot accordingly
    if ("Cost per treated patient" %!in% input$trend_measure_paid_board) { 
      paid_board_chartdata() %>% select(-`Cost per treated patient (£)`)
    } 
    else if ("Percentage of formulary items" %!in% input$trend_measure_paid_board) {
      paid_board_chartdata() %>% select(-percent_formulary_items)
    } else {
      paid_board_chartdata()
    }) %>% 
    mutate(`Calendar month and year` = format(paid_calendar_month_and_year,"%b %Y")) %>% 
      select(-c(paid_calendar_month_and_year, bnf_level, geography_level, formulary_items, items,
                cluster, practice_name, gic, no_of_patients)) %>% 
      #always put date as first col
      relocate(`Calendar month and year`)
      )
   
})


############################################################################
# Dataframe - Cluster ----  

paid_cluster_chartdata <- reactive({
    make_chartdata(cluster_formulary_paiddata, input$trend_paid_cluster, 
                   input$trend_BNF_chapter_paid_cluster, input$trend_BNF_section_paid_cluster,
                   input$trend_BNF_sub_section_paid_cluster, input$trend_Dates_paid_cluster,
                   "cluster", "paid_calendar_month_and_year")

})

# Plot cluster ----
output$chart_paid_cluster  <- renderPlotly({
  # Ensure the input is available
  req(input$trend_measure_paid_cluster)
  
  data <- paid_cluster_chartdata() 
  req(nrow(data) > 0)  # Ensure data has rows
  
  if("Cost per treated patient" %in% input$trend_measure_paid_cluster &
     "Percentage of formulary items" %in% input$trend_measure_paid_cluster){
    
    p1 <- plot_ly( 
      
      data = data,
      type = 'scatter', 
      mode = 'lines+markers',
      x = data$paid_calendar_month_and_year,
      y = data$percent_formulary_items,
      color =~ data$cluster,
      colors = ~plot_colours(data$cluster),
      hovertext =  ~paste0(data$cluster,
                           '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                           '<br>Percentage: ', data$percent_formulary_items, '%'),
      hoverinfo = 'text',
      showlegend = T
    ) %>% 
      layout(
        yaxis = list(title = 'Percentage of formulary items'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'GP Cluster'))
      )  %>% 
      format_plotly()
    
  
  p2 <- plot_ly(data = data,
               type = 'scatter', 
               mode = 'lines+markers',
               x = data$paid_calendar_month_and_year,
               y = data$`Cost per treated patient (£)`,
               color =~ data$cluster,
               colors =~ plot_colours(unique(data$cluster)),
               text =  ~paste0(data$cluster,
                              '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                              '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`),  
               hoverinfo = 'text' ,
               showlegend = F) %>% 
    layout(
      yaxis = list(title = 'Cost per treated patient (£)'),
      xaxis = list(type = 'date', tickformat = "%b %Y"),
      legend = list(title = list(text = 'GP Cluster'))
    ) %>% 
    format_plotly()

  subplot(p1,p2, nrows = 1, titleY = TRUE,  titleX=TRUE, shareX=TRUE, shareY=FALSE, margin = 0.05) %>% 
   layout(legend = list(title = list(text = 'GP Cluster'),
             showlegend =~ unique(data$cluster))
    ) 
  
  } else if("Cost per treated patient" %in% input$trend_measure_paid_cluster) {
    
    plot_ly(data = data,
            type = 'scatter', 
            mode = 'lines+markers',
            x = data$paid_calendar_month_and_year,
            y = data$`Cost per treated patient (£)`,
            color =~ data$cluster,
            colors =~plot_colours(data$cluster),
            text =  ~paste0(data$cluster,
                           '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                           '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`),   
            hoverinfo = 'text' ,
          showlegend = T) %>% 

      layout(
        yaxis = list(title = 'Cost per Treated Patient (£)'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'Cluster'))
      ) %>% 
      format_plotly()
  }
  else{    #by default, plot %
    
    plot_ly(data = data,
            type = 'scatter', 
            mode = 'lines+markers',
            x = data$paid_calendar_month_and_year,
            y = data$percent_formulary_items,
            color =~ data$cluster,
            colors =~plot_colours(data$cluster),
            text =  ~paste0(data$cluster,
                            '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                            '<br>Percentage: ', data$percent_formulary_items, '%'),
            hoverinfo = 'text' ) %>% 
      layout(
        yaxis = list(title = 'Percentage of formulary items'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'Cluster'))
      ) %>% 
      format_plotly()
    
  }
})


# Plot title ----
output$paid_cluster_plot_title <- renderText({
  
  if("Cost per treated patient" %in% input$trend_measure_paid_cluster &
     "Percentage of formulary items" %in% input$trend_measure_paid_cluster){
    
    HTML(paste0("<h4> ", "Percentage of Formulary Items and Cost per Treated Patient (£), ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_cluster,
                                                         input$trend_BNF_section_paid_cluster,
                                                         input$trend_BNF_sub_section_paid_cluster)))," </h4>"))
    
  } else if("Percentage of formulary items" %in% input$trend_measure_paid_cluster){
    
    HTML(paste0("<h4> ", "Percentage of Formulary Items, ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_cluster,
                                                         input$trend_BNF_section_paid_cluster,
                                                         input$trend_BNF_sub_section_paid_cluster)))," </h4>"))
    
  }else {
    
    HTML(paste0("<h4> ", "Cost per Treated Patient, ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_cluster,
                                                         input$trend_BNF_section_paid_cluster,
                                                         input$trend_BNF_sub_section_paid_cluster)))," </h4>"))
  }
})

#Datatable cluster ----

output$paid_cluster_table <- DT::renderDataTable({

  make_table(
      (# Check which measure is selected and plot accordingly
        if ("Cost per treated patient" %!in% input$trend_measure_paid_cluster) { 
          paid_cluster_chartdata() %>% select(-`Cost per treated patient (£)`)
        } 
        else if ("Percentage of formulary items" %!in% input$trend_measure_paid_cluster) {
          paid_cluster_chartdata() %>% select(-percent_formulary_items)
        } else {
          paid_cluster_chartdata()
        }) %>% 
        rename(Cluster = cluster) %>% 
        mutate(`Calendar month and year` = format(paid_calendar_month_and_year,"%b %Y")) %>%
          select(-c(paid_calendar_month_and_year, bnf_level, formulary_items, items,
                     gic, no_of_patients)) %>%          
          relocate(`Calendar month and year`)

  )
})


########################################################################
# Dataframe - Practice ----

paid_practice_chartdata <- reactive({
    make_chartdata(practice_formulary_paiddata, input$trend_paid_practice, 
                   input$trend_BNF_chapter_paid_practice, input$trend_BNF_section_paid_practice, 
                   input$trend_BNF_sub_section_paid_practice, input$trend_Dates_paid_practice, 
                   "practice_name", "paid_calendar_month_and_year")
 
})

# Plot practice ----
output$chart_paid_practice  <- renderPlotly({
  # Ensure the input is available
  req(input$trend_measure_paid_practice)
  
  data <- paid_practice_chartdata() 
  req(nrow(data) > 0)  # Ensure data has rows
  
  if("Cost per treated patient" %in% input$trend_measure_paid_practice &
     "Percentage of formulary items" %in% input$trend_measure_paid_practice){
    
    p1 <- plot_ly( 
      
      data = data,
      type = 'scatter', 
      mode = 'lines+markers',
      x = data$paid_calendar_month_and_year,
      y = data$percent_formulary_items,
      color =~ data$practice_name,
      colors = ~plot_colours(data$practice_name),
      hovertext =  ~paste0(data$practice_name,
                           '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                           '<br>Percentage: ', data$percent_formulary_items, '%'),
      hoverinfo = 'text',
      showlegend = T
    ) %>% 
      layout(
        yaxis = list(title = 'Percentage of formulary items'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'Practice'))
      )   %>% 
      format_plotly()

 p2 <-  plot_ly(data = data,
               type = 'scatter', 
               mode = 'lines+markers',
               x = data$paid_calendar_month_and_year,
               y = data$`Cost per treated patient (£)`,
               color =~ data$practice_name,
               colors =~ plot_colours(unique(data$practice_name)),
               text =  ~paste0(data$practice_name,
                              '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                              '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`), 
               hoverinfo = 'text' ,
               showlegend = F) %>% 
   layout(
     yaxis = list(title = 'Cost per Treated Patient (£)'),
     xaxis = list(type = 'date', tickformat = "%b %Y"),
     legend = list(title = list(text = 'Practice'))
   )  %>% 
   format_plotly()
  
 
subplot(p1,p2, nrows = 1, titleY = TRUE,  titleX=TRUE, shareX=TRUE, shareY=FALSE, margin = 0.05)%>% 
  layout(legend = list(title = list(text = 'Practice'),
           showlegend =~ unique(data$practice_name))
  )


  } else if("Cost per treated patient" %in% input$trend_measure_paid_practice) {

  plot_ly( 
      
      data = data,
      type = 'scatter', 
      mode = 'lines+markers',
      x = data$paid_calendar_month_and_year,
      y = data$`Cost per treated patient (£)`,
      color =~ data$practice_name,
      colors =~plot_colours(data$practice_name),
      hovertext =  ~paste0(data$practice_name,
                           '<br>', format(data$paid_calendar_month_and_year,"%b %Y") ,
                           '<br>Cost Per Treated Patient: £', data$`Cost per treated patient (£)`), 
            hoverinfo = 'text' ,
         showlegend = T ) %>% 

      layout(
        yaxis = list(title = 'Cost per Treated Patient (£)'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'Practice name'))
      )  %>% 
      format_plotly()

  }
  else{    #by default, plot %
    
    plot_ly(data = data,
            type = 'scatter', 
            mode = 'lines+markers',
            x = data$paid_calendar_month_and_year,
            y = data$percent_formulary_items,
            color =~ data$practice_name,
            colors =~plot_colours(data$practice_name),
            text =  ~paste0(data$practice_name,
                            '<br>', format(data$paid_calendar_month_and_year,"%b %Y"),
                            '<br>Percentage: ', data$percent_formulary_items, '%'),
            hoverinfo = 'text' ) %>% 
      layout(
        yaxis = list(title = 'Percentage of formulary items'),
        xaxis = list(type = 'date', tickformat = "%b %Y"),
        legend = list(title = list(text = 'Practice name'))
      ) %>% 
      format_plotly()
    
  }
})

# Plot title ----
output$paid_practice_plot_title <- renderText({
  
  if("Cost per treated patient" %in% input$trend_measure_paid_practice &
     "Percentage of formulary items" %in% input$trend_measure_paid_practice){
    
    HTML(paste0("<h4> ", "Percentage of Formulary Items and Cost per Treated Patient (£), ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_practice,
                                                         input$trend_BNF_section_paid_practice,
                                                         input$trend_BNF_sub_section_paid_practice)))," </h4>"))
    
  } else if("Percentage of formulary items" %in% input$trend_measure_paid_practice){
    
    HTML(paste0("<h4> ", "Percentage of Formulary Items, ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_practice,
                                                         input$trend_BNF_section_paid_practice,
                                                         input$trend_BNF_sub_section_paid_practice)))," </h4>"))
    
  }else {
    
    HTML(paste0("<h4> ", "Cost per Treated Patient, ",  
                gsub("Bnf", "BNF", str_to_title(bnf_text(input$trend_BNF_chapter_paid_practice,
                                                         input$trend_BNF_section_paid_practice,
                                                         input$trend_BNF_sub_section_paid_practice)))," </h4>"))
  }
})

#Datatable practice ----

output$paid_practice_table <- DT::renderDataTable({

  make_table(
    (# Check which measure is selected and plot accordingly
    if ("Cost per treated patient" %!in% input$trend_measure_paid_practice) { 
      paid_practice_chartdata() %>% select(-`Cost per treated patient (£)`)
    } 
    else if ("Percentage of formulary items" %!in% input$trend_measure_paid_practice) {
      paid_practice_chartdata() %>% select(-percent_formulary_items)
    } else {
      paid_practice_chartdata()
    }) %>%  
    rename(`Practice name` = practice_name) %>% 
    mutate(`Calendar month and year` = format(paid_calendar_month_and_year,"%b %Y")) %>% 
      select(-c(paid_calendar_month_and_year, bnf_level, geography_level, formulary_items, items,
                cluster, gic, no_of_patients)) %>%           
      relocate(`Calendar month and year`)
   )

})


####################################################################
# Data download under each chart ----  

output$download_paid_board <- downloadHandler(
  
  filename = function() {
    paste("Formulary_data_NHSBoard", "csv", sep=".")
  },
  content = function(file) {
    write.csv(paid_board_chartdata(), file)
  }
)
output$download_paid_cluster <- downloadHandler(
  
  filename = function() {
    paste("Formulary_data_Cluster", "csv", sep=".")
  },
  content = function(file) {
    write.csv(paid_cluster_chartdata(), file)
  }
)
output$download_paid_practice <- downloadHandler(
  
  filename = function() {
    paste("Formulary_data_Practice", "csv", sep=".")
  },
  content = function(file) {
    write.csv(paid_practice_chartdata(), file)
  }
)
####################################################################
## info button

observeEvent(input$paid_more_info, {
  showModal(modalDialog(
    title = "Paid data",
    
    HTML( 
      paste(
      
    "This data shows the percentage of medicines prescribed in compliance with the Formulary as percentage of all items
     and the cost of all medicines per patient in each NHS Board or the East Region.<br>",
     
     "The cost measure is calculated as the sum of GIC (Gross Ingredient Cost, excl. Broken Bulk) divided by the number of patients prescribed the medicines in question.<br>",
     
    "The data comes from PIS (Prescribing Information System). 
    The data is filtered on GP practice prescriber location types.<br>",
    
    "Practice code 99999 refers to prescriber locations that have GP Practice codes in PIS but no registered patients, including dummy GP practice codes 
    and admin practices.",
     
     
      sep = "<br/>"),
     collapse = "<br><br>"),
    easyClose = TRUE
  ))
})
####################################################################
### guided tour
#Board

# start introjs when button is pressed with custom options and events

observeEvent(input$help_paid, {
  rintrojs::introjs(session, options = list(
                   "nextLabel"="Next",
                   "prevLabel"="Previous", 
                   "skipLabel"="Close",

    steps = data.frame(position = c("auto", "auto", "top","auto"),
                       
         # Elements (e.g. selectinput) to be highlighted by instructions.
         element = c("#trend_BNF_chapter_paid_board",
                      "#trend_Dates_paid_board",
                      "#trendchart_paid_board",
                      "#download_paid_board"),
                       
        # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
          intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                    
                    "Use this slider to define the start and end dates for the data.",
                    
                    "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                    e.g. a specific month.",
                    
                    "You can download a csv file of the dataset according to 
                              your active selections using this button."
                    ))
  ))
})

#Function to show walkthrough button for Board page
observe({
  req(input$paid_select)
  shinyjs::hide("help_paid") #actionButton id

  if(input$paid_select == 'NHS Board') #radiogroupbutton input
    shinyjs::show("help_paid")
})

#Cluster

# start introjs when button is pressed with custom options and events

observeEvent(input$help_paid_cluster, {
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "auto", "top","auto"),
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#trend_BNF_chapter_paid_cluster",
                                   "#trend_Dates_paid_cluster",
                                   "#trendchart_paid_cluster",
                                   "#download_paid_cluster"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                                 "Use this slider to define the start and end dates for the data.",
                                 
                                 "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                    e.g. a specific month.",
                                 
                                 "You can download a csv file of the dataset according to 
                              your active selections using this button."
                       ))
  ))
})

#Show cluster page walkthrough
 observe({
req(input$paid_select)
  shinyjs::hide("help_paid_cluster")

  if(input$paid_select == 'GP Cluster') #radiogroupbutton input
    shinyjs::show("help_paid_cluster")
})


#Practice

# start introjs when button is pressed with custom options and events

observeEvent(input$help_paid_practice, {
  rintrojs::introjs(session, options = list(
    "nextLabel"="Next",
    "prevLabel"="Previous", 
    "skipLabel"="Close",
    
    steps = data.frame(position = c("auto", "auto", "top","auto"),
                       
                       # Elements (e.g. selectinput) to be highlighted by instructions.
                       element = c("#trend_BNF_chapter_paid_practice",
                                   "#trend_Dates_paid_practice",
                                   "#trendchart_paid_practice",
                                   "#download_paid_practice"),
                       
                       # Vector for instruction text.  String 1 corresponds to element 1 in above vector.
                       intro = c("The data is organised by condition using the British National Formulary
                    (BNF) categories. First select a BNF Chapter, and narrow down further into BNF Section and Sub Section.",
                                 
                                 "Use this slider to define the start and end dates for the data.",
                                 
                                 "Hover over the dots on lines to see exact figures. You can move the x and y axes to zoom into
                    e.g. a specific month.",
                                 
                                 "You can download a csv file of the dataset according to 
                              your active selections using this button."
                       ))
  ))
})
# 
observe({
  req(input$paid_select)
  shinyjs::hide("help_paid_practice")

  if(input$paid_select == 'GP Practice') #radiogroupbutton input
    shinyjs::show("help_paid_practice")
})