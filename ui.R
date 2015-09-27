library(shiny)
suppressMessages(library(leaflet))
categories = c('Burglary', 'Criminal Damage', 'Drugs',
               'Fraud & Forgery', 'Robbery', 'Sexual Offences',
               'Violence Against The Person', 'Theft & Handling',
               'Other Notifiable Offences')

shinyUI(pageWithSidebar(
    headerPanel("London Crime Rate by Borough"),
    sidebarPanel(
        p('The difference in crime rates between London boroughs is dominated
           by thefts particularly in the borough of Westminster.'),
        checkboxGroupInput('crime_list', 'Select Crimes to Include',
                           categories, selected = categories),
        p('Data for the 32 boroughs (excludes City of London) is from the',
            a('London Datastore',
              href = 'http://data.london.gov.uk/dataset',
              target = "_blank"))
    ),
    mainPanel(
        h3('Click the map for borough ids'),
        leafletOutput('londonmap'),
        p('Based on the tutorial in Lovelace, R., & Cheshire, J. (2014).
           Introduction to visualising spatial data in R. National Centre for
           Research Methods Working Papers, 14(03). Retrieved from',
           a('https://github.com/Robinlovelace',
             href = 'https://github.com/Robinlovelace/Creating-maps-in-R',
             target = "_blank"))
    )
))
