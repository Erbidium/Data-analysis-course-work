import pandas as pd
from sqlalchemy.engine import URL
from sqlalchemy import create_engine

connection_string = 'DRIVER={SQL Server};SERVER=LAPTOP-2T0TBBUP\SQLEXPRESS;DATABASE=MoviesDB;Trusted_Connection=yes'
connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})
engine = create_engine(connection_url)
query = "SELECT * FROM moviesAnalysis"
df = pd.read_sql(query, engine)
print(df.head(10).to_string())

df = pd.read_csv('recomendMovies.csv', sep=';', encoding='utf-16')
print(df.head(5))
print(df.info())
