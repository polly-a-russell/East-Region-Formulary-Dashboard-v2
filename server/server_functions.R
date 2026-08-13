# Functions used in server scripts

# Dropdown selectors for BNF levels ----

bnf_section_selector <- function(df, bnf_chapter_select, input_id){
  req(bnf_chapter_select)
  
  data_available <- df %>%
    filter(bnf_level != 'Sub Section',
           BNF_chapter == bnf_chapter_select
            ) %>% 
    select(BNF_section)
  
  if (bnf_chapter_select != 'All BNF Chapters') {
    
    selectInput(
      inputId = input_id,
      label = 'Select BNF Section:',
      choices = unique(data_available),
      selected = 'All BNF Sections',
      selectize = FALSE,
      multiple = FALSE) 
    
  }  else{
    return(NULL)
  }
}

bnf_sub_section_selector <- function(df, bnf_chapter_select, bnf_section_select, input_id){
  req(bnf_chapter_select, bnf_section_select)
  
  data_available <- df %>% 
    filter(bnf_level != 'Chapter',
           BNF_chapter == bnf_chapter_select,
           BNF_section == bnf_section_select) %>% 
    select(BNF_sub_section)
  
  if (bnf_chapter_select != 'All BNF Chapters' && 
      bnf_section_select != 'All BNF Sections') {
    
    selectInput(
      inputId = input_id,
      label = 'Select BNF Sub Section:',
      choices = unique(data_available),
      selected = 'All BNF Sub Sections',
      selectize = FALSE,
      multiple = FALSE) 
    
  }  else{
    return(NULL)
  }
}
################################################################################
#Prepare data for charts ----

make_chartdata <- function(df, geography_select, bnf_chapter_select, 
                           bnf_section_select, bnf_sub_section_select, 
                           dates_select, geography_type, dates_type){
  
  req(bnf_chapter_select)  # Ensure input is initialized
  
  # Filter data by chapter, board, time
  data <- df %>%
    filter(df[[geography_type]] %in% geography_select,
          
           BNF_chapter == bnf_chapter_select,
           df[[dates_type]] >= dates_select[1] &
             df[[dates_type]] <= dates_select[2])
  
  if (!is.null(bnf_chapter_select) && bnf_chapter_select != "") {
    
    if (!is.null(bnf_section_select) && bnf_section_select != 'All BNF Sections' && bnf_chapter_select != 'All BNF Chapters') {
      
      #Filter by selected Section
      data <- data %>%
        filter(BNF_section == bnf_section_select)
      
      # Filter by selected Sub-Section
      if (!is.null(bnf_sub_section_select) && bnf_sub_section_select != 'All BNF Sub Sections') {
        
        data <- data %>%
          filter(bnf_level == 'Sub Section',
                 BNF_sub_section == bnf_sub_section_select) 
      } else {
        
        data <- data %>%
          filter(bnf_level == 'Section',
                 BNF_sub_section == "All BNF Sub Sections") 
        }
      
    } else {
      
      data <- data %>% 
        filter(bnf_level == if_else(bnf_chapter_select == 'All BNF Chapters', 'All', 'Chapter'),
               BNF_chapter == bnf_chapter_select,
               BNF_section == "All BNF Sections", 
               BNF_sub_section == "All BNF Sub Sections") 
    }
  }
  # Return the data
  return(data)
}

#Select BNF level for titles

bnf_text <- function(bnf_chapter_select, bnf_section_select, 
                     bnf_sub_section_select){
  
  if (!is.null(bnf_chapter_select) && bnf_chapter_select != "") {
    # Check if Section input is available and valid
    if (!is.null(bnf_section_select) && bnf_section_select != 'All BNF Sections' && bnf_chapter_select != 'All BNF Chapters') {
      
      if (!is.null(bnf_sub_section_select) && bnf_sub_section_select != 'All BNF Sub Sections') {
        bnf_text <- bnf_sub_section_select
      } else { 
        bnf_text <- bnf_section_select
      } 
      
    } else {
      # Default to Chapter if no Section or Subsection is selected
      bnf_text <- bnf_chapter_select
    }
    
  } else {
    bnf_text <- NULL  # or some default value if necessary
  }
} 