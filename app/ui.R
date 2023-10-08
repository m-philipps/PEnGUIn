fluidPage(
  
  title = 'PEnGUIn',
  
  tabsetPanel(
    tabPanel("Model", fluid = TRUE,
    sidebarLayout(
      sidebarPanel(
         h2('PEnGUIn'),
         width = 2,
         shinyFilesButton(
           id = "fileInput",
           label = "Select Files",
           title = "Upload a PETab Problem",
           multiple = T),
         br(),
         tags$small("Selected Files:"),
         verbatimTextOutput("selectedFiles")
       ),
      mainPanel(
         tabsetPanel(
         tabPanel(
           h4("SBML"),
           verbatimTextOutput("SMBL_model"),
           actionButton(
             "local2global",
             label = "convert local to global params"
           ),
           tags$head(tags$style("#SMBL_model{color:black; font-size:12px; overflow-y:scroll; max-height: 500px; background: ghostwhite;}"))),
         tabPanel(
           h4("Antimony?"),
           uiOutput("SMBL_model_2"),
           actionButton(
             "convert2SBML",
             label = "convert to SBML"
           )
           #div(uiOutput("SMBL_model_2"), style = "color:black; font-size:12px; overflow-y:scroll; max-height: 500px; background: ghostwhite;")
         )
       )
       )
      )
    ),
    tabPanel("Problem Specification", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 h2('Settings'),
                 width = 2
               ),
               mainPanel(
                  width=10,
                 fluidRow(
                   column(12, div(DT::dataTableOutput('observable_df'),
                                       style = "font-size: 75%;"))
                 ),
                 fluidRow(
                   column(12, div(DT::dataTableOutput('parameter_df'),
                                 style = "font-size: 75%;"))
                 ),
                 fluidRow(
                   column(12, div(DT::dataTableOutput('measurement_df'),
                                 style = "font-size: 75%;"))

                 ),
                 fluidRow(
                   column(12, div(DT::dataTableOutput('condition_df'),
                                 style = "font-size: 75%;"))
                 )
               )
             )
    ),
    tabPanel("Visualisation", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 h1('A Server-side Table')
                 ),
               mainPanel(
                 fluidRow(
                   column(9, DT::dataTableOutput('x3')),
                   column(3, verbatimTextOutput('x4'))
                 )
               )
             )
    )
  )
)

