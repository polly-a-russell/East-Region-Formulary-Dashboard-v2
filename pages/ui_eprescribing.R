# this is the UI script for:
#Trend over time (ePrescribing data)

ui_eprescribing <- tabPanel(title = "E-Prescribing data",
                            value = "eprescribing",
                            icon = icon_no_warning_fn("laptop-medical"),
            
             h1("East Region Formulary"),    
             
            h2("E-Prescribing data"),
            
            tags$head(tags$title("E-Prescribing data")), # give screenreaders title of page
            
            
    mainPanel(width = 12, 
              
              # Set up the main landmark for the page
              # Important for accessibility
              HTML("<main>"),
              
            p("This tab shows formulary compliance or NHS Boards by week using e-prescribed data.
             This data is generated when a prescription for a patient is printed and a corresponding electronic message is generated.
            There is a shorter lag in e-prescribing data compared to Paid data. 
            The time period shown for e-prescribing data currently is from ",
            
            format(min(board_formulary_eprescribingdata$week), "%d/%m/%Y"), 
                   " to " ,
            
            format(max(board_formulary_eprescribingdata$week), "%d/%m/%Y"), "." 
            ), #end paragraph
            
            useShinyjs(), #for updating actionbutton       
            
            actionButton("epr_more_info", label = "More information",
                            icon = icon("info"), class = "down"),
            
            #Walkthroughs - for Board
            actionButton("help_epr", "Walkthrough"),
            #for cluster page - hidden otherwise  
            actionButton("help_epr_cluster", "Walkthrough"),
            #for practice
            actionButton("help_epr_practice", "Walkthrough"),

            #### buttons on sidebar to choose between 'NHS Board'; 'Cluster; GP Practice.      
            radioGroupButtons("epresc_select",                               # id for buttons
                                 choices = side_view_list, status = "primary",   #_list defined in setup
                                 direction = "horizontal", justified = T),
               
            linebreaks(1),
            

          
              
              ##NHS BOARD ----
              
              conditionalPanel(
                condition= "input.epresc_select == 'NHS Board'",
              
              fluidRow(
                  
                column(3, 
                                                
                       selectInput(
                         inputId = 'trend_bnf_chapter_eprescribing',
                         label = 'Select BNF Chapter:',
                         choices =  bnf_chapter_choices, # list of 'choices' in setup.R
                         selectize = FALSE,
                         multiple = FALSE), 
                       
                       uiOutput(outputId = 'trend_bnf_section_eprescribing'),
                       uiOutput(outputId = 'trend_bnf_sub_section_eprescribing')
                ),
                column(3, 
                        
                       
                       
                       
                       selectInput(
                         inputId = "epresc_board_date_min",  ##change
                         label = "Select time period start point:",
                         choices = list_dates_epresc_board_asc, ## change
                         selected = min(board_formulary_eprescribingdata$week),  ## change
                         multiple = FALSE,
                         selectize = FALSE
                       ), # end selectInput epresc_board_date_min

                       selectInput(
                         inputId = "epresc_board_date_max",  ##change
                         label = "Select time period end point:",
                         choices = list_dates_epresc_board_desc,  ##change
                         selected = max(board_formulary_eprescribingdata$week),  ##change
                         multiple = FALSE,
                         selectize = FALSE
                       ) # end selectInput epresc_board_date_max
                ),
                column(3,
                       pickerInput(
                         inputId = "trend_eprescribing_board",
                         label = "Show NHS Board(s): ", 
                         choices = unique(as.character(board_formulary_eprescribingdata$NHSBoard)),
                         selected = "Region",
                         multiple = TRUE,
                         options = list(
                           `actions-box` = TRUE)) ##buttons to the top of the dropdown menu (Select All & Deselect All)
                       
                ),
                
                column(3,
                       p(HTML("&nbsp;")),
                       actionButton("reset_epr_board", "Reset input") 
                )
                 ),
              
              
             
              fluidRow(align="center",
               withSpinner(uiOutput(outputId = "eprescribing_plot_title")),
             ),
             
              fluidRow(align="center",
                          withSpinner(plotlyOutput(outputId = "trendchart_eprescribing"))
              ),
             linebreaks(2),

              fluidRow( 
                h4("Data Table"),
                DT::dataTableOutput("epr_board_table")
              ),
             
              fluidRow( 
                  
                downloadButton("download_epr_board", "Download data")
              )
            ),
            
        ##CLUSTER ----
            conditionalPanel(
                condition= "input.epresc_select == 'GP Cluster'",
              
              fluidRow(
                column(3,                           
                       selectInput(
                         inputId = 'trend_bnf_chapter_epr_cluster',
                         label = 'Select BNF Chapter:',
                         choices =  bnf_chapter_choices, # list of 'choices' in setup.R
                         selectize = FALSE,
                         multiple = FALSE),
                       
                       uiOutput(outputId = 'trend_bnf_section_epr_cluster'),
                       uiOutput(outputId = 'trend_bnf_sub_section_epr_cluster')
                ),
                column(3,
                       
                       selectInput(
                         inputId = "epresc_cluster_date_min",  ##change
                         label = "Select time period start point:",
                         choices = list_dates_epresc_cluster_asc, ## change
                         selected = min(cluster_formulary_eprescribingdata$week),  ## change
                         multiple = FALSE,
                         selectize = FALSE
                       ), # end selectInput epresc_board_date_min

                       selectInput(
                         inputId = "epresc_cluster_date_max",  ##change
                         label = "Select time period end point:",
                         choices = list_dates_epresc_cluster_desc,  ##change
                         selected = max(cluster_formulary_eprescribingdata$week),  ##change
                         multiple = FALSE,
                         selectize = FALSE
                       ) # end selectInput epresc_board_date_max
                ),
                column(3,
                       pickerInput(
                         inputId = "trend_eprescribing_cluster",
                         label = "Show Cluster(s): ", 
                         choices = unique(as.character(cluster_formulary_eprescribingdata$cluster)),
                         selected = unique(cluster_formulary_eprescribingdata$cluster)[1],
                         multiple = TRUE,
                         options = list(
                           `actions-box` = TRUE)) ##buttons to the top of the dropdown menu (Select All & Deselect All)
                ),
                
            column(3, 
                   p(HTML("&nbsp;")),
               actionButton("reset_epr_cluster", "Reset input") 
                )
             ),
            
                
              
             fluidRow(align="center",
               withSpinner(uiOutput(outputId = "epr_cluster_plot_title")),
             ),
             
              fluidRow(align="center",
                withSpinner(plotlyOutput(outputId = "trendchart_epr_cluster")),
              ),
             linebreaks(2),

              fluidRow( 
                h4("Data Table"),
                DT::dataTableOutput("epr_cluster_table")
              ),
              fluidRow( 
                downloadButton("download_epr_cluster", "Download data") 
              )
          ),
          
    #GP PRACTICE  -----
    
          conditionalPanel(
            condition= "input.epresc_select == 'GP Practice'",
            
            fluidRow(
              column(3,                           
                     selectInput(
                       inputId = 'trend_bnf_chapter_epr_practice',
                       label = 'Select BNF Chapter:',
                       choices =  bnf_chapter_choices, # list of 'choices' in setup.R
                       selectize = FALSE,
                       multiple = FALSE),
                     
                     uiOutput(outputId = 'trend_bnf_section_epr_practice'),
                     uiOutput(outputId = 'trend_bnf_sub_section_epr_practice')
              ),
              column(3, 
                     sliderInput(
                       "trend_Dates_epr_practice",
                       "Select time period (weeks):",
                       min = min(practice_formulary_eprescribingdata$week), #selects minimum date in trenddata.
                       max = max(practice_formulary_eprescribingdata$week), #selects maximum date in trenddata.
                       value=c(min(practice_formulary_eprescribingdata$week),
                               max(practice_formulary_eprescribingdata$week)),
                       ticks = FALSE,
                       timeFormat="%d %b %Y"),
                     
                     selectInput(
                       inputId = "epresc_gp_date_min",  ##change
                       label = "Select time period start point:",
                       choices = list_dates_epresc_gp_asc, ## change
                       selected = min(practice_formulary_eprescribingdata$week),  ## change
                       multiple = FALSE,
                       selectize = FALSE
                     ), # end selectInput epresc_board_date_min

                     selectInput(
                       inputId = "epresc_gp_date_max",  ##change
                       label = "Select time period end point:",
                       choices = list_dates_epresc_gp_desc,  ##change
                       selected = max(practice_formulary_eprescribingdata$week),  ##change
                       multiple = FALSE,
                       selectize = FALSE
                     ) # end selectInput epresc_board_date_max
                     
              ),
              column(3,
                     pickerInput(
                       inputId = "trend_eprescribing_practice",
                       label = "Show GP Practice(s): ", 
                       choices = unique(as.character(practice_formulary_eprescribingdata$practice_name)),
                       selected = unique(practice_formulary_eprescribingdata$practice_name)[1],
                       multiple = TRUE,
                       options = list(
                         `actions-box` = TRUE)) ##buttons to the top of the dropdown menu (Select All & Deselect All)
               ),
              column(3,
                     p(HTML("&nbsp;")),
                     actionButton("reset_epr_practice", "Reset input") 
              )
              ),
             
              
            
            fluidRow(align="center",
                     withSpinner(uiOutput(outputId = "epr_practice_plot_title")),
            ),
            
            fluidRow(align="center",
                     withSpinner(plotlyOutput(outputId = "trendchart_epr_practice")),
            ),
            linebreaks(2),
            
            fluidRow( 
              h4("Data Table"),
              DT::dataTableOutput("epr_practice_table")
            ),
            fluidRow( 
              downloadButton("download_epr_practice", "Download data") 
            )
          )

         
  ) # end main panel  
) #end tab panel
