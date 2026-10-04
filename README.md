# PayShift India

**Tracking India's shift from cash and cards to UPI** using official RBI and NPCI data.

## Business Questions
1. Is UPI replacing cards and cash, or growing alongside them?
2. Which banks are growing their credit card base fastest?
3. How do public, private and foreign banks compare on digital infrastructure?
4. Is ATM cash withdrawal declining as UPI grows?
5. Is card spending moving from in-store (PoS) to online (e-commerce)?

## Data Sources
- **RBI** – Bank-wise ATM/POS/Card Statistics (monthly)
- **NPCI** – Monthly product statistics for UPI, IMPS, NFS (ATM network), CTS and more (via Kaggle)

## Tools
Python (pandas) · SQL · Power BI

## Project Structure
- `data/raw/` – original downloaded files, untouched
- `data/processed/` – cleaned datasets
- `notebook/` – data cleaning and analysis
- `sql/` – analysis queries
- `dashboard/` – Power BI file and screenshots

## Key Findings
_To be added._

## Data Notes
- NPCI data (Kaggle) covers January–December 2024, transaction volumes only (no values).
- **CTS and NACH – Debit were excluded:** the source files contain identical monthly volumes for all 12 months, indicating a data error in the dataset.
- AePS – Funds Transfer has a very small base (under 0.05 Mn/month), so its percentage changes are not meaningful.
- RBI data spells Dhanlaxmi Bank two ways across 2024 files; both were standardised to "DHANLAXMI BANK LTD".
- Fincare Small Finance Bank merged into AU Small Finance Bank on 1 April 2024, so it appears only in Jan–Mar 2024, and AU Small Finance Bank's figures from April include Fincare's business (inorganic growth).
