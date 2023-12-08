# Instructions
- install R according to the internet

- then open R
  ```{r}
  setwd("PEnGUIn/PEnGUIn_app")
  # loads all the packages, if they are already installed
  # If first time you need to install them
  # either with install.packages("[package_name]")

  source("R/utils/libaries.R")

  # to run app
  # make sure you are in PenGUIn directory where the 'app' directory is included
  shiny::runApp('app')

  ```

  
