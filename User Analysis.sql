-- New vs Repeat Channel Patterns

SELECT 
   CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
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
    created_at BETWEEN '2014-01-01' AND '2014-11-05'
GROUP BY 1;

-- New vs Repeat Performance

SELECT 
    w.is_repeat_session,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id), 2) AS conv_rate,
    ROUND((SUM(price_usd) / COUNT(DISTINCT w.website_session_id)), 2) AS rev_per_session
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at BETWEEN '2014-01-01' AND '2014-11-08'
GROUP BY 1;

