--------- RQ1 ---------
--N AFFECTED COMMIT PER SQUID
SELECT rule, COUNT (DISTINCT creation_analysis_key) AS n_affected_commits, COUNT (creation_analysis_key) AS n_instances FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY rule ORDER BY n_instances DESC;
--N AFFECTED COMMIT PER SQUID and CREATION ANALYSES KEY
SELECT rule, creation_analysis_key, COUNT (creation_analysis_key) AS n_instances, type, severity FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY rule, creation_analysis_key ORDER BY n_instances;
--TYPE PER ANALYSES
SELECT creation_analysis_key, type, COUNT (type)  FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY type, creation_analysis_key;
--SEVERITY PER ANALYSES
SELECT creation_analysis_key, severity, COUNT (severity)  FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY severity, creation_analysis_key;
--SQUID PER PROJECT
SELECT project, rule, COUNT (rule) FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY rule;
--TOT AFFECTED COMMIT
SELECT COUNT (DISTINCT creation_analysis_key) tot_affected_commit FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59';
--TOT COMMIT
SELECT COUNT (DISTINCT creation_analysis_key) tot_commit FROM sonar_issues WHERE  creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59';
--INSTANCES PER TYPE
SELECT type, COUNT (type) FROM sonar_issues WHERE rule LIKE '%java:%' AND  creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY type;
--INSTANCES PER SEVERITY
SELECT severity, COUNT (severity) FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY severity;

--------- RQ2 ---------
--DISTRIBUTION OF ISSUES AMONG SEVERITY AND TYPE PER PROJECT
select project, type, severity, count(severity) as count from sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY project, type, severity;
--DISTRIBUTION OF ISSUES AMONG SEVERITY AND TYPE PER COMMIT
select creation_analysis_key, type, severity, count(severity) as count from sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY creation_analysis_key, type, severity;
--COUNT ISSUE PER TYPE
select type, count(type) as count from sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY  type;
--COUNT ISSUE PER SEVERITY
select severity, count(severity) as count from sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-31-12T23:59:59' GROUP BY  severity;

--------- RQ3 ---------
-- ISSUES RAISED BY RULES NEVER FIXED --
SELECT rule, creation_date, close_date,  status,type,severity, issue_key FROM sonar_issues WHERE rule IN (SELECT rule FROM sonar_issues WHERE rule LIKE '%java::%' AND status <> 'RESOLVED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY rule HAVING AVG((JULIANDAY(close_date) - JULIANDAY(creation_date))) IS NULL) AND rule LIKE '%java::%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' AND status <> 'RESOLVED' ORDER BY creation_date;
--COUNT RULES NEVER FIXED
SELECT COUNT(DISTINCT rule) FROM sonar_issues WHERE rule IN (SELECT rule FROM sonar_issues WHERE rule LIKE '%java:%' AND status <> 'RESOLVED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY rule HAVING AVG((JULIANDAY(close_date) - JULIANDAY(creation_date))) IS NULL) AND rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' AND status <> 'RESOLVED' ORDER BY creation_date;
-- COUNT ISSUES NEVER FIXED
SELECT COUNT(rule) FROM sonar_issues WHERE rule IN (SELECT rule FROM sonar_issues WHERE rule LIKE '%java:%' AND status <> 'RESOLVED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY rule HAVING AVG((JULIANDAY(close_date) - JULIANDAY(creation_date))) IS NULL) AND rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' AND status <> 'RESOLVED' ORDER BY creation_date;
-- RULES NEVER FIXED
SELECT rule,type,severity FROM sonar_issues WHERE rule LIKE '%java:%' AND status <> 'RESOLVED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY rule HAVING AVG((JULIANDAY(close_date) - JULIANDAY(creation_date))) IS NULL;
--OPEN ISSUES
SELECT rule, type, severity, issue_key, creation_date  FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'OPEN' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59';
-- OPEN ISSUES PER TYPE
SELECT type, COUNT(type) FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'OPEN' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY type;
-- OPEN ISSUES PER SEVERITY
SELECT severity, COUNT(severity) FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'OPEN' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY severity;
-- TOT. OPEN ISSUES
SELECT COUNT(issue_key) FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'OPEN' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59';
-- RESOLUTION TIME --
SELECT rule,severity,type, (JULIANDAY(close_date) - JULIANDAY(creation_date)) AS fixed_time FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' AND fixed_time IS NOT NULL;
--CLOSED ISSUES
SELECT rule, status, type, severity, issue_key, creation_date  FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'CLOSED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59';
-- CLOSED ISSUES PER TYPE
SELECT type, COUNT(type) FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'CLOSED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY type;
-- CLOSED ISSUES PER SEVERITY
SELECT severity, COUNT(severity) FROM sonar_issues WHERE rule LIKE '%java:%' AND status = 'CLOSED' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY severity;
-- COUNT PER STATUS
SELECT status, count(status) FROM sonar_issues WHERE rule LIKE '%java:%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59' GROUP BY status;
-- TOT ISSUES
SELECT count(issue_key) FROM sonar_issues WHERE rule LIKE '%java::%' AND creation_date BETWEEN '2018-01-01T00:00:00' AND '2021-12-31T23:59:59';