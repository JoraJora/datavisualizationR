#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("APP Ejercicio2"),
  
  sidebarPanel( 
    numericInput("minedad", "Edad Minima",-1,-1,99),
    numericInput("maxedad", "Edad Maxima",99,-1,99),
    checkboxGroupInput("gender","Genero",c(
      "Male"="Hombre",
      "Female"="Mujer")),
    checkboxGroupInput("region","Region",c(
      "NOA"="NOA",
      "NEA"="NEA",
      "Cuyo"="Cuyo",
      "CABA"="CABA",
      "Buenos Aires"="BA",
      "Centro"="Centro",
      "Patagonia"="Patagonia")),
    checkboxGroupInput("year","Anio",c(
      "2010"="2010",
      "2011" ="2011",
      "2012" = "2012")),
    submitButton(text="Actualizar")),
  
  mainPanel(
    htmlOutput("linech")
  )
))