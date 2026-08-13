#UI for Introduction page

ui_intropage <- 

  
# Introduction tab ----
      tabPanel(id= "intro", title="Introduction", 
               icon = icon_no_warning_fn("info"), 
         
     sidebarLayout(
       sidebarPanel(width = 3,
                    radioGroupButtons("intro_select",                               # id for buttons
                                      choices = intro_choices, status = "primary",   #_list defined in setup
                                      direction = "vertical", justified = T)
                    ),
                    
    mainPanel(width= 9,
          conditionalPanel(
                condition= "input.intro_select == 'intro'",   
               
              tags$head(tags$title("East Region Formulary Dashboard")), # give screenreaders title of page
              
              h1("East Region Formulary Dashboard"),
             
             p("This application provides NHS Boards within the East Region of NHS Scotland (NHS Borders, NHS Fife and NHS Lothian)
             the ability to monitor prescribing practice at a local and regional level. 
              It provides an understanding of how closely prescribing practice aligns with recommendations contained within the regional medicines formulary.  
              This highlights areas of prescribing variation for each NHS Board to consider.

               The application has been developed for use within the East Region with a view 
               to being developed for other regions at a later date.
               "),
             
         tags$div(
           HTML(paste("", tags$span(style="color:red", #used to color the writing as red
                                    tags$strong("This dashboard is provisional and to be used for user testing only."))))
              ),    
         br(),
         
         ### Boxes to guide user to right tab
        
         #box to lead to paid tab
       column(3, 
             div(HTML("Paid data"), class = "landing-page-box-title"),
              
              actionButton('tablink_paid', 
                          HTML('You should use paid data when you want to be sure to
                               include everything that has actually been paid for (and/or how much was paid for it).'),
                            class="landing-page-button",
                             icon = icon("arrow-circle-right", "icon-lp")
                            , align = "center")

          ), 

         
         #landing page box for eprescribing data tab.
       column(3,
       
               div("E-prescribed data", class = "landing-page-box-title"),
            
                actionButton('tablink_eprescribing', 
                          HTML('You should use this if looking at near-realtime prescribing patterns in formulary compliance,
                           or if early intervention is necessary to improve prescribing.'),
                            class="landing-page-button",
                             icon = icon("arrow-circle-right", "icon-lp")
                            , align = "center")
          
               ),
         
         #landing page box which leads user to 'top non formulary' data table tab.
        column(3,

              div("Top non-formulary items", class = "landing-page-box-title"),
 
                 actionButton('tablink_nonformulary', 
                              HTML('This tab shows the most common non-formulary drugs by NHS Board in a financial quarter 
                                    using paid data.'),
                             class="landing-page-button",
                             icon = icon("arrow-circle-right", "icon-lp")
                          , align = "center")
    
              )
         ),#conditionalPanel
         
    ###1.About      
         conditionalPanel(
           condition= "input.intro_select == 'about'",   
           h3("About"),
           
          p("This dashboard allows users to look at how closely prescribing practice 
          aligns with recommendations contained within the regional medicines formulary.  
          The ", a(href="https://formulary.nhs.scot/east", "regional formulary", target="_blank"),
          "provides guidance on appropriate and cost-effective prescribing for 
          general practice and hospitals in the East Region of NHS Scotland."),
          
          
           p("The dashboard shows formulary compliance of medicines grouped within British National Formulary
                (BNF) categories: BNF Chapter, Section and Sub Section for 
               making it easier for users to find and understand compliance within groups of medicines.
               "),

          
          h4("Data sources"),
          
          p("The data on this dashboard is sourced from the Prescribing Information System (PIS) by Public Health Scotland
            and linked to the East Region Formulary. The data is updated quarterly."),

          p("For Practice and Cluster level figures, the data is also linked to 
            GP Practice Lookup, available from ",  
            a(href="https://www.opendata.nhs.scot/dataset/gp-practice-contact-details-and-list-sizes", "PHS Open Data.", target="_blank"),
            "Practice details and associated GP Clusters are subject to change and updated quarterly."),          
             
          
          h4("Caveats"),
          
          p("We are aware of an error affecting PIS data currently, where 
            some Products are not being assigned BNF classifications. This is estimated to leave out around 0.4% of the data per month."),
           p("The list of formulary medicines uses the latest dm+d codes and descriptions. Please note however that
               dm+d is continuously updated in PIS."),
          
          p("Data for some GP Practices shows 100% compliance, which is likely
            caused by small practices not having any items for certain BNF Sub Sections.")
          
         ),
    
    # 2.  Using the dashboard
    conditionalPanel(
      condition= "input.intro_select == 'use'",
      tags$h3("Using the dashboard"),   
      
      tags$h4("Interacting with the dashboard"),
      p("Within each tab, there are dropdown menus that allow the user to select the relevant measure, time period, NHS Board, and BNF Chapter, Section or Sub Section. 
        Trend graphs are interactive and hovering the mouse over a specific data point will bring up more information. 
        Moving the x and y axes on graphs allows you to move backwards and forwards, up and down on the data points 
        (e.g., users can zoom into a specific month on the x-axis).
        You can also zoom in and out of the graph by double-clicking and drawing square on the graph."),
      
      p("Each page includes a walkthrough tour that is initiated by clicking on the 'Walkthrough' button."),
      
      p("Be aware that the dashboard will time out after a period of inactivity."),
      
      tags$h4("Downloading data"),
          p("Users can select the specific level of interest they wish to explore and then 
          click the ‘Download data’ button to download a csv file."),

        ), # conditionalPanel
    
  ### 3. Glossary  
    conditionalPanel(
      condition= "input.intro_select == 'glossary'",   
      h3("Glossary"),
      
      linebreaks(1),
      
      p(strong("British National Formulary (BNF) "), "- A standard classification of medicines into conditions of primary therapeutic use,
               the aim is to provide prescribers, pharmacists and other healthcare professionals with sound up-to-date information about
               the use of medicines."),
      
      p(strong("NHS Board "), "– NHS Board of Dispensing which is the NHS Board with which the dispenser holds a dispensing contract, i.e. Community
        Pharmacy, Dispensing Doctor or Appliance Supplier."),
      
      p(strong("PIS "), "– Prescribing Information System, which holds data on prescriptions dispensed within the community."),
      
      p(strong("Paid data "), "- Refers to prescriptions that have been processed through the Data Capture Validation Pricing (DCVP) system by Practitioner Services Division (PSD)
                             in order for pharmacies to be paid for the prescriptions they dispense."),
      
      p(strong("E-Prescribed data "), "- Information specific to individual electronic prescription forms and the items as prescribed on them.
      from electronic messages. There is a much shorter delay between the time a prescription is issued and dispensed. 
        C. 90 % of items are supported with an electronic message."),
      
      p(strong("Gross Ingredient Cost (GIC) "), "- Cost of medicines and appliances reimbursed before deduction of any dispenser discount (note: this
        definition differs from other parts of the UK). This measure is used to make comparisons at an item level."),
      
      p(strong("Item "), "- An item is an instance of dispensing of a medicine or device. E.g. a packet of 30 cetirizine 10mg tablets or a 50mg tube
        of emollient cream is one item if so prescribed."),
      
      p(strong("Virtual Medicinal Product (VMP) "), "- A generic description of a prescription that usually describes
              a medicine presented as a specified formulation and strength."),
      
      p(strong("Actual Medicinal Product (AMP) "), "- Branded products or generic products available from specified suppliers."),
    
      p(strong("Product Name "), "- The description of the product as prescribed, dispensed or paid.
                                  This will correspond to a VMP or AMP name.")
      
    ),

    # Accessibility
    conditionalPanel(
      condition= "input.intro_select == 'accessibility'",
      h3("Accessibility"),
      
      p("This website is run by ", a(href="https://www.publichealthscotland.scot/",
                                     "Public Health Scotland,", target="_blank"), 
        " Scotland's national organisation for public health. Public
         Health Scotland is committed to making its website accessible, in accordance with
         the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility
         Regulations 2018."),
      p(a(href="https://mcmw.abilitynet.org.uk/", "AbilityNet", target="_blank"),
        " has advice on making your device easier to use if you have a disability."),
      
      h4("How accessible this website is"),
      p("This site has not yet been evaluated against WCAG 2.1 level AA."),
      
      h4("Reporting any accessibility problems with this website"),
      p("If you wish to contact us about any accessibility issues you encounter on this site, please email ",
        tags$b(tags$a(href="mailto:phs.prescribing@phs.scot",
                      "phs.prescribing@phs.scot", class="externallink")),"."),
      
      
      h4("Enforcement procedure"),
      p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the Public Sector Bodies (Websites and Mobile Applications) (No. 2) 
    	                          Accessibility Regulations 2018 (the ‘accessibility regulations’). 
    	                          If you’re not happy with how we respond to your complaint, contact the", 
        a("Equality Advisory and Support Service (EASS).", href= "https://www.equalityadvisoryservice.com/",  target="_blank"))
    ),
    
    # Contact        
    conditionalPanel(
      condition= "input.intro_select == 'contact'",
      h3("Contact and Enquiries"),
      p("If you have any questions or feedback regarding this dashboard or any information contained within it, please contact us at: ",
        tags$b(tags$a(href = "mailto:phs.prescribing@phs.scot",
                      "phs.prescribing@phs.scot", class="externallink")),
        " and we will be happy to help."),
      
    ) # conditionalPanel
      
      ) #mainpanel
       ) #sidebarlayout
  
)#tab panel
