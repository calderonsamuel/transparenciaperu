library(shiny)
library(shinyWidgets)
library(lubridate)
library(stringr)
library(rclipboard)

entidades <- read.csv("codigo_entidad.csv", encoding = "UTF-8")


ui <- fluidPage(
    
    rclipboardSetup(),

    # Application title
    titlePanel("Transparencia Peru"),

    sidebarLayout(
        sidebarPanel(
            tags$p("Aquí podrás conseguir una vía rápida para obtener datos 
                    de los portales de transparencia. 
                   Por lo pronto, puedes descargar datos de personal que ha
                   trabajado en los ministerios, desde enero 2016 a marzo 2020."),
            tags$h2("Instrucciones"),
            tags$ol(
                tags$li("Selecciona la entidad."),
                tags$li("Elige el mes y año de la información."),
                tags$li('Haz click en "Descargar", 
                        se abrirá una pestaña que se cerrará 
                        cuando inicie el proceso de descarga. 
                        Puedes copiar el enlace de descarga si deseas conservarlo')
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
                               minDate = "2016-01-08",
                               language = "es")
        ),

        mainPanel(
            
            fluidRow(
                column(width = 2, uiOutput("descarga")),
                column(width = 2, uiOutput("clip"))
            )
            
            
        )
    )
)

server <- function(input, output) {

    link1 <- reactive({
        
        codigo_entidad <- subset(entidades, Entidad %in% input$entidad)$Codigo
        year <- year(input$fecha)
        month <- str_pad(month(input$fecha), width = 2, pad = "0")
        
        paste0("http://www.transparencia.gob.pe/personal/pte_transparencia_personal_genera.aspx?",
                    "id_entidad=", codigo_entidad,
                    "&in_anno_consulta=", year,
                    "&ch_mes_consulta=",month,
                    "&ch_tipo_regimen=0",
                    "&vc_dni_funcionario=",
                    "&vc_nombre_funcionario=",
                    "&ch_tipo_descarga=1")
    })
    
    output$clip <- renderUI({
        rclipButton(inputId = "clipbtn", 
                    label = "Copiar enlace de descarga", 
                    clipText = link1(), 
                    icon = icon("clipboard"))
    })
    
    output$descarga <- renderUI({
        tags$a("Descargar", href = link1(), target = "_blank")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
