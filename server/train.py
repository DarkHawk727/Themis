import sys
import os
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import Perceptron
from sklearn.pipeline import Pipeline
from sklearn.datasets import load_files
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_digits
from joblib import dump, load

dataset = load_files('data', encoding='latin-1')

docs_train, docs_test, y_train, y_test = train_test_split(
    dataset.data, dataset.target, test_size=0.01)

vectorizer = TfidfVectorizer(ngram_range=(1, 3), analyzer='char',
                             use_idf=False)

clf = Pipeline([
    ('vec', vectorizer),
    ('clf', Perceptron()),
])

clf.fit(docs_train, y_train)
print(clf.score(docs_test, y_test))
dump(clf, 'model.joblib')