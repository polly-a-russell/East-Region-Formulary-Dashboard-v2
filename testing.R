selectInput(
  inputId = "paid_board_date_min",  ##change
  label = "Select time period start point:",
  choices = list_dates_paid_board_asc, ## change
  selected = min(board_formulary_paiddata$paid_calendar_month_and_year),  ## change
  multiple = FALSE,
  selectize = FALSE
), # end selectInput paid_board_date_min

selectInput(
  inputId = "paid_board_date_max",  ##change
  label = "Select time period end point:",
  choices = list_dates_paid_board_desc,  ##change
  selected = max(board_formulary_paiddata$paid_calendar_month_and_year),  ##change
  multiple = FALSE,
  selectize = FALSE
) # end selectInput paid_board_date_max



#use function from server_functions
make_chartdata(df = board_formulary_paiddata, 
               geography_select = input$trend_paid_board, 
               bnf_chapter_select = input$trend_BNF_chapter_paid_board, 
               bnf_section_select = input$trend_BNF_section_paid_board, 
               bnf_sub_section_select = input$trend_BNF_sub_section_paid_board, 
               dates_select = c(input$paid_board_date_min, input$paid_board_date_max), #input$trend_Dates_paid_board, 
               geography_type = "NHSBoard", 
               "paid_calendar_month_and_year")


shiny::validate(
  need(input$paid_board_date_min < input$paid_board_date_max, "Minimum date must be less than maximum date")
  
)