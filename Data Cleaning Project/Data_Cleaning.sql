-- Data Cleaning 

select * from layoffs;

-- 1. Remove duplicate
-- 2. Standardize the data
-- 3. Null values or Blank Values
-- 4. Remove any columns

-- create duplicate table 

create table layoffs_Staging
like layoffs;

select * from layoffs_staging;  -- before insertion 

-- insert data into duplicate table

insert layoffs_staging 
select * from layoffs;

select * from layoffs_staging;  -- after insertion

-- 1. Remove duplicate 
--   i. Add row number

select *,
row_number() over ( 
partition by company ,industry, total_laid_off,percentage_laid_off,`date`) as row_num 
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over ( 
partition by company ,industry, total_laid_off,percentage_laid_off,`date`) as row_num 
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;

-- check & show duplicate

select * from layoffs_staging
where company='oda';  -- oda will come 3 times , if we add all column , oda won't come

-- add all column name in partition group

with duplicate_cte as
(
select *,
row_number() over ( 
partition by company ,location,industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;

-- check and display table after all column

select * from layoffs_staging
where company='Casper';

-- delete duplicate (row num >1 )

with duplicate_cte as
(
select *,
row_number() over ( 
partition by company ,location,industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1;  

-- throw error - delete acts as update stmt ( delete is not updatable )
-- create new table from layoffs_staging


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from layoffs_staging2;  -- table only created

-- insert data as per partition

insert into layoffs_staging2
select *,
row_number() over ( 
partition by company ,location,industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from layoffs_staging;

-- display duplicate, row_num > 1

select * 
from layoffs_staging2
where row_num>1;

delete
from layoffs_staging2
where row_num>1;








