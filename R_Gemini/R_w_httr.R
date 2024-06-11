# setup 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
suppressMessages(library(tidyverse))
library(httr)
#library(httr2)
library(progress)

data <- read_csv('texts.csv',n_max = 5)

# Gemini API key
key <- dotenv::load_dot_env('gem_key.env')
gem_token <- Sys.getenv("GEMINI_API_KEY")

#setting up API probing
model_query <- "gemini-pro:generateContent"
instruct <- "Rate the level of sincerity in the following story on a scale from 1-10 respond only with a number between 1 and 10:\n"
gem_ratings <- c()

pb <- progress_bar$new(total = nrow(data))
pb$tick(0)
for (i in 1:nrow(data)) {
  
  #current prompt
  now_text <- data$text[i]
  prompt <- paste(instruct,now_text,sep='')
  
  #probe using httr
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key=gem_token),
    content_type_json(),
    encode = "json",
    body = list(
      contents = list(
        parts = list(
          list(text = prompt)
        )),
      generationConfig = list(
        temperature = 1,
        maxOutputTokens = 1
      )
    )
  )
  #extract response
  candidates <- content(response)$candidates
  resp_txt <- candidates[[1]]$content$parts[[1]]$text[1]
  #save
  gem_ratings <- c(gem_ratings,resp_txt)
  
  # increment progress bar
  pb$tick()
}

gem_ratings

data$sincere_rt <- gem_ratings
data

