#' Shiny app server object
#'
#' @importFrom graphics hist
#' @import shiny

# library(shiny)
# library(shinyWidgets)
# library(dslabs)
# library(tidyverse)
# library(scales)
# library(ggplot2)

covid <- readRDS(url("https://github.com/UMAD-FCS/COVID19UY/raw/master/data-raw/data_test_2020-08-04.rds"))

covid <- covid %>%
  filter(continent=="South America") %>%
  pivot_longer(cols = c(total_cases, total_cases_per_million,total_deaths_per_million,total_tests_per_thousand),
               names_to = "data", values_to = "value")

# create the shiny application user interface

   shinyAppUI <- fluidPage(

    titlePanel("Evolución COVID 19 - América Latina"),
    sidebarLayout(
      sidebarPanel(
        # inputs
        checkboxGroupInput("location", "Pa?s",
                           choices = unique(covid$location),
                           selected="Uruguay"),
        dateRangeInput("date", strong("Rango de fechas"), start = "2019-12-31", end = "2020-08-03",
                       min = "2019-12-31", max = "2020-08-03"),
        radioGroupButtons("dataInput", "Indicador",
                          choiceNames = list("Total de casos", "Total de casos por millón","Total de muertes por millón","Total de tests por miles"),
                          choiceValues = list("total_cases", "total_cases_per_million","total_deaths_per_million","total_tests_per_thousand"))
      ),

      mainPanel(
        plotOutput("covidplot"),
        br(), br(),
        htmlOutput("resumen")
      )
    )
  )

