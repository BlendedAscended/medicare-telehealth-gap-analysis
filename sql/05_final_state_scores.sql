-- Join all cleaned metrics into a unified state_scores table
CREATE TABLE state_scores AS
SELECT
  s.STATEFIPS,
  s.total_pop,
  s.tele_index,
  s.avg_bb_gap,
  s.avg_no_vehicle,
  s.avg_dist_norm,
  ROUND(p.total_providers / NULLIF(p.total_beneficiaries, 0) * 10000, 2) AS pcp_per_10k,
  ROUND(o.opioid_rate, 2) AS opioid_pct
FROM state_sdo_metrics s
LEFT JOIN prov_geo_clean p ON s.STATEFIPS = p.STATEFIPS
LEFT JOIN opioid_geo_clean o ON s.STATEFIPS = o.STATEFIPS;

-- Optional: Add readable state names
CREATE TABLE state_scores_named AS
SELECT
  s.STATEFIPS,
  f.State AS state_name,
  s.total_pop,
  s.tele_index,
  s.avg_bb_gap,
  s.avg_no_vehicle,
  s.avg_dist_norm,
  ROUND(
    CAST(REPLACE(p.Tot_Rndrng_Prvdrs, ',', '') AS DOUBLE) / 
    NULLIF(CAST(REPLACE(p.Tot_Benes, ',', '') AS DOUBLE), 0) * 10000, 2
  ) AS pcp_per_10k,
  ROUND(CAST(REPLACE(REPLACE(o.Opioid_Prscrbng_Rate, '%', ''), ',', '') AS DOUBLE), 2) AS opioid_pct
FROM state_sdo_metrics s
LEFT JOIN prov_geo_clean p ON CAST(s.STATEFIPS AS INTEGER) = CAST(p.Rndrng_Prvdr_Geo_Cd AS INTEGER)
LEFT JOIN opioid_geo_clean o ON CAST(s.STATEFIPS AS INTEGER) = CAST(o.Prscrbr_Geo_Cd AS INTEGER)
LEFT JOIN state_fips_lookup f ON CAST(s.STATEFIPS AS INTEGER) = CAST(f.STATEFIPS AS INTEGER);
