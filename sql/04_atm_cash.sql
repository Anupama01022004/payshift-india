-- Q4: Is ATM cash withdrawal declining?
-- Source: rbi_bank_cards (RBI, all ATM withdrawals by debit and credit cards, Jan-Dec 2024)
-- Method: per-day figures to remove month-length effects

WITH monthly AS (
    SELECT
        month,
        SUM(COALESCE(dc_atm_cash_vol, 0) + COALESCE(cc_atm_cash_vol, 0)) AS atm_txns,
        SUM(COALESCE(dc_atm_cash_val_cr, 0) + COALESCE(cc_atm_cash_val_cr, 0)) AS atm_value_cr,
        CAST(strftime('%d', date(month, '+1 month', '-1 day')) AS INTEGER) AS days_in_month
    FROM rbi_bank_cards
    GROUP BY month
)
SELECT
    month,
    days_in_month,
    ROUND(atm_txns / 1000000.0 / days_in_month, 2) AS atm_txns_per_day_mn,
    ROUND(atm_value_cr / days_in_month, 0) AS atm_value_per_day_cr,
    ROUND(atm_value_cr * 10000000.0 / atm_txns, 0) AS avg_withdrawal_rs
FROM monthly
ORDER BY month;
