#  Healthcare Access and Telehealth State Score Analysis

This project analyzes U.S. state-level healthcare accessibility using social determinants of health (SDOH), primary care provider availability, and opioid prescribing patterns. The outcome is a composite **State Score Table** that can be visualized in Tableau to highlight disparities in telehealth readiness and primary care access.

**View the interactive Tableau dashboard here:**  
[**Telehealth Dashboard**](https://public.tableau.com/views/Telehealth-Dashboardexcl_labelsinterpretaions/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

##  Objective

To quantify and visualize state-level disparities in healthcare access by computing:
- **Telehealth Access Risk Index**
- **Primary Care Providers per 10,000 beneficiaries**
- **Opioid Prescription Rate among Medicare Part D enrollees**

---

##  Datasets Used

| Dataset | Description |
|--------|-------------|
| `sdoh_2020_tract_1_0.csv` | Tract-level social determinants of health |
| `Medicare_Monthly_Enrollment_Jan_2025.csv` | State-level Medicare enrollment |
| `Medicare_Physician_Other_Practitioners_by_Geography_and_Service_2022.csv` | Providers by state |
| `Medicare_Physician_Other_Practitioners_by_Provider_and_Service_2022.csv` | Provider-level service data |
| `npidata_pfile_*.csv` | NPI taxonomy and address data |
| `Medicare_Part_D_Opioid_Prescribing_Rates_by_Geography_2022.csv` | Opioid prescribing patterns |
| `state_fips_lookup.csv` | FIPS to state name mapping |

---

##  SQL Pipeline

> Each step is implemented in a separate SQL file (see `/sql/` folder):

1. **Data Ingestion:** Load raw CSVs into DuckDB.
2. **Cleaning:** Strip `%`, commas, handle missing/nulls, cast types.
3. **Telehealth Index:** Composite index using broadband gap, vehicle access, and distance-to-clinic.
4. **PCP Metric:** Filter NPI taxonomy for primary care; calculate per 10k Medicare beneficiaries.
5. **Opioid Rate:** Parse raw strings to extract prescribing rates per state.
6. **Final Join:** Merge all metrics into `state_scores_named` table.
7. **Export:** Save final CSV for Tableau dashboarding.

---

##  Key Metrics

### 🩺 Telehealth Index
- **Formula:** Avg of broadband gap %, no-vehicle %, normalized clinic distance
- **Level:** Census tract → Aggregated to state using population-weighted avg

###  PCP per 10,000
- **Source:** Medicare provider + NPI taxonomy
- **Definition:** Unique PCPs per 10,000 Medicare beneficiaries

###  Opioid Prescription Rate
- **Source:** Medicare Part D
- **Definition:** % of beneficiaries prescribed opioids

---

## 📂 Project Structure


---

## Tableau Dashboard

**View the interactive Tableau dashboard here:**  
[**Telehealth Dashboard**](https://public.tableau.com/views/Telehealth-Dashboardexcl_labelsinterpretaions/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

> The dashboard visualizes state-level telehealth barriers, primary care access, and opioid usage.

---

##  Validation Steps

- Verified 51 records (50 states + D.C.)
- Ensured one row per state
- Checked ranges for plausibility (no negative or extreme outliers)
- Spot-matched metrics back to raw values
- Avoided over/under-counting via distinct, filtering, and proper joins

---

##  Challenges & Fixes

- **Issue:** `%` and commas in numeric fields → `REPLACE()` used before `CAST`
- **Issue:** State name mismatches → used FIPS codes as unified key
- **Issue:** Multiple records per state → aggregated early and used `DISTINCT`
- **Fixes documented** within SQL scripts for transparency

---

##  Technologies Used

- **SQL Engine:** DuckDB
- **Visualization:** Tableau Public
- **Environment:** MacBook CLI with DuckDB CLI

---

##  Author

**Sandeep Ghotra**  
Data Analyst

---

##  License

This project is for academic and demonstration purposes. Data used is publicly available from CMS and HHS sources.

