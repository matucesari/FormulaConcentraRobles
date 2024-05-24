# Cargar librerías necesarias
libraries <- c("shiny", "shinyWidgets", "shinydashboard")

# Instalar los paquetes que no están ya instalados, incluyendo sus dependencias
install.packages(setdiff(libraries, rownames(installed.packages())), dependencies = TRUE)

# Cargar las librerías especificadas
lapply(libraries, library, character.only = TRUE)

# Definición de la interfaz de usuario de la aplicación Shiny
# Encabezado de la página con título personalizado
header <- dashboardHeader(title="Noelia Robles")

# Barra lateral que incluye título del proyecto y botón de salida
sidebar <- dashboardSidebar(
  h3("Predicción de la Concentración en el Proceso de Inmersión de Cerezas"),
  actionButton("exit_btn", "Salir") 
)

# Cuerpo de la página, incluyendo estilos CSS personalizados y paneles de entrada de datos
body <- dashboardBody(
  tags$head(
    tags$style(HTML("
            .big-bold {
                font-size: 20px;
                font-weight: bold;
            }
            .prediction {
                font-size: 18px;
            }
        "))
  ),
  tabsetPanel(
    tabPanel("Predicción Manual", 
      sidebarLayout(
          sidebarPanel(
            selectInput("solu", "Solución:", choices = c("Sac100", "Sac50Iso50","Malt50Iso50","Sac50Malt50")), 
            selectInput("dia", "Día de la semana en Inmersión:", choices = c("lunes", "martes", "miercoles", "jueves", "viernes")),     
            selectInput("radio", "Posición de inmersión:", choices = c("exterior", "intermedio", "central")),  
            numericInput("hora", "Período de tiempo trascurrido desde la Inmersión (en el día):", min = 0.25, value = 0.25, max = 6),
            numericInput("temperatura", "Temperatura en grado centígrados de la solución:", min = 0, value = 40),
            actionButton("calcular", "Calcular Concentración")
          ),
          uiOutput("contenido_dinamico")
      )
    ),
    tabPanel("Carga de Datos", 
      sidebarLayout(
        box(width = 12,
                h3("Carga de fichero CSV"),
                radioButtons("sep", "Separador de campos:", 
                             choices = c(Coma = ",", Punto_y_Coma = ";", Tabulador = "\t"), 
                             selected = ";"),
                radioButtons("dec", "Separador decimal:", 
                             choices = c(Coma = ",", Punto = "."), 
                             selected = '.'),
                h3(" "), 
                fileInput("file1", "Elija un fichero CSV con las siguientes columnas: dia, radio, hora y temperatura",
                          accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")
                ),
                box(actionButton("btn_cargar", "Cargar y Calcular")),
                box(width = 12,
                  h5(" "), 
                  h5("La tabla debe tener los siguientes nombres de columnas: "),
                  h5("solu | dia | radio | hora | temperatura"),
                  h5(" "), 
                  h5("La columna solu debe tener uno de las siguientes categorias: "),
                  h5("Sac100 / Sac50Iso50 / Malt50Iso50 / Sac50Malt50"),
                  h5("La columna dia debe tener uno de las siguientes categorias: "),
                  h5("lunes / martes / miercoles / jueves / viernes"),
                  h5("La columna radio debe tener uno de las siguientes categorias: "),
                  h5("exterior / intermedio / central"),
                  h5("La columna hora es numerica y representa hora en decimal"),
                  h5("La columna temperatura es numerica y representa temperatura en grado Celsius")
                )
          ),
          uiOutput("resultados_carga")
     )
  )
)
)

# Combinación de los componentes UI para formar la página completa
ui <- dashboardPage(
  skin = "blue",
  header,
  sidebar,
  body
)

# Lógica del servidor para gestionar entradas y realizar cálculos
server <- function(input, output) {
  # Función para estimar la concentración basada en entradas específicas
  estimar_concentracion <- function(s, r, dia, hora, temp) {
    # Ecuación matemática del PLS que utiliza las entradas para calcular la concentración
    Concentracion = -6.53465524569392 - 0.306972407658525 * s + 0.115632510980474 * temp + 12.0872742083835 * dia + 0.601715896263016 * hora + 0.852637319118771 * r
    return(Concentracion)
  }
  
  # Funciones auxiliares para convertir entradas textuales a índices numéricos
  indice_dia <- function(d) {
    # Convertir a minúsculas
    d <- tolower(d)
    # Calcular el índice correspondiente al día
    return(switch(d, "lunes" = 1, "martes" = 2, "miercoles" = 3, "jueves" = 4, "viernes" = 5))
  }
  
  indice_radio <- function(r) {
    # Convertir a minúsculas
    radio <- tolower(r)
    i_radio <- switch(radio, 
                      "exterior" = 1,
                      "intermedio" = 2,
                      "central" = 3)
    return(i_radio)
  }
  
  indice_solu <- function(s) {
    i_solu <- switch(s, 
                     "Sac100" = 1,
                     "Sac50Iso50" = 2,
                     "Malt50Iso50" = 3,
                     "Sac50Malt50" = 4)
    return(i_solu)
  }
  
  # Observador para el botón de cálculo de concentración
  observeEvent(input$calcular, {  
    concentracion <- round(estimar_concentracion(indice_solu(input$solu),
                                                 indice_radio(input$radio), 
                                                 indice_dia(input$dia), 
                                                 input$hora, 
                                                 input$temperatura), 1)
    output$resultado <- renderText({
      paste(concentracion, "para radio", input$radio, " y ", input$solu)
    })
    
    # Renderiza dinámicamente el contenido cuando se presione el botón
    output$contenido_dinamico <- renderUI({
      mainPanel(
        h4("La concentración estimada de solutos es:"),
        div(class = "big-bold", textOutput("resultado")),
        h6("Predicción con R2 = 0.96")
      )
    })
  })      
 
  # Observador para el botón de carga de datos
  observeEvent(input$btn_cargar, {
    req(input$file1) # Requerir un fichero
    # Leer los datos del fichero CSV
    datos <- as.data.frame(read.csv(input$file1$datapath, 
                                    dec = input$dec, 
                                    sep = input$sep, 
                                    stringsAsFactors=TRUE
    ))
    print(datos)
    # Asegurarse de que los datos tienen las columnas correctas
    req(all(c("solu","dia", "radio", "hora", "temperatura") %in% names(datos)))
    datos2 <- datos
    # Aplicar las funciones a las columnas correspondientes
    datos2$solu <- sapply(datos$solu, indice_solu)
    datos2$radio <- sapply(datos$radio, indice_radio)
    datos2$dia <- sapply(datos$dia, indice_dia)
    print(datos2)
    # Calcular las estimaciones para cada fila
    resultados <- sapply(1:nrow(datos2), function(i) {
      estimar_concentracion(datos2$solu[i], datos2$radio[i], datos2$dia[i], datos$hora[i], datos$temperatura[i])
    })
    # Mostrar los resultados en una tabla
    output$resultados_carga <- renderTable({
      cbind(datos, Concentracion_Estimada = resultados)
    })
  })
  
  # Funcionalidad para detener la aplicación al presionar el botón de salida
  observeEvent(input$exit_btn, {
    stopApp()  
  })
  
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)
