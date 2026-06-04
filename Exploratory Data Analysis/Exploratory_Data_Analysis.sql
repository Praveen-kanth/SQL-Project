-- Project: Exploratory data analysis --

-- view table -> after Data cleaning done, 1000 rows return-- 
select * from layoffs_staging2;

-- max and min for those 2 col --
select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

-- check percent col =1, 116 rows return --
select * from layoffs_staging2
where percentage_laid_off =1
order by total_laid_off desc;   -- 2434 total laid(max), funds 1600

-- lly check percent col =1, 116 rows return
select * from layoffs_staging2
where percentage_laid_off =1
order by funds_raised_millions desc;  -- 206 total laid, funds 2400(max)

-- check first and last date --
select min(`date`),max(`date`)
from layoffs_staging2;

-- sum total_laid -> group by company --
-- 2 stands for 2nd col , 1 stands for 1st col--
select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;  -- 1000 rows return

-- sum total_laid -> group by industry --
select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;  -- 31 rows return

-- sum total_laid -> group by country --
select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc; -- 51 rows return

-- sum total_laid -> group by date --
select `date`,sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc; -- 451 rows return

-- -- sum total_laid -> group by year --
select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;  -- 5 rows return

-- sum total_laid -> group by stage --
select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc; -- 17 rows return

-- sum total_laid -> group by direct substr use substring --
select substring(`date`,6,2) as month , sum(total_laid_off)
from layoffs_staging2
group by substring(`date`,6,2); -- 13 rows returns 

-- lly sum total_laid -> group by month use substring as month --
select substring(`date`,6,2) as month , sum(total_laid_off)
from layoffs_staging2
group by month;  -- 13 rows returns 

-- lly sum total_laid -> group by month use substring --
select substring(`date`,1,9) as month , sum(total_laid_off)
from layoffs_staging2
group by month;  -- 104 rows returns 

-- sum total_laid -> group by month use substring and order by desc--
select substring(`date`,1,7) as month , sum(total_laid_off)
from layoffs_staging2
group by substring(`date`,1,7)
order by 1 asc;  -- 37 rows returns 

-- sum total_laid -> group by month use substring and order by desc and date is not null --
select substring(`date`,1,7) as month , sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 asc;  -- 36 rows returns 

-- total laid as total off -> sum of total off by month and year as rolling table --
with Rolling_table as 
(
select substring(`date`,1,7) as month , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 asc
)
select month,total_off,sum(total_off) over (order by month) as rolling_table
from Rolling_table; -- 36 rows returns

-- sum of total_laid -> group by company and year
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
order by company asc; -- 1000 rows return

-- lly above -> order by 3 ( sum of total_laid )
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

-- company,years,total_laid_off as above output
with Company_Year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
)
select * from Company_Year;  -- 1832 rows return
-- company and year -> 1000, but all ( company,years,total_laid_off ) -> 1832

-- lly above data (o/p) -> partition by years and order by total_laid ( how many batch of year - 203)
with Company_Year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
) 
select *,dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
order by Ranking asc; -- 1831 rows returns



with Company_Year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
), company_year_rank as
(
select *,dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
order by Ranking asc
)
select * from company_year_rank;



with Company_Year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
), company_year_rank as
(
select *,dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
order by Ranking asc
)
select * from company_year_rank
where Ranking<=5;