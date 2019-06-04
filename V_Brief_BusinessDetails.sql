CREATE VIEW Brief_BusinessDetails_V AS 
SELECT p.businessId,p.businessName,c.categoryName 
FROM P_Business p, P_BusinessCategory bc, P_Category c 
WHERE p.businessId=bc.businessId AND bc.categoryId=c.categoryId AND (c.categoryName='Chinese' OR c.categoryName='Italian' OR c.categoryName='Mexican' OR c.categoryName='American'); 

