
####################### Core functions #######################

# Add n linebreaks ### should be called linebreaks
linebreaks <- function(n){HTML(strrep(br(), n))}

# Remove warnings from icons 
icon_no_warning_fn = function(icon_name) {
  icon(icon_name, verify_fa=FALSE)
}

# Generic data table
make_table <- function(input_data_table,
                       rows_to_display = 10){
  
  # Take out underscores/. in column names for display purposes and make sentence case
  #the order of these matters
  table_colnames  <-  gsub("_", " ", colnames(input_data_table))
  table_colnames  <-  gsub("NHSBoard", "NHS Board", table_colnames)
  table_colnames  <-  gsub("formulary", "Formulary", table_colnames)
  table_colnames <- paste(toupper(substr(table_colnames, 1, 1)), substr(table_colnames, 2, nchar(table_colnames)), sep="")
                                          
  dt <- DT::datatable(input_data_table, style = 'bootstrap',
                      class = 'table-condensed',
                      rownames = FALSE,
                      filter = "top",
                      colnames = table_colnames,
                      extensions = 'FixedHeader',
                      options = list(pageLength = rows_to_display,
                                     scrollX = FALSE,
                                     scrollY = FALSE,
                                     dom = 'tp',
                                     autoWidth = TRUE,
                                     fixedHeader = FALSE,
                                     # style header
                                     initComplete = htmlwidgets::JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#C5C3DA', 'color': '#3F3685'});",
                                       "$(this.api().table().row().index()).css({'background-color': '#C5C3DA', 'color': '#3F3685'});",
                                       "}")
                                     ))
  
  return(dt)
}




## functions for plot_ly 
# Buttons to remove from plotly plots
bttn_remove <-  list('select2d', 'lasso2d', 'zoomIn2d', 'zoomOut2d',
                     'autoScale2d',   'toggleSpikelines',  'hoverCompareCartesian',
                     'hoverClosestCartesian')

format_plotly <- function(plot){
plot <- plot %>%
 layout(
    yaxis = list(
      
    #show 0
    rangemode = "tozero"
      
    # tickformat = ",",
    # tickprefix = "",
    # showgrid = FALSE,
    # zeroline = FALSE,
    # showline = TRUE,
  ),
   # xaxis = list(
   #    tick0 =
   # ),
  font = list(
  family = "Arial",
  size = 14
    )
) %>% 
 config(displaylogo = F,  modeBarButtonsToRemove = bttn_remove) 


return(plot)
}

#Wrap long VMP name labels on top plot bars

# Call this function with a list or vector
# wrap.labels <- function(x, len)
# {
#   sapply(x, function(y) paste(strwrap(y, len), 
#                               collapse = "\n"), 
#          USE.NAMES = FALSE)
# 
# }


##############################################################
