-- Q2: Which banks dominate credit cards, and where is the opportunity?
-- Source: rbi_bank_cards (RBI, Dec 2024 month-end stock)

-- Top 10 credit card issuers with market share and rank
SELECT
    bank_name,
    bank_category,
    credit_cards,
    ROUND(credit_cards * 100.0 / SUM(credit_cards) OVER (), 2) AS market_share_pct,
    RANK() OVER (ORDER BY credit_cards DESC) AS card_rank
FROM rbi_bank_cards
WHERE month = '2024-12-01'
ORDER BY credit_cards DESC
LIMIT 10;

-- Credit vs debit card share by bank category
SELECT
    bank_category,
    COUNT(*) AS num_banks,
    SUM(credit_cards) AS credit_cards,
    ROUND(SUM(credit_cards) * 100.0 / SUM(SUM(credit_cards)) OVER (), 1) AS credit_share_pct,
    SUM(debit_cards) AS debit_cards,
    ROUND(SUM(debit_cards) * 100.0 / SUM(SUM(debit_cards)) OVER (), 1) AS debit_share_pct
FROM rbi_bank_cards
WHERE month = '2024-12-01'
GROUP BY bank_category
ORDER BY credit_cards DESC;

-- Credit card penetration (credit cards per 100 debit cards), banks with 10 Mn+ debit cards
SELECT
    bank_name,
    bank_category,
    debit_cards,
    credit_cards,
    ROUND(credit_cards * 100.0 / debit_cards, 1) AS cc_per_100_dc
FROM rbi_bank_cards
WHERE month = '2024-12-01'
  AND debit_cards >= 10000000
ORDER BY cc_per_100_dc ASC;

-- Opportunity sizing: extra credit cards if each public sector bank matched SBI's penetration
WITH sbi AS (
    SELECT credit_cards * 1.0 / debit_cards AS benchmark_ratio
    FROM rbi_bank_cards
    WHERE month = '2024-12-01'
      AND bank_name = 'STATE BANK OF INDIA'
)
SELECT
    r.bank_name,
    r.debit_cards,
    r.credit_cards,
    ROUND(r.credit_cards * 100.0 / r.debit_cards, 1) AS cc_per_100_dc,
    ROUND((r.debit_cards * s.benchmark_ratio - r.credit_cards) / 1000000.0, 2) AS extra_cards_mn
FROM rbi_bank_cards AS r
CROSS JOIN sbi AS s
WHERE r.month = '2024-12-01'
  AND r.bank_category = 'Public Sector Banks'
  AND r.bank_name <> 'STATE BANK OF INDIA'
ORDER BY extra_cards_mn DESC;
