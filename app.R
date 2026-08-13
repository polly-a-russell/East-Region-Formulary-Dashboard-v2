##########################################################
# Formulary shiny app
# Original author(s): Johanna Jokio & Aidan Tait
# Original date: 2025-11
# Written/run on R 4.4.2
# needs 1CPU approx 4MB memory
 
##########################################################

# Get packages
source(file.path("setup.R"), local = TRUE)$value 
# Get functions
source(file.path("core_functions.R"), local = TRUE)$value 
source(file.path("server/server_functions.R"), local = TRUE)$value 


#source UI scripts for app

############# CALL UI SCRIPTS ############################

source(file.path("pages/ui_intropage.R"), local = TRUE)$value
source(file.path("pages/ui_paiddata.R"), local = TRUE)$value
source(file.path("pages/ui_eprescribing.R"), local = TRUE)$value
source(file.path("pages/ui_top_non_formulary.R"), local = TRUE)$value
#######################################################








ui = fluidPage(
  
  introjsUI(), #needed for walkthrough in each tab.
  tagList(
    # Specify most recent fontawesome library - change version as needed
    tags$style("@import url(https://use.fontawesome.com/releases/v6.6.0/css/all.css);"),
  
    #shinyjs::useShinyjs(),
  
    navbarPage(
      id = "intabset", # id used for jumping between tabs
         
      title = div(
              tags$a(
                img(src = "white-logo.png", id="logo", height = 40),
                     href = "https://www.publichealthscotland.scot/",
                     target = "_blank",
                     alt =  "Go to Public Health Scotland (external site)"), # PHS logo links to PHS website
              style = "position: relative; top: 2em; right: 1.1em; padding-bottom: 0.1em;",
      ),
      windowTitle = "East Region Formulary",# Title for browser tab
      header = 
              tags$head(includeCSS("www/styles.css"),  # CSS stylesheet
                          tags$link(rel = "shortcut icon", href = "www/favicon_phs.ico") # Icon for browser tab
              ),
    

      ##############################################.
      # INTRO PAGE ----
      ##############################################.
        ui_intropage, # name of UI item
      
      ##############################################.
      # TAB 1 ----
      ##############################################.
     
        ui_paid, 
      
      ##############################################.
      # TAB 2 ----
      ##############################################.
       
        ui_eprescribing, 
      
      ##############################################.
      # TAB 3 ----
      ##############################################.
        ui_top10
      
    ) # navbarPage
    
  ) # taglist
  
)
###########INCLUDE NEXT LINE FOR PASSWORD AUTHORISATION####################   

ui <- secure_app(ui, choose_language = TRUE)
################################################################################

# server.r

# SERVER --------

# Define server logic --------
server <- function(input, output, session) { 
  
  
  # CALL SERVER SCRIPTS 
  source(file.path("server/server_intro.R"), local = TRUE)$value
  source(file.path("server/server_paid.R"), local = TRUE)$value
  source(file.path("server/server_eprescribing.R"), local = TRUE)$value
  source(file.path("server/server_top.R"), local = TRUE)$value

  # Keeps the shiny app from timing out quickly 
  autoInvalidate <- reactiveTimer(10000)
  observe({
    autoInvalidate()
    cat(".")
  })
  
  # Import authentication credentials
  credentials <- readRDS("admin/credentials.RDS")
  
  # Apply shinymanager authentication
  res_auth <- secure_server(check_credentials = check_credentials(credentials))
}


# Sets language right at the top of source (required this way for screen readers)
attr(ui, "lang") = "en"

# Run the application # it looks for scripts 'ui' and 'server' under snf_app

shinyApp(ui=ui, server=server)

### END OF SCRIPT ###
