# landing page 
# observe events to take user to desired tab ----

#paid
observeEvent(input$tablink_paid, {
              #intabset is the navbarpage id, selected is the tabpanel value
  updateNavbarPage(session = getDefaultReactiveDomain(), "intabset", selected = "paid")
})

#eprescribing
observeEvent(input$tablink_eprescribing, {
  
  updateNavbarPage(session = getDefaultReactiveDomain(), "intabset", selected = "eprescribing")
  
})

# top non formulary items.
observeEvent(input$tablink_nonformulary, {
  
  updateNavbarPage(session = getDefaultReactiveDomain(), "intabset", selected = "top20")
  
})