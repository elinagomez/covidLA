#' Shiny app server function
#'
#' @param input provided by shiny
#' @param output provided by shiny
#'

shinyAppServer <- function(input, output) {

  d <- reactive({
    covid %>%
      filter(location %in% input$location,
             date > as.POSIXct(input$date[1]) & date < as.POSIXct(input$date[2]),
             data == input$dataInput)
  })

  output$covidplot <- renderPlot({

    ggplot(d(), aes(x=as.POSIXct(date), y = value, color = location)) +
      geom_line(size=1,stat="identity") +
      theme(legend.title = element_blank() ,axis.text.x = element_text(size=15),
            axis.text.y = element_text(size=15),
            plot.title = element_text(size=20),
            axis.title.x=element_blank(),axis.title.y=element_blank())+
      scale_x_datetime(labels = date_format("%b-%Y"))+
      xlab("Fecha") +
      ylab("Total") +
      ggtitle(paste("Evolución del",input$dataInput))


  })

  output$resumen <- renderText({
    library(knitr)
    library(kableExtra)

    d() %>%
      filter(date==max(date))%>%
      group_by(location,data) %>%
      select(date,value) %>%
      rename(Pais = location, Indicador=data, Fecha=date, Valor=value)%>%
      knitr::kable("html")%>%
      kable_styling("striped", full_width = F)

  })

  output$texto <- renderText({
    paste("Se presenta el último dato disponible.")
  })
  
}