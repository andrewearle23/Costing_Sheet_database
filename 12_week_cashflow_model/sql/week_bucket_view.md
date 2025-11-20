CREATE OR REPLACE VIEW cashflow_weekly AS
SELECT
    deal_no,
    type,
    forecast_date,
    YEARWEEK(forecast_date, 3) AS year_week,
    DATE_SUB(forecast_date, INTERVAL WEEKDAY(forecast_date) DAY) AS week_start,
    WEEK(forecast_date, 3) AS week_num,
    YEAR(forecast_date) AS forecast_year,
    SUM(amount) AS weekly_amount
FROM cashflow_forecast_events
GROUP BY
    deal_no, type, forecast_date;