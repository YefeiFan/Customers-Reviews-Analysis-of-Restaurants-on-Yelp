----Category
ALTER TABLE P_Category
ALTER COLUMN categoryId CHAR (5) NOT NULL;

ALTER TABLE P_Category
ALTER COLUMN categoryName VARCHAR(50);

ALTER TABLE P_Category	
ADD CONSTRAINT pk_Category_categoryId PRIMARY KEY (categoryId);







----Business
ALTER TABLE P_Business
ALTER COLUMN businessId VARCHAR(50) NOT NULL;
 
--ALTER TABLE P_Business
--ALTER COLUMN businessName VARCHAR (200);

--ALTER TABLE P_Business
--ALTER COLUMN neighborhood VARCHAR (200);

--ALTER TABLE P_Business
--ALTER COLUMN isOpen INT;

--ALTER TABLE P_Business
--ADD CONSTRAINT isOpen CHECK (isOpen>=0 AND isOpen<=1); 

ALTER TABLE P_Business
ADD CONSTRAINT pk_Business_businessId PRIMARY KEY (businessId);







----BusinessLocation
ALTER TABLE P_BusinessLocation
ALTER COLUMN locationId VARCHAR (50) NOT NULL;

ALTER TABLE P_BusinessLocation
ALTER COLUMN businessId VARCHAR(50) NOT NULL; 


--ALTER TABLE P_BusinessLocation
--ALTER COLUMN latitude NUMERIC (18,15);


--ALTER TABLE P_BusinessLocation
--ALTER COLUMN longitude NUMERIC (18,15);


ALTER TABLE P_BusinessLocation
ALTER COLUMN address VARCHAR (100);


ALTER TABLE P_BusinessLocation
ALTER COLUMN city VARCHAR (80);

ALTER TABLE P_BusinessLocation
ALTER COLUMN state VARCHAR (50);

ALTER TABLE P_BusinessLocation
ALTER COLUMN postalCode VARCHAR (50);

ALTER TABLE P_BusinessLocation
ADD CONSTRAINT pk_BusinessLocation_locationId PRIMARY KEY (locationId);

ALTER TABLE P_BusinessLocation
ADD CONSTRAINT fk_BusinessLocation_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE NO ACTION ON UPDATE CASCADE;






---Business Category
ALTER TABLE P_BusinessCategory
ALTER COLUMN businessId VARCHAR(50) NOT NULL;

ALTER TABLE P_BusinessCategory
ALTER COLUMN categoryId CHAR (5) NOT NULL;

ALTER TABLE P_BusinessCategory
ADD CONSTRAINT pk_BusinessCategory_businessId_categoryId PRIMARY KEY (businessId, categoryId);

ALTER TABLE P_BusinessCategory
ADD CONSTRAINT fk_BusinessCategory_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE NO ACTION ON UPDATE CASCADE;


ALTER TABLE P_BusinessCategory
ADD CONSTRAINT fk_BusinessCategory_categoryId FOREIGN KEY (categoryId)
	REFERENCES P_Category (categoryId)
	ON DELETE NO ACTION ON UPDATE CASCADE;







---Users
ALTER TABLE P_Users
ALTER COLUMN userId VARCHAR(50) NOT NULL;

ALTER TABLE P_Users
ALTER COLUMN userName VARCHAR(100);

ALTER TABLE P_Users
ALTER COLUMN userSince DATE;

ALTER TABLE P_Users
ALTER COLUMN numberofFans INT;

ALTER TABLE P_Users
ADD CONSTRAINT pk_Users_userId PRIMARY KEY (userId);








---Reviews
ALTER TABLE P_Review
ALTER COLUMN userId VARCHAR (50) NOT NULL;

ALTER TABLE P_Review
ALTER COLUMN businessId VARCHAR (50) NOT NULL;

ALTER TABLE P_Review
ALTER COLUMN reviewDate DATE;

--ALTER TABLE P_Review
--ALTER COLUMN reviewText VARCHAR (4000);

ALTER TABLE P_Review
ALTER COLUMN reviewRating INT;

ALTER TABLE P_Review
ALTER COLUMN numberOfUseful INT;
 
ALTER TABLE P_Review
ALTER COLUMN numberOfFunny INT; 

ALTER TABLE P_Review
ALTER COLUMN numberOfCool INT;

ALTER TABLE P_Review
ADD CONSTRAINT pk_Review_userId_businessId PRIMARY KEY (userId, businessId);

ALTER TABLE P_Review
ADD CONSTRAINT fk_Review_userId FOREIGN KEY (userId)
	REFERENCES P_Users (userId)
	ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE P_Review
ADD CONSTRAINT fk_Review_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE NO ACTION ON UPDATE CASCADE;








----Suggestions
ALTER TABLE P_BusinessSuggestion
ALTER COLUMN suggestionId VARCHAR (20) NOT NULL;

ALTER TABLE P_BusinessSuggestion
ALTER COLUMN businessId VARCHAR(50);
 
ALTER TABLE P_BusinessSuggestion
ALTER COLUMN userId VARCHAR(50) NOT NULL;

ALTER TABLE P_BusinessSuggestion
ALTER COLUMN suggestionDate DATE;

--ALTER TABLE P_BusinessSuggestion
--ALTER COLUMN suggestionText VARCHAR (2000);

ALTER TABLE P_BusinessSuggestion
ALTER COLUMN numberOfLikes INT;

ALTER TABLE P_BusinessSuggestion
ADD CONSTRAINT pk_BusinessSuggestion_suggestionId PRIMARY KEY (suggestionId);

ALTER TABLE P_BusinessSuggestion
ADD CONSTRAINT fk_BusinessSuggestion_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE P_BusinessSuggestion
ADD CONSTRAINT fk_BusinessSuggestion_userId FOREIGN KEY (userId)
	REFERENCES P_Users (userId)
	ON DELETE NO ACTION ON UPDATE CASCADE;