from flask import Flask, request
from transformers import pipeline

app = Flask(__name__)

summarizer = pipeline("summarization")

@app.route('/', methods=['POST'])
def do():
    body = request.get_json()
    summary = summarizer(body["text"], max_length=100, min_length=90, do_sample=False)
    data = {
        "data": {
            "summary": summary[0]["summary_text"]
        }
    }
    return data


if __name__ == '__main__':
    app.run()
