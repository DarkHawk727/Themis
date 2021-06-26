from flask import Flask, request
from transformers import pipeline
from textblob import TextBlob
import requests
import json
import urllib

app = Flask(__name__)

summarizer = pipeline("summarization")

@app.route('/', methods=['POST'])
def do():
    body = request.get_json()
    safe_query = body["query"].split(' ')
    safe_query = '+'.join(safe_query) 
    res = requests.get(f'https://newsdata.io/api/1/news?apikey=pub_42213970ad6b67a6efb40d24a9038c93875&q={safe_query}')

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
            "summary": summary[0]["summary_text"],
            "polarity": blob.sentiment[0],
            "subjectivity": blob.sentiment[1],
        }
    }
    return data


if __name__ == '__main__':
    app.run()
