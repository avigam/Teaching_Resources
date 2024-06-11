# setup 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
suppressMessages(library(tidyverse))
data <- read_csv('texts.csv',n_max = 5)

# setup reticulate environment
reticulate::use_virtualenv("r-reticulate", required = TRUE)
suppressMessages(library(reticulate))
#make sure python pkgs are installed and updated
virtualenv_install("r-reticulate", packages = c('google-generativeai', 'python-dotenv'),ignore_installed = T)

#Run python script to setup api key & load function for calling gemini
source_python("backend_gem.py")

## probe gemini for ratings
examp <- gem_probe(data$text[1])
examp
gem_ratings <- sapply(data$text
                      ,gem_probe,USE.NAMES = F)
data$sincere_rt <- gem_ratings
data

