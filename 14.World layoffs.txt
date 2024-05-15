

													--SQL Project - Data Cleaning



select * from layoffs$
--create table layoffs_staging like as '('layoffs$')'
-- or
--SELECT *
--INTO layoffs_staging
--FROM layoffs$
--WHERE 1=0;


--insert into layoffs_staging select * from layoffs$

--select * from layoffs_staging

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways



-- 1. Remove Duplicates

--# First let's check for duplicates

select * from layoffs_staging



select company, industry, total_laid_off,date,

   ROW_NUMBER() over (
   
   partition by company, industry, total_laid_off,date
   
   order by company, industry, total_laid_off,date) as row_num

from layoffs_staging 



select * from (



	select company, industry, total_laid_off,date,

	   ROW_NUMBER() over (
   
	   partition by company, industry, total_laid_off,date
   
	   order by company, industry, total_laid_off,date) as row_num

	from layoffs_staging 
) as duplicate

where row_num > 1
------
SELECT 
    *
FROM 
    (
        SELECT 
            *,
            ROW_NUMBER() OVER (
                PARTITION BY company,location,country, industry, total_laid_off, date
                ORDER BY company,location,country, industry, total_laid_off, date
            ) AS row_num
        FROM 
            layoffs_staging
    ) AS duplicate
WHERE 
    row_num > 1;


	--or

with dulpicate_cte as (

SELECT 
            *,
            ROW_NUMBER() OVER (
                PARTITION BY company, industry, total_laid_off, date
                ORDER BY company, industry, total_laid_off, date
            ) AS row_num
        FROM 
            layoffs_staging)

select * from  dulpicate_cte where row_num >1


    

	SELECT *
FROM layoffs_staging
WHERE company = 'Oda'
;



-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate

-- these are our real duplicates 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions
			order by company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE 
	row_num > 1;


	SELECT *
FROM layoffs_staging
WHERE company = 'Casper'





-- these are the ones we want to delete where the row number is > 1 or 2or greater essentially


--WITH DELETE_CTE AS 
--(
--SELECT *
--FROM (
--	SELECT company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions,
--		ROW_NUMBER() OVER (
--			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions
--			order by company, location, industry, total_laid_off,percentage_laid_off,date, stage, country, funds_raised_millions
--			) AS row_num
--	FROM 
--		layoffs_staging
--) duplicates
--WHERE 
--	row_num > 1
--)
--DELETE
--FROM DELETE_CTE
;

-- 2. Standardize Data


select company, trim(company)  from layoffs_staging

--update layoffs_staging set company = trim(company)

select distinct industry from layoffs_staging order by 1

SELECT *
FROM layoffs_staging
WHERE industry like 'Crypto%'

--update layoffs_staging set industry = 'Crypto' 
--WHERE industry like 'Crypto%'

select *  from layoffs_staging



select distinct country from layoffs_staging where country like 'united states%' order by 1 



select distinct country, trim(trailing '.' from country) from layoffs_staging where country like 'united states%' order by 1 

--update layoffs_staging set country = trim(trailing '.' from country) where country like 'united states%'


--SELECT date, STR_TO_DATE(date, '%m/%d/%y') FROM layoffs_staging;

SELECT date, CONVERT(DATE, date, 101) AS converted_date FROM layoffs_staging;

update layoffs_staging set date = CONVERT(DATE, date, 101) 

--alter table layoffs_staging modify column date DATE;

ALTER TABLE layoffs_staging 
ALTER COLUMN date DATE;

-- 3. Look at Null Values


SELECT company, *
FROM layoffs_staging  
WHERE total_laid_off IS NULL and percentage_laid_off = 'Null' 

---- Delete Useless data we can't really use
--DELETE FROM layoffs_staging
--WHERE total_laid_off IS NULL and percentage_laid_off = 'Null' 


-- 4. remove any columns and rows we need to

SELECT company, *
FROM layoffs_staging  
WHERE total_laid_off IS NULL and percentage_laid_off = 'Null' 

select * from layoffs_staging where industry is null or industry = 'null'


--Airbnb
SELECT * 
FROM layoffs_staging where company like '%Airbnb%'

select t1.industry,t2.industry

from layoffs_staging t1

join layoffs_staging t2 

on t1.company = t2.company where t1.industry is null  and t2.industry is not null


UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2 ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') AND t2.industry IS NOT NULL;

