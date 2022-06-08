import pandas as pd
import numpy as np
import scipy.stats

import seaborn as sns

from sklearn.metrics.pairwise import cosine_similarity

ratings = pd.read_csv('ratings.csv', sep=';', encoding='utf-8')
ratings['rating'] = ratings['rating'].str.replace(',', '.').astype(float)


movies = pd.read_csv('recomendMovies.csv', sep=';', encoding='utf-16')
movies = movies[['id', 'title', 'genres']]
movies.rename(columns={'id':'movieId'}, inplace=True)

df = pd.merge(ratings, movies, on='movieId', how='inner')

agg_ratings = df.groupby('title').agg(mean_rating=('rating', 'mean'), number_of_ratings=('rating', 'count')).reset_index()
agg_ratings_GT100 = agg_ratings[agg_ratings['number_of_ratings'] > 300]

df_GT100 = pd.merge(df, agg_ratings_GT100[['title']], on='title', how='inner')
print(df_GT100.head())

matrix = df_GT100.pivot_table(index='userId', columns='title', values='rating')

matrix_norm = matrix.subtract(matrix.mean(axis=1), axis='rows')
print(matrix_norm.head())

user_similarity = matrix_norm.T.corr()
user_similarity.head()

