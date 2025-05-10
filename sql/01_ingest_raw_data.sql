-- Ingest raw datasets into DuckDB tables
CREATE TABLE sdoh AS SELECT * FROM read_csv_auto('data/raw/sdoh_2020_tract_1_0.csv', header = TRUE);
CREATE TABLE provider_geo AS SELECT * FROM read_csv_auto('data/raw/Medicare_Physician_Other_Practitioners_by_Geography_and_Service_2022.csv', header = TRUE);
CREATE OR REPLACE TABLE provider_serv AS SELECT * FROM read_csv_auto('data/raw/Medicare_Physician_Other_Practitioners_by_Provider_and_Service_2022.csv', header = TRUE);
CREATE TABLE opioid AS SELECT * FROM read_csv_auto('data/raw/Medicare_Part_D_Opioid_Prescribing_Rates_by_Geography_2022.csv', header = TRUE);
CREATE TABLE fips AS SELECT * FROM read_csv_auto('data/raw/state_fips_lookup.csv', header = TRUE);
CREATE OR REPLACE TABLE enrollment AS SELECT * FROM read_csv_auto('data/raw/Medicare_Monthly_Enrollment_Jan_2025.csv', header = TRUE);
CREATE OR REPLACE TABLE nppes_data AS SELECT * FROM read_csv_auto('npidata_pfile_20050523-20250413.csv', delim = ',', quote = '"', header = TRUE);
