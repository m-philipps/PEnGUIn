#source("app/R/utils/libaries.R")

shinyServer(function(input, output, session) {
  # Upload PETAB model ----
  # Create a file chooser dialog
  shinyFileChoose(input,'fileInput', session = session,roots = c(wd="/Users/lea/sciebo/Home/current/projects/PEnGUIn/PEnGUIn_app"))
  
  SBML_model <- reactiveVal()
  Measurement_df <- reactiveVal()
  Condition_df <- reactiveVal()
  Observable_df <- reactiveVal()
  Parameter_df <- reactiveVal()
  
  # Retrieve the selected files
  petab_list <- eventReactive(input$fileInput, {
    inFile <- parseFilePaths(roots=c(wd='..'), input$fileInput)
    # checking if complete PETAB Problem
    # check selected files
    all_Files <- unlist(input$fileInput,use.names = F)
    all_Files <- all_Files[grep("\\.",all_Files)]
    req(inFile$datapath)
    print(inFile$datapath)
    print(all_Files)
    print(getwd())
    # should read out the yaml
    measurement_df <- read.table(
      inFile$datapath[grep("measurement",all_Files,ignore.case = T)],
      header = T,
      sep="\t")
    condition_df <- read.table(
      inFile$datapath[grep("condition",all_Files,ignore.case = T)],
      header = T,
      sep="\t")
    observable_df <- read.table(
      inFile$datapath[grep("observable",all_Files,ignore.case = T)],
      header = T,
      sep="\t")
    parameter_df <- read.table(
      inFile$datapath[grep("parameter",all_Files,ignore.case = T)],
      header = T,fill = T,
      sep="\t")

    smbl_model <- readLines(inFile$datapath[grep(".xml",all_Files,ignore.case = T)])
    smbl_model_string <- paste(smbl_model, collapse = "\n")
    #smbl_model <<- XML::xmlTreeParse(smbl_model)
    #smbl_model <- XML::xmlParse(inFile$datapath[grep(".xml",all_Files,ignore.case = T)])
    
    SBML_model(smbl_model_string)
    Measurement_df(measurement_df)
    Condition_df(condition_df)
    Observable_df(observable_df)
    Parameter_df(parameter_df)
    
    # PETab_df <- list(
    #   measurement_df=measurement_df,
    #   condition_df=condition_df,
    #   observable_df=observable_df,
    #   parameter_df=parameter_df,
    #   SBML=smbl_model_string
    # )
    #smbl_model_string_r <- reactiveValues(values = smbl_model_string)
    # PETab_df
    #load(as.character(inFile$datapath), envir=.GlobalEnv)
  })
  
  # Display the selected files (optional)
  output$selectedFiles=renderPrint({
    all_Files <- unlist(input$fileInput,use.names = F)
    all_Files[grep("\\.",all_Files)]
    })
  
  observe(
    if(!is.null(input$observable_df_rows_selected)){
      # rows in observable_DF selected, Measurement_DF should be highlighted
      toHighlight <- Observable_df()[input$observable_df_rows_selected,"observableId"]
      
      print(toHighlight)
    }
  )
  
  # Condition Table ----
  output$condition_df =  DT::renderDataTable({
    DT::datatable(Condition_df(), 
                  editable = TRUE,
                  filter = 'top',
                  caption =  htmltools::tags$caption(style = 'caption-side: top; text-align: left; color:black;  font-size:200% ;','Condition Table'),
                  extensions = "FixedColumns",
                  options = list(scrollX = TRUE,
                                 fixedColumns = list(leftColumns = 2)))
  },server=T)
  
  # Observable Table ----
  output$observable_df = DT::renderDataTable({
    if(!is.null(input$measurement_df_rows_selected)){
      # rows in observable_DF selected, Measurement_DF should be highlighted
      toHighlight <- Measurement_df()[input$measurement_df_rows_selected,"observableId"]
    }else{
      toHighlight <- "all"
    }
    ifelse(toHighlight=="all",
           idx2select <- c(1:nrow(Observable_df())),
           idx2select <- which(Observable_df()$observableId%in%toHighlight))
    DT::datatable(Observable_df()[idx2select,], 
                  editable = TRUE,
                  caption =  htmltools::tags$caption(style = 'caption-side: top; text-align: left; color:black;  font-size:200% ;','Observable Table'),
                  extensions = "FixedColumns",
                  options = list(scrollX = TRUE,
                                 fixedColumns = list(leftColumns = 2)))
  },server=T)
    
  # Measurement Table ----
  output$measurement_df = DT::renderDataTable({
    if(!is.null(input$observable_df_rows_selected)){
      print(input$observable_df_rows_selected)
      # rows in observable_DF selected, Measurement_DF should be highlighted
      toHighlight <- Observable_df()[input$observable_df_rows_selected,"observableId"]
    }else{
      toHighlight <- "all"
    }

    ifelse(toHighlight=="all",
             idx2select <- c(1:nrow(Measurement_df())),
             idx2select <- which(Measurement_df()$observableId%in%toHighlight))
    DT::datatable(
      Measurement_df()[idx2select,],
      editable = TRUE,
      caption =  htmltools::tags$caption(style = 'caption-side: top; text-align: left; color:black;  font-size:200% ;','Measurement Table'),
      extensions = "FixedColumns",
      options = list(scrollX = TRUE,
                     fixedColumns = list(leftColumns = 2))
      )
    },
    server = T
)
  

  # Parameter Table ----
  output$parameter_df = DT::renderDataTable({
    DT::datatable(Parameter_df(), 
                  editable = TRUE,
                  caption =  htmltools::tags$caption(style = 'caption-side: top; text-align: left; color:black;  font-size:200% ;','Parameter Table'),
                  extensions = "FixedColumns",
                  options = list(scrollX = TRUE,
                                 fixedColumns = list(leftColumns = 2)))
  },server=T)
  
  # SBML model ----
  output$SMBL_model <- renderText({
    petab_list()
    HTML(SBML_model())
  })
  
  output$SMBL_model_2 <- renderUI({
    textAreaInput("SMBL_model_2",
                  label = "You can edit this!",
                  value = HTML(convert_to_antimony(SBML_model())),
                  resize = "none",
                  #cols = 800,
                  width ="100%",
                  height = "500px")
    
  })
  
  observeEvent(input$convert2SBML,{
    SBML_string_converted <- convert_to_sbml(input$SMBL_model_2)
    SBML_model(SBML_string_converted)
  })
  observeEvent(input$local2global,{
    browser()
    global_params <- convert_sbml_str(SBML_model())
    SBML_model(global_params)
  })
  
})
