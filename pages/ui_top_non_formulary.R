# UI
# Top Non Formulary Items ----



ui_top10 <- tabPanel(title = "Top 20 Non-Formulary Items",
                     value = "top20",
                     icon = icon_no_warning_fn("list-ol"),
         
        h1("East Region Formulary"),
        
        h2("Top 20 Non-Formulary Items"),
        
        tags$head(tags$title("Top 20 Non-Formulary Items")), # give screenreaders title of page
        

         p("This page shows top non-formulary items in the region and for each NHS Board 
           in each financial quarter starting from June 2023 (Q1, 2023/24)."),
  
      
                       ###More info button
                        actionButton("top_more_info", label = "More information",
                                    icon = icon("info"), class = "down"), 
        
                       actionButton("help_top", "Walkthrough"),
                       
       

  mainPanel(width = 12,  
            
            # Set up the main landmark for the page
            # Important for accessibility
            HTML("<main>"),
            
            fluidRow(
                column(3,                           
                         selectInput(
                         inputId = 'BNF_chapter_top',
                         label = 'Select BNF Chapter:',
                         choices =  bnf_chapter_choices, 
                         selected = "All BNF Chapters",
                         selectize = FALSE,
                         multiple = FALSE)
                ),
                column(3,  
                       selectInput(
                         inputId = 'top_quarter',
                         label = 'Select Financial Year Quarter:',
                         choices = unique(as.character(top_non_formulary_paid$`Financial Quarter`)),
                         selected = max(top_non_formulary_paid$`Financial Quarter`),
                         multiple= FALSE)
                ),
                column(3,  
                       selectInput(
                         inputId = "measure_top",
                         label = "Select Measure:",
                         choices =  unique(as.character(top_non_formulary_paid$rank_by)), 
                         selected = "Number of Items",
                         multiple = FALSE)
                ),
                column(3,
                       actionButton("reset_top", "Reset input") 
                )
                
            ),
            fluidRow(
                  column(3,      
                         uiOutput("bnf_section_top_select")
                  ),
            column(3,                    
                   uiOutput("bnf_sub_section_top_select")
            ),
              column(3,  
                     selectInput(
                       inputId = 'top_board',
                       label = 'Select NHS Board:',
                       choices =  unique(as.character(top_non_formulary_paid$NHSBoard)), 
                       selected = "Region",
                       multiple= FALSE)
              )
               ###  
             
            ),  

              fluidRow(align="center",
                             uiOutput("top_plot_title")
              ),
              ##chart
              fluidRow(align="center",
                      
                        withSpinner(plotlyOutput(outputId = "top_chart")),
                   ),
              linebreaks(5),
            
            fluidRow(
            tagList(tags$i("Note: In the graph, 'MG' refers to milligram and 'μg' to 'microgram'.")
                    )
            ),
            linebreaks(1),
              
              #table   
                fluidRow(
                        h4("Data Table"),
                 withSpinner(DT::dataTableOutput("top_table")) 

                ),
          linebreaks(2),
          
          fluidRow(
            p("The download gives you the top 100 products according to your selections.")
          ),
          
          fluidRow(
            downloadButton("download_top", "Download data")
          )        
  
  )#mainpanel
)#tabpanel
