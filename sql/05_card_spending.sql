-- Q5: Is card spending moving online?
-- Source: rbi_bank_cards (RBI, card payment values, Jan-Dec 2024)
-- Note: 'others' channel excluded (small, not clearly in-store or online)

SELECT
    month,
    ROUND(SUM(cc_pos_val_cr), 0) AS cc_instore_cr,
    ROUND(SUM(cc_ecom_val_cr), 0) AS cc_online_cr,
    ROUND(SUM(cc_ecom_val_cr) * 100.0
          / (SUM(cc_pos_val_cr) + SUM(cc_ecom_val_cr)), 1) AS cc_online_share_pct,
    ROUND(SUM(dc_pos_val_cr), 0) AS dc_instore_cr,
    ROUND(SUM(dc_ecom_val_cr), 0) AS dc_online_cr,
    ROUND(SUM(dc_ecom_val_cr) * 100.0
          / (SUM(dc_pos_val_cr) + SUM(dc_ecom_val_cr)), 1) AS dc_online_share_pct
FROM rbi_bank_cards
GROUP BY month
ORDER BY month;
