# Instructions

## Python
- make sure that Python is installed
- create a python virtual environment
  ```sh
  python -m venv pyvenv_penguin
  ```
- activate the virtual environment
  ```sh
  source pyvenv_penguin/bin/activate
  ```
  (and later deactivate it with `deactivate`)
- install `tellurium`
  ```sh
  pip install tellurium
  pip install python-libsbml
  ```


## R
- install R according to the internet

- then open R (with active python environment)
  ```{r}
  setwd("PEnGUIn")
  # loads all the packages, if they are already installed
  # If first time you need to install them
  # either with install.packages("[package_name]")
  # for multiple: install.packages(c("[package_name]","[package_name]","[package_name]"))

  source("app/R/utils/libaries.R")

  # to run app
  # make sure you are in PenGUIn directory where the 'app' directory is included
  shiny::runApp('app')

  ```

  
