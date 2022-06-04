import pandas as pd
from sqlalchemy.engine import URL
from sqlalchemy import create_engine

connection_string = 'DRIVER={SQL Server};SERVER=LAPTOP-2T0TBBUP\SQLEXPRESS;DATABASE=DataAnalysisDB;Trusted_Connection=yes'
connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})
engine = create_engine(connection_url)
query = "SELECT * FROM Ratings"
df = pd.read_sql(query, engine)
print(df.head(10).to_string())
