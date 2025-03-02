create table netflix
(
  show_id varchar(6),
  type varchar(10),
  title varchar(150),
  director varchar(208),
  casts varchar(1000),
  country varchar(150),
  date_added varchar(50),
  release_year int,
  rating varchar(10),
  duration varchar(15),
  listed_in varchar(100),
  description varchar(250)
  );

  select* from netflix

  select count(*) as total_content
  from netflix

-- 1. count the number of movies vs TV shows
select type,
  count(*) as total_content from netflix
  group by type

  
-- 2. select the most common rating for movies and tv shows.

select type, rating
from (
    select type, rating, count(*),
	rank() over(partition by type order by count(*)desc) as ranking
	from netflix
	group by 1,2
) as T1
 where ranking= 1

-- 3. list all movies released in a specific year (e.g. 2020)

  select * from netflix
  where type= 'Movie'
  and release_year= 2020

--4. find the top 5 countries with the most content on netflix  

select unnest(string_to_array(country, ',')) as new_country,
count(show_id) as total_content
from netflix
group by 1
order by 2 desc 
limit 5

-- 5. identify the longest movie

select * from netflix
where type='Movie'
and
duration=(select max(duration)from netflix)


--6. find content added in the last 5 years

select * from netflix
where to_date(date_added, 'month DD, YYYY')>= current_date - interval '5 years'

--7. find all the movies/tv shows by director 'Rajiv Chilaka'

select * from netflix
where director ILIKE '%Rajiv Chilaka%'

--8. list all tv shows with more than 5 seasons

select * from netflix
where type = 'TV Show'
and split_part (Duration, ' ', 1):: numeric>5

--9. count the number of content items in each genre.

select unnest(string_to_array(listed_in, ',')) as genre,
count(show_id) as total_content
from netflix
group by 1

--10. find each year and the avg no. of content released by India on netflix.
--    return top 5 year with highest avg content released.

select extract (year from to_date(date_added, 'Month DD, YYYY')) as year,
count (*) as yearly_content,
round(
    count(*):: numeric/ (select count(*) from netflix where country='India'):: numeric*100,2)
	as avg_content_per_year
from netflix
where country='India'
group by 1
--11. list all movies that are documentaries

select * from netflix
where listed_in ILIKE '%documentaries%'

--12. find all content without director.

select * from netflix
where director IS NULL

--13. find how many movies actor 'salman khan' appeared in last 10 year
select * from netflix
 where
   casts ILIKE '%Salman Khan%'
 and 
   release_year> extract (year from current_date)- 10

--14. find the top 10 actors who have appeared in the highest no. of movies produced in India.

select Unnest (string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ILIKE '%India%'
group by 1
order by 2 desc
limit 10

--15. categorize the content based on the presence of the keywords 'kill' and 'voilence' in 
--the description feild. label content containing these keywords as 'bad' and all other content as 
--'good'. count how many items fall into each category.

with new_table
as(
   select * , 
   case
   when
       description ILIKE '%kill%' or
	   description ILIKE '%voilence%' then 'Bad content'
	   else 'good content'
	   end category
   from netflix
   )
 select category,
 count(*) as total_content
 from new_table
 group by 1












































































  