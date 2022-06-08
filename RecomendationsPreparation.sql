use DataAnalysisDB;


CREATE TABLE recomendMovies
(
id INTEGER, 
title NVARCHAR(MAX), 
genres NVARCHAR(MAX), 
overview NVARCHAR(MAX), 
production_companies NVARCHAR(MAX), 
release_date DATETIME, 
budget FLOAT, 
revenue FLOAT, 
runtime FLOAT, 
);

-- select unique movies which are present in two tables and insert them in new table recomendMovies
WITH
temp AS (SELECT id, 
				title, 
				genres, 
				overview, 
				production_companies, 
				release_date, 
				budget, 
				revenue, 
				runtime, 
				ROW_NUMBER() OVER (PARTITION BY id ORDER BY vote_count DESC) AS RowNumber
         FROM   movies),
movieTable AS (SELECT  id, 
					   title, 
					   genres, 
					   overview, 
					   production_companies, 
					   release_date, 
					   budget, 
					   revenue, 
					   runtime
			   FROM  temp
			   WHERE   temp.RowNumber = 1),
result AS (SELECT links.movieId AS id,
	   movieTable.title, 
	   movieTable.genres, 
	   movieTable.overview, 
	   movieTable.production_companies, 
	   movieTable.release_date, 
	   movieTable.budget, 
	   movieTable.revenue, 
	   movieTable.runtime  
FROM movieTable
INNER JOIN links ON links.tmdbId = movieTable.id
INNER JOIN moviesRecomendations ON moviesRecomendations.movieId = links.movieId)
INSERT INTo recomendMovies
SELECT
id,
REPLACE(title, ';', ','), 
REPLACE(genres, ';', ','), 
REPLACE(overview, ';', ','), 
REPLACE(production_companies, ';', ','), 
release_date, 
budget,
revenue, 
runtime
FROM result;


CREATE  NONCLUSTERED INDEX recomendMoviesNOCLUSTEREDINDEX ON recomendMovies(id);

SELECT * FROM recomendMovies;


-- create table for storing user ratings
create table Ratings (
  userId int,
  movieId int,
  rating float,
  timestamp int
);

CREATE  NONCLUSTERED INDEX ratingsNOCLUSTEREDINDEX ON Ratings(movieId);

BULK INSERT Ratings
FROM 'C:/Users/Acer/Documents/Data analyzis/Course work/ml-25m/ml-25m/ratings.csv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
);

alter table Ratings
drop column [timestamp];

delete from Ratings 
where movieId not in (select id from recomendMovies);

SELECT COUNT(*) FROM Ratings;

SELECT * FROM Ratings;

SELECT *
FROM movies

SELECT * FROM recomendMovies WHERE id=33454