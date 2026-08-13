
# Note: for deployment, data files need to be inside the app folder
# don't use local paths

#for deploying: 
data_folder <- "data"


#load packages.
library(tidyverse)
library(glue)
library(plotly)
library(zoo)
library(scales)
library(mondate)
library(rintrojs) # to create walkthrough for each tab.
library(lubridate)
library(shiny)
library(shinyWidgets)
library(shinydashboardPlus)
library(shinyBS)
library(shinymanager)
library(shinyjs)
library(bslib)
library(stringr)
library(shinycssloaders)
library(phsmethods)
library(phsstyles)
library(DT)
library("arrow")

##############################################  
####functions
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall=k))


#opposite of %in%
'%!in%' <- function(x,y)!('%in%'(x,y))


#remove scientific notation.
options(scipen=999,
        spinner.type = 1,
        spinner.color="#4242ff",
        spinner.size=1)

##############################################################
###### Load data
#compressed files in app/data folder
#board paid data
board_formulary_paiddata <- arrow::read_parquet(glue("{data_folder}/hb_paid_data.parquet")) 

# 
# test <- arrow::read_parquet("/PHI_conf/PrescribingBCS/Topics/R_server_pro_projects/SNF/Data/paid_extract_2026-04-16.parquet")
# test %>% select(`Paid Calendar Month and Year`) %>% unique() %>% print(n=100)

#cluster paid data
cluster_formulary_paiddata <- arrow::read_parquet(glue("{data_folder}/cluster_paid_data.parquet")) 

# GP practice
practice_formulary_paiddata <- arrow::read_parquet(glue("{data_folder}/practice_paid_data.parquet")) 

# e-prescribing data
board_formulary_eprescribingdata <- arrow::read_parquet(glue("{data_folder}/hb_epr_data.parquet"))

cluster_formulary_eprescribingdata <- arrow::read_parquet(glue("{data_folder}/cluster_epr_data.parquet"))
         
practice_formulary_eprescribingdata <- arrow::read_parquet(glue("{data_folder}/practice_epr_data.parquet"))

#top non formulary - paid.
top_non_formulary_paid <- arrow::read_parquet(glue("{data_folder}/top_non_formulary.parquet")) %>% 
  mutate(`Financial Quarter`= str_replace(`Financial Quarter`, "Q1", "Q1 (Apr-Jun)"),
         `Financial Quarter`= str_replace(`Financial Quarter`, "Q2", "Q2 (Jul-Sep)"),
         `Financial Quarter`= str_replace(`Financial Quarter`, "Q3", "Q3 (Oct-Dec)"),
         `Financial Quarter`= str_replace(`Financial Quarter`, "Q4", "Q4 (Jan-Mar)"))
 
#########################################################################
#LISTS FOR RADIOGROUPBUTTONS ON SIDEBAR FOR EACH PAGE

side_view_list <- c("NHS Board", "GP Cluster", "GP Practice")


##########################################################################
#SELECTINPUT CHOICES
#selections for intro page
intro_choices <- c("Introduction" = "intro",
                    "About" = "about",
                   "Using the dashboard" = "use",
                   "Glossary" = "glossary",
                   "Accessibility" = "accessibility",
                   "Contact" = "contact")


###############################################
#choices for BNF chapter

bnf_chapter_choices <- c("All BNF Chapters",
                         "01-Gastro-Intestinal System",
                         "02-Cardiovascular System",
                         "03-Respiratory System",
                         "04-Central Nervous System",
                         "05-Infections",
                         "06-Endocrine System",
                         "07-Obstetrics, Gynaecology and Urinary-Tract Disorders",
                         "08-Malignant Disease and Immunosuppression",
                         "09-Nutrition and Blood",
                         "10-Musculoskeletal and Joint Diseases",
                         "11-Eye",
                         "12-Ear, Nose and Oropharynx",
                         "13-Skin",
                         "15-Anaesthesia"
                         )                             

#########################################################
phscolours <- c("#3F3685", "#9B4393", "#0078D4", "#83BB26", "#948DA3", "#1E7F84", "#6B5C85", "#C73918", "#655E9D", "#9F9BC2",
                "#C5C3DA", "#ECEBF3", "#AF69A9", "#CDA1C9", "#E1C7DF", "#F5ECF4", "#3393DD", "#80BCEA", "#B3D7F2", "#E6F2FB",
                "#9CC951", "#C1DD93", "#DAEBBE", "#F3F8E9", "#A9A4B5", "#CAC6D1", "#DFDDE3", "#F4F4F6", "#4B999D", "#8FBFC2",
                "#BCD9DA", "#E9F2F3", "#897D9D", "#B5AEC2", "#D3CEDA", "#F0EFF3", "#D26146", "#E39C8C", "#EEC4BA", "#F9EBE8")

plot_colours <- function(vector){
  colours <- c()
  for (i in seq_along(unique(vector))){
    colours <- c(colours, phs_colours(names(phs_colours())[i]))
  }
  return(colours)
}

###############################################
# Colours for plotting ----


#define colours for graphs by board

board_colours  <- function(dataframe){

    df_colours <- dataframe %>%
      ungroup() %>%
      select(NHSBoard) %>%
      distinct() %>%

      mutate(colour = case_when(            # set colour for each board.
        NHSBoard %in% "Region" ~ "#3F3685",
        NHSBoard %in%  "NHS Borders" ~ "#9B4393",
        NHSBoard %in%  "NHS Fife" ~ "#0078D4",
        NHSBoard %in%  "NHS Lothian" ~ "#83BB26")) %>%
        mutate(shape = 19)            # set shape for all
    
    return(df_colours)
  }

##################

