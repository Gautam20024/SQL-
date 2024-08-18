/* TASK 1 
Determine the number of drugs approved each year and provide insights into the yearly trends.

2. Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.

3. Explore approval trends over the years based on sponsors. 

4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
Answers
*/
/*IQ1*/
SELECT 
    YEAR(Actiondate) AS approvalyear,
    COUNT(*) AS Approved
FROM 
      project.regactiondate
GROUP BY 
    approvalyear
ORDER BY 
    approvalyear;
/*IQ2 In Desc order*/
SELECT 
    YEAR(Actiondate) AS approvalyear,
    COUNT(*) AS Approved
FROM 
      project.regactiondate
GROUP BY 
    approvalyear
ORDER BY 
    Approved DESC
    Limit 3;
/*IQ2 In Asc order*/
SELECT 
    YEAR(Actiondate) AS approvalyear,
    COUNT(*) AS Approved
FROM 
      project.regactiondate
GROUP BY 
    approvalyear
ORDER BY 
    Approved ASC
    Limit 3;
/*IQ3 */
SELECT year(Actiondate) AS approvalyear,count(*) As Approved,a.SponsorApplicant
 FROM project.regactiondate r
 INNER Join
 Application a ON r.ApplNo = a.ApplNo
 group by
 SponsorApplicant,
Approvalyear
 Order BY 
 SponsorApplicant,ApprovalYear;
 /*I Q4*/
 SELECT year(Actiondate) AS approvalyear,count(*) As Approved,a.SponsorApplicant,
 rank() over(partition by year(ActionDate) order by count(*) DESC) As Sponsor_Rank
 FROM project.regactiondate r
 INNER Join
 Application a ON r.ApplNo = a.ApplNo
 Where 
 year(ActionDate) between 1939 AND 1960
 group by
 SponsorApplicant,
Approvalyear
 Order BY 
 Sponsor_Rank,ApprovalYear;
SELECT * FROM project;
/* Task 2
Task 2: Segmentation Analysis Based on Drug MarketingStatus

1. Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.

2. Calculate the total number of applications for each MarketingStatus year-wise after the year 2010. 

3. Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.
Answer
*/
/* II Q1*/
SELECT ProductMktStatus, COUNT(*) AS num_products  
FROM project.product
group by
ProductMktStatus
Order by
ProductMktStatus;
/*II  Q2*/
SELECT p.ProductMktStatus,count(*) As Num_products,Year(r.ActionDate) As Year
FROM project.product p
INNER join
regactiondate r ON p.ApplNo = r.ApplNo
Where 
year(r.ActionDate)>2010
group by
    YEAR(r.ActionDate),
        p.ProductMktStatus
order by
    p.ProductMktStatus;
/*II Q3 */
SELECT 
    ProductMktStatus,
    COUNT(*) AS num_applications
FROM 
     project.product 
GROUP BY 
    ProductMktStatus
ORDER BY 
    num_applications DESC
LIMIT 1;

-- Analyze trend over time for the top MarketingStatus
WITH top_marketing_status AS (
    SELECT 
         ProductMktStatus
    FROM 
        project.product
    GROUP BY 
        ProductMktStatus
    ORDER BY 
        COUNT(*) DESC
    LIMIT 1
)
SELECT 
    YEAR(r.Actiondate) AS application_year,
    COUNT(*) AS num_applications
FROM 
    project.product p 
Inner Join
regactiondate r ON p.ApplNo = r.ApplNo
WHERE 
    ProductMktStatus = (SELECT ProductMktStatus FROM top_marketing_status)
GROUP BY 
    YEAR(r.ActionDate)
ORDER BY 
    application_year;
/*Task 3
1. Categorize Products by dosage form and analyze their distribution.

2. Calculate the total number of approvals for each dosage form and identify the most successful forms.

3. Investigate yearly trends related to successful forms. 
Answer
*/
-- Q1
select Form,
count(*) as Numofproducts
from product
group by Form
order by Numofproducts DESC;
 -- Q2
 select p.Dosage,
count(*) as numofapprovals
from product p
join regactiondate r on p.ApplNo = r.ApplNo
where r.ActionType='AP'
group by p.Dosage
order by numofapprovals DESC;
-- Q3
select year(r.ActionDate) as year,
p.Form,
count(*) as NumOfApprovals
from Product p
join regactiondate r on p.ApplNo = r.ApplNo
where r.ActionType = 'AP'
group by year(r.ActionDate), p.Form
order by year, NumOfApprovals DESC;
/* TAsk 4 
1. Analyze drug approvals based on the therapeutic evaluation code (TE_Code).

2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year
*/
-- Answer 1
select p.TECode,
count(*) as NumOfApproval
from product p
join regactiondate r on p.ApplNo = r.ApplNo
where p.TECode = 'AP'
group by p.TECode
order by NumOfApproval DESC;
-- Answer 2
select year(r.ActionDate) as year, 
p.TECode,
count(*) as NumOfApproval,
rank() over(partition by year(r.ActionDate) order by count(*) desc) as Ranks
from product p
join regactiondate r on p.ApplNo = r.ApplNo
where p.TECode = 'AP'
group by year(r.ActionDate), p.TECode
order by Year, Ranks;