/*
                            
Web Analytics

Introduction: The customer is a manufacturing company that operates in different states.

Business Task: The website manager wants to analyze the website performance amd customer shopping trends for implementing a strategy to increase web traffic 
and improve the customer experience.
                            
*/

-- 1 -- What are the top traffic sources to understand where the bulk of the website sessions are coming from?

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
GROUP BY 1 , 2 , 3
ORDER BY sessions DESC;

-- [Findings] gsearch nonbrand has the highest sessions.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 2 -- What is the traffic source conversion rate of gsearch nonbrand?

SELECT 
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) * 100), 2) AS conv_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand';
        
-- [Findings] conv_rate of gsearch nonbrand is 6.66%

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 3 -- What are the conversion rates of gsearch nonbrand by device type?

SELECT 
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)*100)), 2) AS conv_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.utm_source = 'gsearch'
        AND w.utm_campaign = 'nonbrand'
GROUP BY 1;

-- [Findings] desktop is at 3.73% whereas mobile is at 0.96%

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 4 -- What are the monthly trends of the gsearch sessions and orders?

SELECT 
    YEAR(w.created_at) AS year,
    MONTH(w.created_at) AS month,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)) * 100, 2) AS conv_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at LIKE '2014%'
        AND w.utm_source = 'gsearch'
GROUP BY 1 , 2
ORDER BY 2;

-- [Findings]  There is a growth in the total number of sessions and orders.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 5--  What are the monthly trends of the gsearch sessions and orders this time splitting out nonbrand and brand campaigns separately?

SELECT 
    YEAR(w.created_at) AS year,
    MONTH(w.created_at) AS month,
    COUNT(DISTINCT CASE WHEN w.utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN w.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders,
    COUNT(DISTINCT CASE WHEN w.utm_campaign = 'brand' THEN w.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN w.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_orders
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
   w.created_at LIKE '2014%'
        AND w.utm_source = 'gsearch'
GROUP BY 1 , 2;

-- [Findings]  There is a growth in both sessions and orders for brand and nonbrand.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 6-- What are monthly sessions and orders split by device type? 

SELECT 
    YEAR(w.created_at) AS year,
    MONTH(w.created_at) AS month,
    COUNT(DISTINCT CASE WHEN w.device_type = 'desktop' THEN w.website_session_id ELSE NULL END) AS deskop_sessions,
    COUNT(DISTINCT CASE WHEN w.device_type = 'desktop' THEN o.order_id ELSE NULL END) AS desktop_orders,
    COUNT(DISTINCT CASE WHEN w.device_type = 'mobile' THEN w.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN w.device_type = 'mobile' THEN o.order_id ELSE NULL END) AS mobile_orders
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
     w.created_at LIKE '2014%'
        AND w.utm_source = 'gsearch'
        AND w.utm_campaign = 'nonbrand'
GROUP BY 1 , 2;

-- [Findings]  The number of sessions and orders from desktops is a lot higher than mobiles.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 7 -- What are the total gsearch and bsearch sessions? 

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM
    website_sessions
WHERE
    created_at  LIKE '2014%'
GROUP BY 1,2;

-- [Findings] gsearch sessions are a lot more than bsearch sessions.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 8 -- What is the nonbrand conversion rates from session to order for gsearch and bsearch by device type?

SELECT 
    w.device_type AS deveice_type,
    w.utm_source AS utm_source,
    COUNT(DISTINCT w.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)) * 100), 2) AS conv_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at LIKE '2014%'
        AND utm_campaign = 'nonbrand'
GROUP BY 1 , 2;

-- [Findings] bsearch has the highest cov_rate on desktop and gsearch is highest on mobile.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 9 -- What are the weekly session volume for gsearch and bsearch nonbrand, broken down by device, since November 4th

SELECT 
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS g_desktop_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS b_desktop_sessions,
    ROUND(((COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END)) * 100), 2) AS desktop_conv_rate,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS g_mobile_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS b_mobile_sessions,
    ROUND(((COUNT(DISTINCT CASE WHEN utm_source = 'bsearch'AND device_type = 'mobile' THEN website_session_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END)) * 100), 2) AS mobile_conv_rate
FROM
    website_sessions
WHERE
    created_at BETWEEN '2014-11-01' AND '2014-12-31'
        AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);

-- [Findings] bsearch traffic dropped off a bit and gsearch was down too after Black Friday but bsearch dropped even more.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 10 -- What is the organic search, direct type in, and paid brand search sessions by month , and show those sessions as a % of paid search nonbrand

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand,
    ROUND(((COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)) * 100), 2) AS brand_pct_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct,
    ROUND(((COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)) * 100), 2) AS direct_pct_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) AS organic,
    ROUND(((COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)) * 100), 2) AS organic_pct_nonbrand
FROM
    website_sessions
WHERE
    created_at LIKE '2014%'
GROUP BY 1 , 2;

-- [Findings] The brand, direct, and organic volumes are growing as a percentage of the traffic volume.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 11 -- What is the monthly volume patterns?

SELECT 
    YEAR(w.created_at) AS year,
    MONTH(w.created_at) AS month,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at LIKE '2012%'
GROUP BY 1 , 2;

-- [Findings] Oct , Nov and Dec had the highest number of orders.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 12 -- Analyze the average website session volume by hour of day and by day week to staff appropriately and improve customer experience.

SELECT 
    hr,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 0 THEN website_sessions ELSE NULL END)) AS mon,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 1 THEN website_sessions ELSE NULL END)) AS tue,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 2 THEN website_sessions ELSE NULL END)) AS wed,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 3 THEN website_sessions ELSE NULL END)) AS thu,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 4 THEN website_sessions ELSE NULL END)) AS fri,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 5 THEN website_sessions ELSE NULL END)) AS sat,
    ROUND(AVG(CASE WHEN WEEKDAY(created_date) = 6 THEN website_sessions ELSE NULL END)) AS sun
FROM
    (SELECT 
        DATE(created_at) AS created_date,
            HOUR(created_at) AS hr,
            COUNT(DISTINCT website_session_id) AS website_sessions
    FROM
        website_sessions
    WHERE
        created_at BETWEEN '2013-09-15' AND '2013-11-15'
    GROUP BY 1 , 2) AS sessions
GROUP BY 1
ORDER BY 1;

-- [Findings] The highest average volumes are from 10:00 to 18:00 on weekdays.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 13 -- What are the channels that customers come backt through to compare new vs. repeat sessions by channel?

SELECT 
    CASE
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
        WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_source = 'socialbook' THEN 'paid_social'
    END AS channel_group,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id END) AS new_sessions,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id END) AS repeat_sessions
FROM
    website_sessions
WHERE
    created_at LIKE '2014%'
GROUP BY 1
ORDER BY 3 DESC;

-- [Findings] Customers are coming back for repeat visits mainly through organic search, paid brand and direct type in.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 14 -- Compare conversion rates and revenue per session for repeat sessions vs new sessions.

SELECT 
    CASE
        WHEN w.is_repeat_session = 0 THEN 'new'
        WHEN w.is_repeat_session = 1 THEN 'repeat'
    END AS is_repeat_session,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id), 2) AS conv_rate,
    ROUND((SUM(price_usd) / COUNT(DISTINCT w.website_session_id)), 2) AS rev_per_session
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at LIKE '2014%'
GROUP BY 1;

-- [Findings] The repeat sessions are more likely to convert and produce more revenue per session.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 15 -- What is the overall session and order volume, trended by quarter for the life of the business?

SELECT 
    YEAR(w.created_at) AS year,
    QUARTER(w.created_at) AS quarter,
    COUNT(DISTINCT w.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
GROUP BY 1 , 2;

-- [Findings] Q4 had the highest number of sessions and orders.

-----------------------------------------------------------------------------------------------------------------------------------------------

-- 16 -- What are the most quarterly figures for session to order conversion rate, revenue per order, and revenue per session?

SELECT 
    YEAR(w.created_at) AS year,
    QUARTER(w.created_at) AS quarter,
    ROUND((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)) * 100, 2) AS conv_rate,
    ROUND(SUM(price_usd) / COUNT(DISTINCT o.order_id), 2) AS rev_per_order,
    ROUND(SUM(price_usd) / COUNT(DISTINCT w.website_session_id), 2) AS rev_per_session
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
GROUP BY 1 , 2;

-- [Findings] The conv_rates are gradually increasing.

------------------------------------------------------------------------------------------------------------------------------------------------- 

-- 17 -- What are the quarterly orders and conversion rates for each channel?

SELECT 
    YEAR(w.created_at) AS year,
    QUARTER(w.created_at) AS quarter,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS g_nonbrand,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END)) * 100, 2) AS g_nonbrand_conv_rate,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS b_nonbrand,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END)) * 100, 2) AS b_nonbrand_conv_rate,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand,
    ROUND((COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN w.website_session_id ELSE NULL END)) * 100, 2) AS brand_conv_rate,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN o.order_id ELSE NULL END) AS organic_search,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN o.order_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN w.website_session_id ELSE NULL END)) * 100, 2) AS organic_conv_rate,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN o.order_id ELSE NULL END) AS direct_type_in,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN o.order_id ELSE NULL END) 
		/ COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN w.website_session_id ELSE NULL END)) * 100, 2) AS direct_conv_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
GROUP BY 1 , 2;

-- [Findings] The order number is increasing over each quarter.

------------------------------------------------------------------------------------------------------------------------------------------------- 
-- 18 -- What is the monthly trending total revenue per product?

SELECT 
    YEAR(created_at) AS year,
    QUARTER(created_at) AS quarter,
    SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS ps4_revenue,
    Round(((SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) / SUM(price_usd)) *100), 2) AS ps4_revenue_rate,
    SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) AS xbox_revenue,
    Round(((SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) / SUM(price_usd)) *100), 2) AS xbox_revenue_rate,
    SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) AS nintendo_revenue,
    Round(((SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) / SUM(price_usd)) *100), 2) AS nintendo_revenue_rate,
    SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) AS ps5_revenue,
    Round(((SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) / SUM(price_usd)) *100), 2) AS ps5_revenue_rate,
    SUM(price_usd) AS total_revenue
FROM
    order_items 
GROUP BY 1 , 2;

-- [Findings] PS4 still has the highest revenue although the revenue began to decrease in Q1 2014 at the launch of the PS5 which has an increase in revenue since then.
