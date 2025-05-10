-- Identify Primary Care Providers using Taxonomy Codes
CREATE TABLE pcp_npi_list AS
SELECT
  "NPI" AS npi,
  "Provider Business Practice Location Address State Name" AS state,
  "Healthcare Provider Taxonomy Code_1" AS taxonomy
FROM nppes_data
WHERE "Healthcare Provider Taxonomy Code_1" IN (
  '207Q00000X', '207R00000X', '207QG0300X',  -- Physicians
  '363LP2300X', '363LA2200X', '363LF0000X', '363AM0700X' -- NPs, PAs
);

-- Match NPI list to service file
CREATE TABLE pcp_lines AS
SELECT DISTINCT
  p.Rndrng_NPI,
  CAST(p.Rndrng_Prvdr_State_FIPS AS INT) AS statefips
FROM provider_serv p
JOIN pcp_npi_list n ON p.Rndrng_NPI = n.npi;

-- Aggregate PCP counts by state
CREATE TABLE pcp_state AS
SELECT statefips,
       COUNT(DISTINCT Rndrng_NPI) AS total_pcp
FROM pcp_lines
GROUP BY statefips;

-- Summarize state-level beneficiary counts
CREATE TABLE enroll AS
SELECT CAST(state_code AS INT) AS statefips,
       SUM(total_enrolled) AS total_beneficiaries
FROM enrollment
WHERE year = 2022
GROUP BY state_code;

-- Final PCP per 10k metric
CREATE TABLE pcp_per_10k AS
SELECT e.statefips,
       p.total_pcp,
       e.total_beneficiaries,
       ROUND(p.total_pcp / NULLIF(e.total_beneficiaries, 0) * 10000, 2) AS pcp_per_10k
FROM enroll e
JOIN pcp_state p USING (statefips)
ORDER BY statefips;
