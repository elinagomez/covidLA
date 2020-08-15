#' Shiny app server object
#'
#' @import shiny
# 

data("covid")

  covid <- covid %>%
  filter(continent=="South America") %>%
  rename("Total de casos"=total_cases, "Total de casos por millón"=total_cases_per_million, "Total de muertes por millón"=total_deaths_per_million, "Total de tests por miles"=total_tests_per_thousand) %>% 
  gather("data","value","Total de casos","Total de casos por millón","Total de muertes por millón","Total de tests por miles")



   shinyAppUI <- fluidPage(

    titlePanel("Evolución COVID 19 - América Latina"),
    sidebarLayout(
      sidebarPanel(
        # inputs
        checkboxGroupInput("location", "País",
                           choices = unique(covid$location),
                           selected="Uruguay"),
        dateRangeInput("date", strong("Rango de fechas"), start = "2019-12-31", end = "2020-08-03",
                       min = "2019-12-31", max = "2020-08-03"),
        radioGroupButtons("dataInput", "Indicador",
                          choiceNames = list("Total de casos", "Total de casos por millón","Total de muertes por millón","Total de tests por miles"),
                          choiceValues = list("Total de casos", "Total de casos por millón","Total de muertes por millón","Total de tests por miles"))
      ),

      mainPanel(
        plotOutput("covidplot"),
        br(), br(),
        htmlOutput("resumen"),
        textOutput(outputId = "texto"),
        tags$a(href = "https://www.observatoriocoviduy.org",
               "Fuente: Observatorio COVID19 en Uruguay/UMAD (FCS-UdelaR) ", target = "_blank")
      )
    )
  )

