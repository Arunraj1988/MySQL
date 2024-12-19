use sql_project;
SELECT *FROM appdoc;
SELECT *FROM appdoctype_lookup;
SELECT *FROM application;
SELECT *FROM chemtypelookup;
SELECT *FROM doctype_lookup;
SELECT *FROM product;
SELECT *FROM product_tecode;
SELECT * FROM regactiondate;
SELECT *FROM reviewclass_lookup;

##  Task 1: Identifying Approval Trends   ##

#Q1. Determine the number of drugs approved each year and provide insights into the yearly trends?
##SOLUTION:
WITH Form AS (SELECT p.Form,Substr(p.Form,1,Instr(p.Form,';'))AS "FORM",
						Substr(p.Form,Instr(p.Form,''))AS "TYPE" from product) 
SELECT  year(r.ActionDate) AS "YEAR",a.ApplType AS "APPLICATION TYPE",
(CASE WHEN a.ApplType = "N" THEN "NEW DRUG APPLICATION (NDA)" 
WHEN a.ApplType = "A" THEN "ABBREVATIVE NEW DRUG APPLICATION (ANDA)" 
WHEN a.ApplType = "B" THEN "BIOLOGICAL LICENSE APPLICATION (BLA)" ELSE "NOT APPLICABLE" END) AS "DESCRIPTION", 
a.ActionType AS "Action Type: 'AP' MEANS APPROVED",p.FORM 
FROM regactiondate AS r INNER JOIN application AS a INNER JOIN product  AS p
ON (r.ApplNo = a.ApplNo AND a.ApplNo = p.ApplNo) 
WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.ApplType,a.ActionType,p.Form;



#Q2.a Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively?
### SOLUTION
#ASCENDING ORDER#
SELECT  year(r.ActionDate) AS "YEAR",count(a.ActionType) AS "COUNT OF APPROVED DRUGS" 
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.ActionType ORDER BY COUNT(a.ActionType);

#DESCENDING ORDER
SELECT  year(r.ActionDate) AS "YEAR",count(a.ActionType) AS "COUNT OF APPROVED DRUGS" 
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.ActionType ORDER BY COUNT(a.ActionType) DESC;

#LEAST 3 YEAR
SELECT  year(r.ActionDate) AS "YEAR",count(a.ActionType) AS "COUNT OF APPROVED DRUGS" 
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.ActionType ORDER BY COUNT(a.ActionType) LIMIT 10;

#TOP 5 YEAR
SELECT  year(r.ActionDate) AS "YEAR",count(a.ActionType) AS "COUNT OF APPROVED DRUGS" 
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.ActionType 
ORDER BY COUNT(a.ActionType) DESC LIMIT 4;


#Q3. Explore approval trends over the years based on sponsors ?
##SOLUTION

SELECT  year(r.ActionDate) AS "YEAR",a.SponsorApplicant AS " LIST OF SPONSORS",a.ApplType AS "APPLICATION TYPE",
(CASE WHEN a.ApplType = "N" THEN "NEW DRUG APPLICATION (NDA)" 
WHEN a.ApplType = "A" THEN "ABBREVATIVE NEW DRUG APPLICATION (ANDA)" 
WHEN a.ApplType = "B" THEN "BIOLOGICAL LICENSE APPLICATION (BLA)" ELSE "NOT APPLICABLE" END) AS "DESCRIPTION",
a.ActionType,count(a.ActionType) AS "TOTAL DRUGS APPROVED" 
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE a.ActionType = "AP" GROUP BY year(r.ActionDate),a.SponsorApplicant,a.ApplType;
 
 
  #Q4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960?
##SOLUTION:
SELECT YEAR(r.ActionDate) AS "YEAR",a.SponsorApplicant AS "LIST OF SPONSORS",count(a.ActionType)AS "COUNT OF TOTAL APPROVAL YEARWISE 1939 TO 1960",
row_number() OVER (partition by YEAR(r.ActionDate) ORDER BY count(a.ActionType) DESC)AS RANK1
FROM regactiondate AS r INNER JOIN application AS a 
ON r.ApplNo = a.ApplNo WHERE year(r.ActionDate) between '1939' and '1960'AND a.ActionType = "AP"
 GROUP BY YEAR(r.ActionDate),a.SponsorApplicant;

