CREATE VIEW Competitor_Business_Details_V AS
SELECT *
FROM 
(SELECT dd.businessId, dd.businessName,dd.categoryName,dd.reviewText,cc.Average_Rating,dd.reviewRating, dd.longitude, dd.latitude 
 FROM 
	(SELECT p.businessId, p.businessName,c.categoryName,r.reviewText,r.reviewRating, bl.longitude, bl.latitude 
	FROM P_Business p JOIN P_Review r ON p.businessId=r.businessId JOIN P_BusinessCategory bc ON p.businessId=bc.businessId JOIN P_Category c ON c.categoryId=bc.categoryId JOIN P_BusinessLocation bl ON bl.businessId=p.businessId) dd
	JOIN 
	(SELECT CAST(AVG(CAST(reviewRating AS decimal(6,5))) AS DECIMAL(6,5)) AS Average_Rating ,businessId 
	FROM P_Review GROUP BY businessId) cc 
	ON cc.businessId=dd.businessId) kk
WHERE kk.categoryName = 'Chinese' OR kk.categoryName = 'American' OR kk.categoryName = 'Mexican' OR kk.categoryName = 'Italian';
   