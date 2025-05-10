-- Clean Provider Geo Data
DROP TABLE IF EXISTS prov_geo_clean;
CREATE TABLE prov_geo_clean AS
SELECT
  CAST(Rndrng_Prvdr_Geo_Cd AS INTEGER) AS statefips,
  CAST(REPLACE(Tot_Rndrng_Prvdrs, ',', '') AS DOUBLE) AS total_providers,
  CAST(REPLACE(Tot_Benes, ',', '') AS DOUBLE) AS total_beneficiaries
FROM provider_geo
WHERE
  TRY_CAST(Rndrng_Prvdr_Geo_Cd AS INTEGER) BETWEEN 1 AND 56 AND
  REPLACE(Tot_Rndrng_Prvdrs, ',', '') <> '' AND
  REPLACE(Tot_Benes, ',', '') <> '';

-- Clean Opioid Prescribing Data
CREATE OR REPLACE TABLE opioid_geo_clean AS
SELECT
  CAST(Prscrbr_Geo_Cd AS INTEGER) AS statefips,
  ROUND(CAST(REPLACE(REPLACE(Opioid_Prscrbng_Rate, '%', ''), ',', '') AS DOUBLE), 2) AS opioid_rate
FROM opioid
WHERE
  Breakout_Type = 'Totals' AND
  TRY_CAST(Prscrbr_Geo_Cd AS INTEGER) BETWEEN 1 AND 56 AND
  REPLACE(REPLACE(Opioid_Prscrbng_Rate, '%', ''), ',', '') <> '';
