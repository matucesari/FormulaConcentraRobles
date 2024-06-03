La aplicación desarrollada en Shiny incorpora una función estimar_concentracion diseñada para predecir la concentración de soluciones basada en diversos parámetros introducidos por el usuario. Esta función toma entradas específicas, como sólidos solubles (formulación), posición radial, día, hora, y temperatura, y utiliza una ecuación lineal derivada de un modelo de mínimos cuadrados parciales (PLS). La ecuación integra estos factores para predecir la concentración en grados Brix de una solución en el contexto del tratamiento de confitado de cerezas. Las variables de entrada son convertidas a índices numéricos mediante funciones auxiliares antes de ser procesadas, asegurando que el modelo maneje correctamente las entradas textuales y categóricas.

Además, la aplicación emplea observadores Shiny para monitorizar cuando el usuario solicita un cálculo de concentración. Al activar el botón correspondiente, se recogen las entradas de la interfaz, se transforman adecuadamente mediante las funciones de índice, y se pasan a la función estimar_concentracion. El resultado se redondea y se presenta al usuario, mostrando cómo las variables de entrada influyen directamente en la concentración estimada.

Esta capacidad de calcular en tiempo real la concentración basada en condiciones controladas y variables experimentalmente significativas es fundamental para la verificación y aplicación práctica de los modelos PLS desarrollados durante la investigación. Representa no solo un avance técnico en la manipulación y tratamiento de los datos experimentales, sino que también facilita la interpretación y aplicación directa de los resultados científicos en un formato accesible para los usuarios finales, apoyando así los objetivos más amplios de la investigación documentada en la tesis.

## Descripción del Repositorio
El código fuente completo para la implementación de la fórmula de concentración se encuentra disponible en un repositorio público de GitHub. Se puede acceder al código a través del siguiente enlace: https://github.com/matucesari/FormulaConcentraRobles. Este repositorio incluye todos los scripts necesarios para ejecutar la función y reproducir los resultados presentados en esta tesis, respecto a la fórmula de predicción de la concentración a partir del modelado PLS..

## Detalles del Código
Explica cómo está organizado el repositorio y qué archivos son importantes. 

El repositorio FormulaConcentraRobles podría estar estructurado de la siguiente manera:

* README.md: Un archivo de descripción que ofrece información sobre el proyecto, cómo instalar y ejecutar el código.
* app.R: El script principal que contiene la función de concentración que aplica el modelado PLS.

## Clonar el repositorio
Para utilizar el código, primero necesitarás clonar el repositorio en tu máquina local. Esto se puede hacer usando el siguiente comando en la terminal:
```
git clone https://github.com/matucesari/FormulaConcentraRobles.git
```
El archivo app.R que has subido parece contener un script para una aplicación Shiny, diseñada para ser ejecutada en R. Aquí te detallo cómo está estructurado el código y cómo puedes describir su uso en tu tesis:
### Estructura del archivo app.R
* Carga de bibliotecas: Inicialmente, el script asegura que todas las bibliotecas necesarias estén instaladas y cargadas. Usa un conjunto específico de paquetes Shiny para la interfaz de usuario.
* Definición de la interfaz de usuario: La interfaz de usuario está compuesta por un encabezado (dashboardHeader), una barra lateral (dashboardSidebar) y el cuerpo principal (dashboardBody) que incluye estilos CSS personalizados y diferentes paneles para la entrada de datos.
* Componentes interactivos: Incluye botones y otros elementos interactivos como parte de la barra lateral y del cuerpo, diseñados para facilitar la interacción del usuario con la aplicación.
## Utilización de la aplicación en Shiny
Para utilizar esta aplicación Shiny, aquí tienes los pasos básicos que cualquier usuario debería seguir, y que podrías incluir en tu tesis:
* Instalación y ejecución:
- Asegurarse de que R y RStudio están instalados.
- Clonar o descargar el repositorio desde GitHub.
- Abrir el archivo app.R en RStudio.
- Instalar las dependencias necesarias como se muestra al inicio del script.
- Ejecutar la aplicación haciendo uso de shiny::runApp() en el mismo directorio que el archivo app.R.
* Interacción con la aplicación:
Los usuarios pueden interactuar a través de la barra lateral y los paneles de entrada de datos.
Las predicciones o cálculos se realizan utilizando los botones y controles disponibles en la interfaz.

## Ejemplo de Código
A continuación se proporciona  un pequeño fragmento de código para ilustrar la función principal. 
```
# Función para estimar la concentración basada en entradas específicas
  estimar_concentracion <- function(s, r, dia, hora, temp) {
  # Ecuación matemática del PLS que utiliza 
  # las entradas para calcular la concentración
    Concentracion = -6.53465524569392 - 0.306972407658525 * s + 
					0.115632510980474 * temp + 
					12.0872742083835 * dia + 
					0.601715896263016 * hora + 
					0.852637319118771 * r
    return(Concentracion)
  }
```
La aplicación desarrollada en Shiny está diseñada para estimar la concentración de una solución basándose en un conjunto de parámetros ingresados por el usuario. La función central, estimar_concentracion, utiliza un modelo de predicción basado en el método de mínimos cuadrados parciales (PLS) para calcular la concentración. Esta función toma como argumentos los valores de solidos solubles (s), la localización en el radio (r), el día (dia), la hora (hora) y la temperatura (temp), aplicando una ecuación matemática específica que integra estos factores.

Además, la aplicación incluye funciones auxiliares como indice_dia, indice_radio, y indice_solu, que convierten las entradas textuales de los usuarios a índices numéricos adecuados para el procesamiento del modelo. Estas funciones utilizan estructuras condicionales para asignar un valor numérico a cada una de las posibles entradas, facilitando así su inclusión en la ecuación de predicción.

Una vez que el usuario proporciona los datos necesarios a través de la interfaz gráfica y presiona el botón para calcular la concentración, la aplicación activa un observador (observeEvent) que llama a la función estimar_concentracion con los parámetros adecuados. El resultado se redondea y se muestra en la interfaz de usuario, indicando la concentración estimada en grados Brix, junto con los detalles de la medición como el tipo de solución, la localización en el radio, el día, la hora y la temperatura ambiental.

Este enfoque no solo facilita la comprensión y aplicación práctica de modelos PLS en entornos reales sino que también proporciona una herramienta interactiva para visualizar cómo diferentes variables pueden influir en la concentración estimada de una solución.
