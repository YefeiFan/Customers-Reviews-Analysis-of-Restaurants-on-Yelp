--1Find customer by name or category
SELECT businessId, businessName, categoryName
FROM Brief_BusinessDetails_V
WHERE businessName LIKE '%Dragon%' AND categoryName='Chinese';



--2Find out the top rated restaurants/competitors near the customer distance<5 kms
SELECT *
FROM
(SELECT TOP 5 *
FROM
(SELECT businessId, AVG(pp.Average_Rating) AS Avg_Rating, AVG(pp.DISTANCE) AS Distance
FROM
(SELECT *, (111.111 * DEGREES(ACOS(COS(RADIANS(llatitude))*COS(RADIANS(latitude))*COS(RADIANS(llongitude - longitude))+ SIN(RADIANS(llatitude))* SIN(RADIANS(latitude))))) AS DISTANCE
FROM
(SELECT *   
FROM Competitor_Business_Details_V a 
JOIN 
	(SELECT AVG(longitude) AS llongitude, AVG(latitude) AS llatitude
	FROM Competitor_Business_Details_V
	WHERE businessId='FJNzBAHuJbAiQCdhIdPQjA'
	GROUP BY longitude, latitude) d 
ON a.businessId=a.businessId) kk
WHERE kk.businessId=kk.businessId) pp 
GROUP BY businessId) qq
ORDER BY qq.Avg_Rating DESC) ll
WHERE ll.Distance<8;


--3Find reviews of a customer in SQL and categorize customer reviews by Positive (Rating>2.9) and Negative (<2.01) and use the overall score to draw a pie chart
SELECT *, ROUND((CAST(aa.Num_Positive AS DECIMAL(4,2))/(CAST(aa.Num_Positive AS DECIMAL(4,2))+CAST(bb.Num_Negative AS DECIMAL(4,2))))*100, 2) AS Percent_Positive,
ROUND((CAST(bb.Num_Negative AS DECIMAL(4,2))/(CAST(aa.Num_Positive AS DECIMAL(4,2))+CAST(bb.Num_Negative AS DECIMAL(4,2))))*100, 2) AS Percent_Negative  
FROM
(SELECT COUNT(*) AS Num_Positive, businessId
FROM Business_Reviews_Details_V
WHERE businessId='FJNzBAHuJbAiQCdhIdPQjA' AND reviewRating>2.9
GROUP BY businessId) aa
JOIN
(SELECT COUNT(*) AS Num_Negative, businessId
FROM Business_Reviews_Details_V
WHERE businessId='FJNzBAHuJbAiQCdhIdPQjA' AND reviewRating<2.01
GROUP BY businessId) bb
ON aa.businessId=bb.businessId;

---Query for R
SELECT reviewText
FROM Business_Reviews_Details_V
WHERE businessId='FJNzBAHuJbAiQCdhIdPQjA'






--4Build word network of a customer’s competitors to gain actionable insights
--4Compare customer with competitors by sentiment score
SELECT businessId, reviewText
FROM Business_Competitor_Word_V
WHERE categoryName='Chinese'


--5: Insert a new business detail
INSERT INTO P_Business VALUES ('hfhtnryd', 'Healty Foods', 'Near Cafe', '1');


--6: Delete a business from the database
DELETE FROM P_Business WHERE businessId='hfhtnryd';