-- Export final output to CSV for Tableau visualization
COPY state_scores TO 'output/state_scores.csv' (HEADER, DELIMITER ',');
