CREATE VIEW Business_Reviews_Details_V AS
SELECT p.businessId, p.businessName, r.reviewText, r.reviewDate,r.reviewRating 
FROM P_Business p JOIN P_Review r ON p.businessId=r.businessId;