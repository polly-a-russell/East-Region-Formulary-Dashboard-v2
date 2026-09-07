
# Paid --------------------------------------------------------------------


# selectInput(
#   inputId = "paid_board_date_min",  ##change
#   label = "Select time period start point:",
#   choices = list_dates_paid_board_asc, ## change
#   selected = min(board_formulary_paiddata$paid_calendar_month_and_year),  ## change
#   multiple = FALSE,
#   selectize = FALSE
# ), # end selectInput paid_board_date_min
# 
# selectInput(
#   inputId = "paid_board_date_max",  ##change
#   label = "Select time period end point:",
#   choices = list_dates_paid_board_desc,  ##change
#   selected = max(board_formulary_paiddata$paid_calendar_month_and_year),  ##change
#   multiple = FALSE,
#   selectize = FALSE
# ) # end selectInput paid_board_date_max
# 
# 
# #board_formulary_paiddata$paid_calendar_month_and_year
# list_dates_paid_board_asc <- board_formulary_paiddata %>% 
#   select(paid_calendar_month_and_year) %>% 
#   unique() %>% 
#   arrange(paid_calendar_month_and_year) %>% pull()
# 
# list_dates_paid_board_desc <- board_formulary_paiddata %>% 
#   select(paid_calendar_month_and_year) %>% 
#   unique() %>% 
#   arrange(desc(paid_calendar_month_and_year)) %>% pull()
# 
# 
# 
# 
# updateSelectInput(session, 'paid_board_date_min', selected = min(board_formulary_paiddata$paid_calendar_month_and_year))
# updateSelectInput(session, 'paid_board_date_max', selected = max(board_formulary_paiddata$paid_calendar_month_and_year))
# 
# 
# 
# 
# #use function from server_functions
# make_chartdata(df = board_formulary_paiddata, 
#                geography_select = input$trend_paid_board, 
#                bnf_chapter_select = input$trend_BNF_chapter_paid_board, 
#                bnf_section_select = input$trend_BNF_section_paid_board, 
#                bnf_sub_section_select = input$trend_BNF_sub_section_paid_board, 
#                dates_select = c(input$paid_board_date_min, input$paid_board_date_max), #input$trend_Dates_paid_board, 
#                geography_type = "NHSBoard", 
#                "paid_calendar_month_and_year")
# 
# 
# shiny::validate(
#   need(input$paid_board_date_min < input$paid_board_date_max, "Minimum date must be less than maximum date")
#   
# )






# Eprescribed -------------------------------------------------------------


# selectInput(
#   inputId = "epresc_board_date_min",  ##change
#   label = "Select time period start point:",
#   choices = list_dates_epresc_board_asc, ## change
#   selected = min(board_formulary_eprescribingdata$week),  ## change
#   multiple = FALSE,
#   selectize = FALSE
# ), # end selectInput epresc_board_date_min
# 
# selectInput(
#   inputId = "epresc_board_date_max",  ##change
#   label = "Select time period end point:",
#   choices = list_dates_epresc_board_desc,  ##change
#   selected = max(board_formulary_eprescribingdata$week),  ##change
#   multiple = FALSE,
#   selectize = FALSE
# ) # end selectInput epresc_board_date_max
# 
# #board_formulary_eprescribingdata$week
# list_dates_epresc_board_asc <- board_formulary_eprescribingdata %>%
#   select(week) %>%
#   unique() %>%
#   arrange(week) %>% pull()
# 
# list_dates_epresc_board_desc <- board_formulary_eprescribingdata %>%
#   select(week) %>%
#   unique() %>%
#   arrange(desc(week)) %>% pull()
#
# updateSelectInput(session, 'epresc_board_date_min', selected = min(board_formulary_eprescribingdata$week))
# updateSelectInput(session, 'epresc_board_date_max', selected = max(board_formulary_eprescribingdata$week))
#
# #use function from server_functions
# make_chartdata(df = board_formulary_eprescribingdata, 
#                geography_select = input$trend_eprescribing_board, 
#                bnf_chapter_select = input$trend_bnf_chapter_eprescribing, 
#                bnf_section_select = input$trend_bnf_section_eprescribing, 
#                bnf_sub_section_select = input$trend_bnf_sub_section_eprescribing, 
#                dates_select = c(input$epresc_board_date_min, input$epresc_board_date_max), #input$trend_Dates_paid_board, 
#                geography_type = "NHSBoard", 
#                "week")
# 
# shiny::validate(
#   need(input$epresc_board_date_min < input$epresc_board_date_max, "Minimum date must be less than maximum date")
# )