library(shiny)
library(shinyWidgets)

ui <- fluidPage(

    # Application title
    titlePanel("Transparencia Peru"),

    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "entidad",
                        label =  "Entidad", 
                        choices = "Ministerio de Vivienda, Construcción y Saneamiento",
                        selected = "Ministerio de Vivienda, Construcción y Saneamiento"),
            
            # dateInput(inputId = "fecha",
            #           label = "Año y mes", 
            #           value = "2020-03-01",
            #           min = "2020-01-01",
            #           max = "2020-03-01", 
            #           format = "yyyy-mm"),
            
            airDatepickerInput(inputId = "fecha", 
                               label = "Mes y año", 
                               value = "2020-03-02",
                               dateFormat = "MM-yyyy",
                               view = "months",
                               minView = "months", 
                               autoClose = TRUE, 
                               maxDate = "2020-03-31", 
                               minDate = "2018-01-01",
                               language = "es"),
            
            actionButton("shinyWB",
                       "Descarga",
                       icon("cloud-download")),
            
            uiOutput("boton"),
            # tags$div(class = "submit",
            #          tags$a(href = "https://www.google.com", 
            #                 "Learn More", 
            #                 target="_blank")
            # )
            
            
        ),

        mainPanel(
        )
    )
)

server <- function(input, output) {

    # observeEvent(input$shinyWB, {
    #     link <- "https://www.google.com"
    #     tags$script(paste0("window.open('", link, "', '_blank')"))
    # })
    
    output$boton <- renderUI({
        req(input$shinyWB > 0)
        link <- "http://www.transparencia.gob.pe/personal/pte_transparencia_personal_genera.aspx?id_entidad=11476&in_anno_consulta=2020&ch_mes_consulta=01&ch_tipo_regimen=0&vc_dni_funcionario=&vc_nombre_funcionario=&ch_tipo_descarga=1"
        tags$script(paste0("window.open('", link, "', '_blank')"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
