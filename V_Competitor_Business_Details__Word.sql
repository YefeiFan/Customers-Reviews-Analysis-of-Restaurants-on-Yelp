
CREATE VIEW Business_Competitor_Word_V AS
SELECT p.businessName,p.businessId, c.categoryName,r.reviewText 
FROM P_Business p JOIN P_Review r ON p.businessId=r.businessId JOIN P_BusinessCategory bc ON p.businessId=bc.businessId JOIN P_Category c ON c.categoryId=bc.categoryId
WHERE c.categoryName = 'Chinese' OR c.categoryName='Mexican' OR c.categoryName='Italian' OR c.categoryName = 'American';