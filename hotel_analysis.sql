-- create a temporary table called "revenue" to include all tables
-- append the three revenue tables (2018, 2019 and 2020) using UNION

CREATE TEMPORARY TABLE revenue (	
SELECT * FROM revenue_2018 
UNION 
SELECT * FROM revenue_2019 
UNION 
SELECT * FROM revenue_2020);


-- collect the data to analyze the hotel bookings    

SELECT 						
    hotel AS hotel_type,
    country,
    CONCAT(arrival_date_month, ' ', arrival_date_day_of_month, ', ', arrival_date_year) AS 'date',
    stays_in_week_nights AS weekdays,
    (stays_in_week_nights * adr) AS weekday_rates,      -- calculate the weekday booking rates
    stays_in_weekend_nights AS weekends,
    (stays_in_weekend_nights * adr) AS weekend_rates, 	-- calculate the weekend booking rates
    adr AS rates_per_night		                -- adr = average daily rates
FROM
    revenue		                               	-- this is the temporary table that was created earlier
WHERE 
    country != "0";  	                                -- excluded data with no country information