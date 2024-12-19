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

#Task 3: Analyzing Products

# Q1. Categorize Products by dosage form and analyze their distribution?
##SOLUTION:
  
SELECT drugname AS"DRUG NAME", TECode AS"TE Code", 
         Dosage AS"DOSAGE",form AS "FORMULATION", activeingred AS "ACTIVE INGREDIENCE"
	FROM product  
        group by drugname,form,TECode,dosage,activeingred;     

 
# Q2. Calculate the total number of approvals for each dosage form and identify the most successful forms?
##SOLUTION:
SELECT p.Form,
dense_rank() OVER (partition by p.Form ORDER BY count(a.ActionType) DESC)AS RANK1,
p.Dosage, count(a.ActionType) AS "NUMBER OF APPROVALS"
FROM application AS a INNER JOIN product AS p
ON (a.ApplNo = p.ApplNo) 
GROUP BY p.Form,p.Dosage ORDER BY COUNT(a.ActionType) DESC;

# Q3. Investigate yearly trends related to successful forms?
##SOLUTION:
SELECT year(r.ActionDate) AS "YEAR",  p.Form AS "FORM",
dense_rank() OVER (partition by p.Form ORDER BY count(a.ActionType) DESC)AS RANK1,
p.Dosage AS"DOSAGE", count(a.ActionType) AS "NUMBER OF APPROVALS"
FROM application AS a INNER JOIN product AS p INNER JOIN regactiondate AS r
ON (a.ApplNo = p.ApplNo) AND (a.ApplNo = r.ApplNo)
GROUP BY YEAR(r.ActionDate),p.Form,p.Dosage ORDER BY COUNT(a.ActionType) DESC;
