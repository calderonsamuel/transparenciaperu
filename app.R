library(shiny)
library(shinyWidgets)
library(lubridate)
library(stringr)
library(rclipboard)

entidades <- read.csv("codigo_entidad.csv")


ui <- fluidPage(
    
    rclipboardSetup(),

    # Application title
    titlePanel("Transparencia Peru"),

    sidebarLayout(
        sidebarPanel(
            tags$p("Aquí podrás conseguir una vía rápida para obtener datos de los portales de transparencia. 
                   Por lo pronto, puedes descargar datos de personal que ha trabajado en los ministerios, desde enero 2016 a marzo 2020."),
            tags$h2("Instrucciones"),
            tags$ol(
                tags$li("Selecciona la entidad."),
                tags$li("Elige el mes y año de la información."),
                tags$li('Haz click en Copiar url y pega (Ctrl+V) el texto en la barra de dirección de una nueva pestaña. 
                        También puedes seleccionar el texto (triple click), hacerle click derecho y elegir "Ir a ..."')
            ),
            selectInput(inputId = "entidad",
                        label =  "Entidad", 
                        choices = entidades$Entidad,
                        selected = "Presidencia del Consejo de Ministros (PCM)"),
            
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
            
            # actionButton("shinyWB",
            #            "Descarga",
            #            icon("cloud-download")),
            # 
            # uiOutput("boton")
        ),

        mainPanel(
            
            fluidRow(
                column(width = 2, uiOutput("clip")),
                column(width = 6,
                tags$h5(textOutput("url"),1))
            )
            
        )
    )
)

server <- function(input, output) {

    # observeEvent(input$shinyWB, {
    #     link <- "https://www.google.com"
    #     tags$script(paste0("window.open('", link, "', '_blank')"))
    # })
    link1 <- reactive({
        
        codigo_entidad <- subset(entidades, Entidad %in% input$entidad)$Codigo
        year <- year(input$fecha)
        month <- str_pad(month(input$fecha), width = 2, pad = "0")
        
        paste0("http://www.transparencia.gob.pe/personal/pte_transparencia_personal_genera.aspx?",
                    "id_entidad=", codigo_entidad,
                    "&in_anno_consulta=", year,
                    "&ch_mes_consulta=",month,
                    "&ch_tipo_regimen=0&vc_dni_funcionario=&vc_nombre_funcionario=&ch_tipo_descarga=1")
    })
    
    # output$boton <- renderUI({
    #     req(input$shinyWB > 0)
    #     
    #     link2 <- "http://www.transparencia.gob.pe/personal/pte_transparencia_personal_genera.aspx?id_entidad=136&in_anno_consulta=2020&ch_mes_consulta=03&ch_tipo_regimen=0&vc_dni_funcionario=&vc_nombre_funcionario=&ch_tipo_descarga=1"
    #         
    #     tags$script(paste0("window.open('", link2, "', '_blank')"))
    # })
    
    output$url <- renderText({
        link1()
    })
    
    output$clip <- renderUI({
        rclipButton("clipbtn", "Copiar url", link1(), icon("clipboard"))
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
