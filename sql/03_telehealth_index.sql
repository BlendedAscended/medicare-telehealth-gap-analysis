-- Compute telehealth vulnerability index at the census tract level
CREATE TABLE tele_tract AS
SELECT
  TRACTFIPS,
  STATEFIPS,
  ACS_TOT_POP_WT AS population,
  (1 - ACS_PCT_HH_BROADBAND / 100.0) AS broadband_gap,
  ACS_PCT_HU_NO_VEH / 100.0 AS no_vehicle_pct,
  POS_DIST_CLINIC_TRACT / 30.0 AS dist_norm,
  ROUND(((1 - ACS_PCT_HH_BROADBAND / 100.0) + (ACS_PCT_HU_NO_VEH / 100.0) + (POS_DIST_CLINIC_TRACT / 30.0)) / 3, 3) AS tele_index
FROM sdoh;

-- Aggregate tract-level index to state-level using population-weighted average
CREATE TABLE state_sdo_metrics AS
SELECT
  STATEFIPS,
  SUM(population) AS total_pop,
  ROUND(SUM(population * broadband_gap) / SUM(population), 4) AS avg_bb_gap,
  ROUND(SUM(population * no_vehicle_pct) / SUM(population), 4) AS avg_no_vehicle,
  ROUND(SUM(population * dist_norm) / SUM(population), 4) AS avg_dist_norm,
  ROUND(SUM(population * tele_index) / SUM(population), 4) AS tele_index
FROM tele_tract
WHERE TRY_CAST(STATEFIPS AS INTEGER) BETWEEN 1 AND 56
GROUP BY STATEFIPS;
