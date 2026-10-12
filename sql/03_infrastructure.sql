-- Q3: Are banks building UPI acceptance faster than card acceptance?
-- Source: rbi_bank_cards (RBI, Jan vs Dec 2024 month-end stock)

-- UPI QR codes vs PoS terminals by bank category, with an All banks total
WITH snap AS (
    SELECT
        bank_category,
        SUM(CASE WHEN month = '2024-01-01' THEN pos_terminals END) AS pos_jan,
        SUM(CASE WHEN month = '2024-12-01' THEN pos_terminals END) AS pos_dec,
        SUM(CASE WHEN month = '2024-01-01' THEN upi_qr END) AS qr_jan,
        SUM(CASE WHEN month = '2024-12-01' THEN upi_qr END) AS qr_dec
    FROM rbi_bank_cards
    WHERE month IN ('2024-01-01', '2024-12-01')
    GROUP BY bank_category
),
with_total AS (
    SELECT * FROM snap
    UNION ALL
    SELECT 'All banks', SUM(pos_jan), SUM(pos_dec), SUM(qr_jan), SUM(qr_dec)
    FROM snap
)
SELECT
    bank_category,
    pos_jan,
    pos_dec,
    ROUND((pos_dec - pos_jan) * 100.0 / NULLIF(pos_jan, 0), 1) AS pos_growth_pct,
    qr_jan,
    qr_dec,
    ROUND((qr_dec - qr_jan) * 100.0 / NULLIF(qr_jan, 0), 1) AS qr_growth_pct,
    ROUND(qr_dec * 1.0 / NULLIF(pos_dec, 0), 0) AS qr_per_pos_dec
FROM with_total
ORDER BY qr_dec DESC;

-- Banks with the largest change in UPI QR codes (up or down)
WITH snap AS (
    SELECT
        bank_name,
        bank_category,
        SUM(CASE WHEN month = '2024-01-01' THEN upi_qr END) AS qr_jan,
        SUM(CASE WHEN month = '2024-12-01' THEN upi_qr END) AS qr_dec,
        SUM(CASE WHEN month = '2024-01-01' THEN pos_terminals END) AS pos_jan,
        SUM(CASE WHEN month = '2024-12-01' THEN pos_terminals END) AS pos_dec
    FROM rbi_bank_cards
    WHERE month IN ('2024-01-01', '2024-12-01')
    GROUP BY bank_name, bank_category
)
SELECT
    bank_name,
    bank_category,
    qr_jan,
    qr_dec,
    COALESCE(qr_dec, 0) - COALESCE(qr_jan, 0) AS qr_change,
    pos_jan,
    pos_dec,
    COALESCE(pos_dec, 0) - COALESCE(pos_jan, 0) AS pos_change
FROM snap
ORDER BY ABS(COALESCE(qr_dec, 0) - COALESCE(qr_jan, 0)) DESC
LIMIT 10;
