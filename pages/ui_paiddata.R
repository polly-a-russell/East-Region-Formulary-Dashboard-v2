# this is the UI script for:
#Trend over time (paid data - board)
#Trend over time (paid data - cluster)
#Trend over time (paid data - practice)


# Section 4 - trend over time - Paid data ----
ui_paid <- tabPanel(title = "Paid data",
                    value = "paid", 
                    icon = icon_no_warning_fn("prescription-bottle"),
                  
        h1("East Region Formulary"),
        
        h2("Paid data"),
        tags$head(tags$title("Paid data")), # give screenreaders title of page
        
       
       p("This chart shows Formulary compliance (percentage of all items prescribed that are on the Formulary) and cost over time using Claim Paid data.
         Please note that there is a three-month lag when using Paid data."),

       useShinyjs(), #for updating actionbutton       
       
       actionButton("paid_more_info", label = "More information",
                    icon = icon("info"), class = "down"),
       
       #Walkthroughs - for Board
       actionButton("help_paid",
                    "Walkthrough"),
      #for cluster page - hidden otherwise
       actionButton("help_paid_cluster",
                    "Walkthrough"),
      #for practice - hidden otherwise
       actionButton("help_paid_practice",
                    "Walkthrough"),
      
 #### buttons on sidebar to choose between 'NHS Board'; 'Cluster; GP Practice. 

                radioGroupButtons("paid_select",                               # id for buttons
                                 choices = side_view_list, status = "primary",   #_list defined in setup
                                 direction = "horizontal", justified = T),
    
               linebreaks(1),
               
# Trend over time (paid data - board) ----

mainPanel(width = 12,         #mainPanel needs to come first before conditionalPanel.
          
          # Set up the main landmark for the page
          # Important for accessibility
          HTML("<main>"),
          
    # NHS Board ----
    conditionalPanel(
      condition= "input.paid_select == 'NHS Board'",
         
     fluidRow(
     
       ## everything that is included in conditionalPanel ie. NHS Board view:

       column(3, 
        
              selectInput(
               inputId = 'trend_BNF_chapter_paid_board',
               label = 'Select BNF Chapter:',
               choices =   bnf_chapter_choices,# list of 'choices' in setup.R.
               selected = "All BNF Chapters",
               selectize = FALSE,
               multiple = FALSE),
              
              uiOutput(outputId = 'bnf_section_paid_board_select'),
              uiOutput(outputId = 'bnfsubsection_paid_board_select') #select input defined in server  
            ), # end column
       
       column(3, 
              
              selectInput(
                inputId = "paid_board_date_min",
                label = "Select time period start point:",
                choices = list_dates_paid_board_asc,
                selected = min(board_formulary_paiddata$paid_calendar_month_and_year),
                multiple = FALSE,
                selectize = FALSE
              ), # end selectInput paid_board_date_min
              
              selectInput(
                inputId = "paid_board_date_max",
                label = "Select time period end point:",
                choices = list_dates_paid_board_desc,
                selected = max(board_formulary_paiddata$paid_calendar_month_and_year),
                multiple = FALSE,
                selectize = FALSE
              ) # end selectInput paid_board_date_max
      ),
       
       column(3,   
               pickerInput(
                 inputId = "trend_measure_paid_board",
                 label = "Select measure(s): ",
                 choices = c("Percentage of formulary items", "Cost per treated patient"),
                 selected = "Percentage of formulary items",
                 multiple = TRUE),
              
              pickerInput(
                inputId = "trend_paid_board",
                label = "Show NHS Board(s): ", 
                choices = unique(as.character(board_formulary_paiddata$NHSBoard)),
                selected = "Region",
                options = list(
                  `actions-box` = TRUE), ##buttons to the top of the dropdown menu (Select All & Deselect All)
                multiple = TRUE
              ) #end pickerInput
              
              
              
              
              ),
      
      column(3,
             p(HTML("&nbsp;")),
             actionButton("reset_paid_board", "Reset input") 
      )
      
     ), #endfluidrow board select Inputs


    fluidRow(align="center",
                uiOutput("paid_board_plot_title"),
             
             withSpinner(plotlyOutput(outputId = "chart_paid_board"))
    ),
    fluidRow(
             h4("Data Table"),
             DT::dataTableOutput("paid_board_table")
        ),
        fluidRow(
                downloadButton("download_paid_board", "Download data"),

        )
      ), # conditionalpanel condition= "input.paid_select == 'NHS Board'"


# Cluster ----
 
       conditionalPanel(
         condition= "input.paid_select == 'GP Cluster'",
 
         fluidRow(
           column(3, 
               
              selectInput(
                inputId = 'trend_BNF_chapter_paid_cluster',
                label = 'Select BNF Chapter:',
                choices =  bnf_chapter_choices, 
                selectize = FALSE,
                multiple = FALSE),
              uiOutput(outputId = 'bnf_section_paid_cluster_select'),
              uiOutput(outputId = 'bnfsubsection_paid_cluster_select') #select input defined in server
           
           ),
           column(3, 
                  #slider for dates.
                  
                  selectInput(
                    inputId = "paid_cluster_date_min",
                    label = "Select time period start point:",
                    choices = list_dates_paid_cluster_asc,
                    selected = min(cluster_formulary_paiddata$paid_calendar_month_and_year), # change
                    multiple = FALSE,
                    selectize = FALSE
                  ), # end selectInput paid_board_date_min
                  
                  selectInput(
                    inputId = "paid_cluster_date_max",
                    label = "Select time period end point:",
                    choices = list_dates_paid_cluster_desc,
                    selected = max(cluster_formulary_paiddata$paid_calendar_month_and_year), ## change
                    multiple = FALSE,
                    selectize = FALSE
                  ) # end selectInput paid_board_date_max
           ),
          column(3,   
                 pickerInput(
                   inputId = "trend_measure_paid_cluster",
                   label = "Select measure(s): ",
                   choices = c("Percentage of formulary items", "Cost per treated patient"),
                   selected = "Percentage of formulary items",
                   multiple = TRUE),
                 
                 pickerInput(
                   inputId = "trend_paid_cluster",
                   label = "Show cluster(s): ", 
                   choices = unique(as.character(cluster_formulary_paiddata$cluster)),
                   selected = unique(cluster_formulary_paiddata$cluster)[1],
                   options = list(
                     `actions-box` = TRUE), ##buttons to the top of the dropdown menu (Select All & Deselect All)
                   multiple = TRUE)
          ),
          column(3,
                 
                 p(HTML("&nbsp;")),
                 actionButton("reset_paid_cluster", "Reset input") 
          )
          
         ), #end fluidrow select inputs cluster
      
       
       
       
       
        fluidRow(align="center",
                 uiOutput("paid_cluster_plot_title"),
                 
                 withSpinner(plotlyOutput(outputId = "chart_paid_cluster"))
        ),
        fluidRow( 
          h4("Data Table"),
                DT::dataTableOutput("paid_cluster_table")
        ),
        fluidRow(
              downloadButton("download_paid_cluster", "Download data")
        )
       ), #end conditionalpanel condition= "input.paid_select == 'GP Cluster'",
 
# GP Practice ----
     conditionalPanel(
       condition= "input.paid_select == 'GP Practice'",
   
       fluidRow( 
         column(3, 
              
                selectInput(
                  inputId = 'trend_BNF_chapter_paid_practice',
                  label = 'Select BNF Chapter:',
                  choices =  bnf_chapter_choices, 
                  selectize = FALSE,
                  multiple = FALSE),
                
                uiOutput(outputId = 'bnf_section_paid_practice_select') ,
                uiOutput(outputId = 'bnfsubsection_paid_practice_select') #select input defined in server
      
         ),
         column(3, 
                #slider for dates
                
                selectInput(
                  inputId = "paid_practice_date_min",
                  label = "Select time period start point:",
                  choices = list_dates_paid_practice_asc,
                  selected = min(practice_formulary_paiddata$paid_calendar_month_and_year),
                  multiple = FALSE,
                  selectize = FALSE
                ), # end selectInput paid_board_date_min

                selectInput(
                  inputId = "paid_practice_date_max",
                  label = "Select time period end point:",
                  choices = list_dates_paid_practice_desc,
                  selected = max(practice_formulary_paiddata$paid_calendar_month_and_year),
                  multiple = FALSE,
                  selectize = FALSE
                ) # end selectInput paid_board_date_max
         ),
         #         
         column(3,   
                pickerInput(
                  inputId = "trend_measure_paid_practice",
                  label = "Select measure(s): ",
                  choices = c("Percentage of formulary items",  "Cost per treated patient"),
                  selected = "Percentage of formulary items",
                  multiple = TRUE),
                
                pickerInput(
                  inputId = "trend_paid_practice",
                  label = "Show practice(s): ", 
                  choices = unique(as.character(practice_formulary_paiddata$practice_name)),
                  selected = unique(practice_formulary_paiddata$practice_name)[1],
                  options = list(
                    `actions-box` = TRUE), ##buttons to the top of the dropdown menu (Select All & Deselect All)
                  multiple = TRUE
                )
         ),
         column(3,
                
                p(HTML("&nbsp;")),
                actionButton("reset_paid_practice", "Reset input") 
         )
         
       ), #end fluidrow select inputs cluster
       
       
          fluidRow(  
            
            column(3                  
                
            ),
       
          column(3

                 
            ),
         column(3
         )
        
       ),

       fluidRow(align="center",

                uiOutput("paid_practice_plot_title"),
         
                withSpinner(plotlyOutput(outputId = "chart_paid_practice"))
       ),
       fluidRow( 
                h4("Data Table"),
        
                DT::dataTableOutput("paid_practice_table"),   
       ),
       fluidRow(
           downloadButton("download_paid_practice", "Download data")
       )
     ) #conditionalPanel
)#mainpanel

)#tabPanel