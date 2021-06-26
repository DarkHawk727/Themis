from flask import Flask, request
from transformers import pipeline
from textblob import TextBlob
import requests
import json
import urllib
import textstat

app = Flask(__name__)

summarizer = pipeline("summarization")

@app.route('/', methods=['POST'])
def do():
    body = request.get_json()
    safe_query = body["query"].split(' ')
    safe_query = '+'.join(safe_query) 
    res = requests.get(f'https://newsdata.io/api/1/news?apikey=pub_42213970ad6b67a6efb40d24a9038c93875&q={safe_query}&language=en')

    text = "" 
    if not res.json()["results"][0]["content"]:
        text += res.json()["results"][0]["description"]
    else:
        text += res.json()["results"][0]["content"]

    if len(text) > 1024:
        text = text[:1024]

    summary = summarizer(text, max_length=200, min_length=90, do_sample=False)
    blob = TextBlob(summary[0]["summary_text"])
    data = {
        "data": {
            "headline": res.json()["results"][0]['title'] or '',
            "image": res.json()["results"][0]['image_url'] or '',
            "source": res.json()["results"][0]['source_id'] or '',
            "summary": summary[0]["summary_text"],
            "polarity": blob.sentiment[0],
            "subjectivity": blob.sentiment[1],
            "reading_level": textstat.flesch_reading_ease(summary[0]["summary_text"])
        }
    }
    return data

@app.route('/today', methods=["GET"])
def todaysHeadlines():
   res = requests.get(f'https://newsdata.io/api/1/news?apikey=pub_42213970ad6b67a6efb40d24a9038c93875&category=health,business&language=en') 
   summaries = []
   results = res.json()["results"]

   for result in results:
       text = ""
       print(result)
       if not result["content"] and not result["description"]:
           continue
       elif not result["content"]:
           text += result["description"]
       elif not result["description"]:
           text += result["content"]

       if len(text) > 1024:
           text = text[:1024]

       summary = summarizer(result["description"], max_length=200, min_length=90, do_sample=False)
       blob = TextBlob(summary[0]["summary_text"])
       summaries.append({
           "headline": result['title'] or '',
           "image": result['image_url'] or '',
           "source": result['source_id'] or '',
           "summary": summary[0]["summary_text"],
           "polarity": blob.sentiment[0],
           "subjectivity": blob.sentiment[1],
           "reading_level": textstat.flesch_reading_ease(summary[0]["summary_text"]) 
       })
       
   return {
       "summaries": summaries
   }

if __name__ == '__main__':
    app.run()
