use sql_project;
SELECT *FROM appdoc;
SELECT *FROM appdoctype_lookup;
SELECT *FROM application;
SELECT *FROM chemtypelookup;
SELECT *FROM doctype_lookup;
SELECT *FROM product;
SELECT *FROM product_tecode;
SELECT *FROM regactiondate;
SELECT *FROM reviewclass_lookup;

# Task 2: Segmentation Analysis Based on Drug MarketingStatus
#--------------------------------------------------------------
# Q1. Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns?
##SOLUTION:
SELECT year(r.ActionDate) AS "YEAR", p.drugname AS "DRUG NAME", p.Dosage AS "DOSAGE",p.Form AS "TYPE",p.ProductMktStatus AS "MRKTG STATUS",
(CASE WHEN p.ProductMktStatus ="1" THEN "MARKETED" 
WHEN p.ProductMktStatus ="2" THEN "WITHDRAWN"
WHEN p.ProductMktStatus ="3" THEN "PENDING"
WHEN p.ProductMktStatus = "4" THEN "PRE-MARKET"
ELSE "NOT DEFINED"END ) AS "SHORT DESCRIPTION",
(CASE WHEN p.ProductMktStatus ="1" THEN "PRODUCT AVAILABLE IN HOSPITALS AND OTHER PHARMACEUTICALS UNITS" 
WHEN p.ProductMktStatus ="2" THEN "PRODUCT WITHDRAWED VOLUNTARLY BY MANUFACTURER DUE TO SAFETY CONCERN OR LACK OF EFFICIENCY"
WHEN p.ProductMktStatus ="3" THEN "PRODUCT YET TO RECIEVE MARKET AUTHORIZATION AND SO NOT AVAILABLE FOR SALE"
WHEN p.ProductMktStatus = "4" THEN "PRODUCT NOT AVAILABE FOR SALES BUT IN THE STAGE OF CLINICAL TRIALS FOR REGULATORY SUBMISSION FOR MARKET LAUNCH"
ELSE "NOT DEFINED"END ) AS "LONG DESCRIPTION"
FROM regactiondate AS r INNER JOIN product AS p
ON (r.ApplNo = p.ApplNo) WHERE r.ActionType = "AP" GROUP BY year(r.ActionDate), p.drugname,p.Dosage,p.Form,p.ProductMktStatus;

#Q2. Calculate the total number of applications for each MarketingStatus year-wise after the year 2010?

##SOLUTION:
SELECT YEAR(r.actiondate) AS "YEAR",p.ProductMktStatus AS "MRKTG STATUS",
(CASE WHEN p.ProductMktStatus ="1" THEN "MARKETED" 
WHEN p.ProductMktStatus ="2" THEN "WITHDRAWN"
WHEN p.ProductMktStatus ="3" THEN "PENDING"
WHEN p.ProductMktStatus = "4" THEN "PRE-MARKET"
ELSE "NOT DEFINED"END ) AS "SHORT DESCRIPTION",count(p.ProductMktStatus) AS "TOTAL NO. OF APPLICATIONS (AFTER 2010)"
FROM regactiondate AS r INNER JOIN product AS p INNER JOIN application AS a
ON (r.ApplNo = p.ApplNo AND a.ApplNo = p.ApplNo ) WHERE (YEAR(r.ActionDate)> '2010')AND (r.ActionType = ("AP"OR "TA")) 
GROUP BY year(r.ActionDate),p.ProductMktStatus ORDER BY year(r.ActionDate),p.ProductMktStatus;

#Q3. Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time?

##SOLUTION:
SELECT YEAR(r.actiondate) AS "YEAR",row_number() OVER (partition by COUNT(p.ProductMktStatus) ORDER BY YEAR(r.ActionDate) DESC)AS RANK1,
 p.ProductMktStatus AS "MRKT STATUS",COUNT(p.ProductMktStatus) AS "COUNT",
(CASE WHEN p.ProductMktStatus ="1" THEN "MARKETED" 
WHEN p.ProductMktStatus ="2" THEN "WITHDRAWN"
WHEN p.ProductMktStatus ="3" THEN "PENDING"
WHEN p.ProductMktStatus = "4" THEN "PRE-MARKET"
ELSE "NOT DEFINED"END ) AS "SHORT DESCRIPTION"
FROM regactiondate AS r INNER JOIN product AS p
ON r.ApplNo = p.ApplNo WHERE (r.ActionType = ("AP"OR "TA")) AND  MAX(COUNT(p.ProductMktStatus))
GROUP BY year(r.ActionDate),p.ProductMktStatus ORDER BY COUNT(p.ApplNo) DESC limit 25 ;

SELECT 
 
