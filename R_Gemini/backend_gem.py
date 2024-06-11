import os
import dotenv
# Load the API key from a configuration file
dotenv.load_dotenv("gem_key.env")
api_key = os.getenv("GEMINI_API_KEY")

import google.generativeai as genai
genai.configure(api_key=api_key)
gen_model = genai.GenerativeModel('gemini-pro')


def gem_probe(str):
  response = gen_model.generate_content("Rate the level of sincerity in the following story on a scale from 1-10 respond only with a number between 1 and 10:\n"+str)
# output response
  return response.text
