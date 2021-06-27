from flask import Flask, request, abort
#from transformers import pipeline
from textblob import TextBlob
import requests
import json
import urllib
import textstat

app = Flask(__name__)

#summarizer = pipeline("summarization")

API_URL = "https://api-inference.huggingface.co/models/sshleifer/distilbart-cnn-6-6"
headers = {"Authorization": "Bearer api_GqTqrzryJIMRzQmoDJUNfXREdVyZNvpOyl"}

def query(payload):
	data = json.dumps(payload)
	response = requests.request("POST", API_URL, headers=headers, data=data)
	return json.loads(response.content.decode("utf-8"))

def summarizer(text):
    return query(
        {
            "inputs": text,
            "parameters": {
                'max_length': 75,
                'min_length': 50
            }
        }
    )

@app.route('/', methods=['POST'])
def do():
    body = request.get_json()
    safe_query = body["query"].split(' ')
    safe_query = '+'.join(safe_query) 
    res = requests.get(f'https://newsdata.io/api/1/news?apikey=pub_42213970ad6b67a6efb40d24a9038c93875&q={safe_query}&language=en')
    results = res.json()["results"]
    return getData(results)

@app.route('/today', methods=["GET"])
def todaysHeadlines():
   res = requests.get(f'https://newsdata.io/api/1/news?apikey=pub_42213970ad6b67a6efb40d24a9038c93875&category=health,business&language=en') 
   results = res.json()["results"]
   return getData(results)
    
def getData(results):
    summaries = []
    for result in results:
        text = ""
        if len(summaries) < 4 and result["content"] and result['image_url'] and result['title'] not in [sum['headline'] for sum in summaries]:

            text = result["content"]

            if len(text) > 1024:
                text = text[:1024]

            summary = summarizer(text)#, max_length=200, min_length=90, do_sample=False)
            blob = TextBlob(summary[0]["summary_text"])
            summaries.append({
                "headline": result['title'] or '',
                "image": result['image_url'] or '',
                "source": result['source_id'] or '',
                "summary": summary[0]["summary_text"],
                "polarity": blob.sentiment[0],
                "subjectivity": blob.sentiment[1],
                "reading_level": textstat.flesch_reading_ease(summary[0]["summary_text"]),
                "article_url": result['link']
            })
       
    return {
        "articles": summaries
    }

if __name__ == '__main__':
    app.run()
