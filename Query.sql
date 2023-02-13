use Project
-- joining the data from the tables in one called hotels

CREATE VIEW hotels AS(
SELECT * FROM dbo.[2018_data]
UNION 
SELECT * from dbo.[2019_data]
UNION
SELECT * from dbo.[2020_data])

SELECT * from hotels 
left join dbo.market_segment on hotels.market_segment=market_segment.market_segment
left join dbo.meal_cost on hotels.meal=meal_cost.meal;



-- checking the top 5 busiest months of the year 
SELECT hotel,arrival_date_month,guest_count FROM (SELECT hotel,arrival_date_month, COUNT(*) AS guest_count, ROW_NUMBER() OVER (PARTITION BY hotel ORDER BY COUNT(*) DESC) as rnk
FROM hotels GROUP BY hotel,arrival_date_month) x where rnk<=5;



-- checking countries with most customers
SELECT hotel,country,guest_count FROM (SELECT hotel,country, COUNT(*) AS guest_count, ROW_NUMBER() OVER (PARTITION BY hotel ORDER BY COUNT(*) DESC) as rnk
FROM hotels GROUP BY hotel,country) x where rnk<=3;



-- checking the total revenue yearly
SELECT arrival_date_year, hotel,
round(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),2) as revenue
FROM hotels GROUP BY arrival_date_year,hotel;


-- percentage of customers with parking requirement
SELECT ROUND(((SELECT COUNT(*) FROM hotels WHERE required_car_parking_spaces<>0)/
((SELECT COUNT(*) FROM hotels)*1.0)*100),2) AS parking_percent;


-- checking for the top agents who brought maximum number of guests

SELECT hotel,agent,guest_count FROM (SELECT hotel,agent, COUNT(*) AS guest_count, ROW_NUMBER()OVER (PARTITION BY hotel ORDER BY COUNT(*) DESC) as rnk 
FROM hotels WHERE agent IS NOT NULL GROUP BY hotel, agent) x where rnk=1;

select * from hotels where reservation_status_date='2018-12-20';


