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

#Task 4: Exploring Therapeutic Classes and Approval Trends
#------------------------------------------------------------

#Q1. Analyze drug approvals based on therapeutic evaluation code (TE_Code)?
##SOLUTION: 
	SELECT YEAR(r.ActionDate),pte.TECode,
	r.ActionType,count(r.ApplNo) AS"BASED ON TE_CODE NO. OF APPLICATIONS APPROVED"
	FROM regactiondate AS r INNER JOIN product_tecode AS pte
	ON r.ApplNo = pte.ApplNo 
    GROUP BY YEAR(r.ActionDate),pte.TECode,r.ActionType
	 ORDER BY count(r.ActionType) DESC;
							

#Q2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year?

##SOLUTION:

SELECT YEAR(r.ActionDate) AS "YEAR",
(SELECT distinct TECode FROM product_tecode as a
where 1=(
select count(distinct TECode) from product_tecode as b
where a.TECode >= b.TECode
)) AS"TECode WITH HIGHEST APPROVAL", COUNT(r.ActionType), r.ActionType
FROM regactiondate AS r INNER JOIN product_tecode AS pte
	ON r.ApplNo = pte.ApplNo 
    GROUP BY YEAR(r.ActionDate),pte.TECode,r.ActionType;
    