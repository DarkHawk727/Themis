from flask import Flask, request
from transformers import pipeline
from textblob import TextBlob

app = Flask(__name__)

summarizer = pipeline("summarization")

@app.route('/', methods=['POST'])
def do():
    body = request.get_json()
    summary = summarizer(body["text"], max_length=200, min_length=90, do_sample=False)
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
