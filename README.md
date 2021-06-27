# Themis 

## 💡 Inspiration
Our inspiration to make Themis stems from our belief to lower the access barrier to news and make it more accessible and easier to digest while reducing the bias and subjectivity that comes with it. The first issue we wanted to tackle was fake news. We wanted to decrease fake news by putting only the facts on the table. [Statistics](https://www.statista.com/topics/3251/fake-news/) show that almost 80 percent of consumers in the United States reported having seen fake news on the coronavirus outbreak, highlighting the extent of the issue and the reach fake news can achieve. Moreover, [about one in five Americans say they get their political news primarily through social media.](https://www.journalism.org/2020/07/30/americans-who-mainly-get-their-news-on-social-media-are-less-engaged-less-knowledgeable/) This shows how the news you receive goes through all sorts of middle men, thus influencing your opinions and hence, your actions. Another issue we stumbled upon was of [paid news](https://en.wikipedia.org/wiki/Paid_news_in_India). How would someone know if their news has been paid for or not? This can directly have an impact on your views about current affairs. To solve these problems, we came up with Themis. So you get news not views.

## 📱 What it does
Themis provides you with the latest news on current affairs with reduced bias and subjectivity while preserving the facts and facets of the topic. The way we accomplish that is by summarising articles using our machine learning model, BERT Language Model. Once the article is summarised with all the opinions filtered out, we give you the chunk of news. Themis stands for awareness and information, so we also provide key metrics like subjectivity, reading level, political standing etc. for the summarised news piece. This allows you to analyse and know the news you read.

## 🛠 How we built it

- **Adobe XD**: We used Adobe XD to build the mockups for our mobile app. We wireframed the entire application and used tested a lot of fonts as well in Adobe XD.

- **Flask**: Flask was used for the backend web server, to serve the machine learning model and query the news api.

- **Newsdata.io**: To get news from various sources we used the api provided by [Newsdata.io](https://newsdata.io/). Finding the right api was difficult due to the issues which came with the apis. Newsdata provided querying, pagination and language selection which were imperative for our app.

- **BERT**: We used a BERT-based model from HuggingFace transformers. Our ML pipeline was based on PyTorch and the data used to train the model was [CNN / Daily Mail dataset](https://huggingface.co/datasets/cnn_dailymail) which consists of long articles making it the perfect dataset to use.

- **Sklearn**: We used sklearn to train our own neural network which used TF-IDF to vectorise the input. We then exported the model to joblib so we could use it in the api.

- **TextBlob**: Textblob helped in calculating various other metrics like the sentiment of the summarised article, polarity, and subjectivity.

- **Flutter**: Our mobile app is made using Flutter which means that our mobile app is cross-platform. Flutter made making the mobile app easy and quick.

- **Google Images**: We query google images to get images for articles which did not previously have images. This helped in maintaining accessibility and consistency which lead to great user experience.

## 🛑 Challenges we ran into

- To improve user experience we had to add a feature to scrape Google Images in the case where the news API did not return an associated image.

- We had to build and train our own Bias-Detection Model as there was no preexisting technology available.

- Optimizing the API for a blazing fast user experience.

- Finding the perfect balance of information to clutter.

## ✅ Accomplishments that we're proud of

- We are proud of using NLP (sentiment analysis) to calculate the polarity and subjectivity of the summarised article.

- We custom trained a neural network on a Macbook Pro M1 for calculating the political standing of the summarised article in terms of left and right of the political spectrum.

- Building a mobile app with a nice UI and comfortable UX along with creating a custom bottom sheet which was quite new for us.

## 📖 What we learned

- Making advanced flutter apps that leverage multipl APIs.

- We learned to use sklearn to train a neural network for classifying text on the political spectrum.

- Using HuggingFace transformer pipelines to summarise the article and remove a lot of unnecessary tokens.

- Making HTTP requests to our internal API.

## 🤔 What's next for Themis
In the future, we would like to improve the user experience and work on increasing the performance of the model so it takes less time in summarising the articles. We may also add more metrics for the users to analyse our summary and gain more insights. Adding a way for us to fact check claims would aid in filtering out false claims. We would also like to add animations and illustrations to the app to improve the overall experience for our users.

## 🙇‍♂️ Aknowledgements
We would like to thank TeenHacks, Google, HuggingFace, 
