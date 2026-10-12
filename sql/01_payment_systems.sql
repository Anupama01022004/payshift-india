-- Q1: Is UPI replacing other payment methods, or growing alongside them?
-- Source: npci_monthly (NPCI, Jan-Dec 2024)
-- Method: average daily volume, Q1 vs Q4 (removes month-length effects and single-month noise)

-- Month-over-month growth in daily volume: UPI vs ATM network (NFS)
WITH monthly AS (
    SELECT
        month,
        SUM(CASE WHEN system = 'UPI' THEN avg_daily_volume_mn END) AS upi_daily_mn,
        SUM(CASE WHEN system = 'NFS' THEN avg_daily_volume_mn END) AS atm_daily_mn
    FROM npci_monthly
    GROUP BY month
)
SELECT
    month,
    upi_daily_mn,
    ROUND((upi_daily_mn - LAG(upi_daily_mn) OVER (ORDER BY month)) * 100.0
          / LAG(upi_daily_mn) OVER (ORDER BY month), 1) AS upi_daily_mom_pct,
    atm_daily_mn,
    ROUND((atm_daily_mn - LAG(atm_daily_mn) OVER (ORDER BY month)) * 100.0
          / LAG(atm_daily_mn) OVER (ORDER BY month), 1) AS atm_daily_mom_pct
FROM monthly
ORDER BY month;

-- Q1 vs Q4 growth for every payment system
WITH quarterly AS (
    SELECT
        system,
        CASE
            WHEN CAST(strftime('%m', month) AS INTEGER) <= 3  THEN 'Q1'
            WHEN CAST(strftime('%m', month) AS INTEGER) >= 10 THEN 'Q4'
        END AS quarter,
        avg_daily_volume_mn
    FROM npci_monthly
)
SELECT
    system,
    ROUND(AVG(CASE WHEN quarter = 'Q1' THEN avg_daily_volume_mn END), 2) AS q1_daily_mn,
    ROUND(AVG(CASE WHEN quarter = 'Q4' THEN avg_daily_volume_mn END), 2) AS q4_daily_mn,
    ROUND((AVG(CASE WHEN quarter = 'Q4' THEN avg_daily_volume_mn END)
         - AVG(CASE WHEN quarter = 'Q1' THEN avg_daily_volume_mn END)) * 100.0
         / AVG(CASE WHEN quarter = 'Q1' THEN avg_daily_volume_mn END), 1) AS q1_to_q4_pct
FROM quarterly
GROUP BY system
ORDER BY q1_to_q4_pct DESC;
