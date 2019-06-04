CREATE TABLE P_Category(
categoryId CHAR (5) NOT NULL,
categoryName VARCHAR(12),	
CONSTRAINT pk_Category_categoryId PRIMARY KEY (categoryId)
);

CREATE TABLE P_Business(
businessId VARCHAR(50) NOT NULL, 
businessName VARCHAR (200),
neighborhood VARCHAR (200),
isOpen INT CHECK(isOpen>=0 AND isOpen<=1),
CONSTRAINT pk_Business_businessId PRIMARY KEY (businessId)
);


CREATE TABLE P_Users(
userId VARCHAR(50) NOT NULL,
userName VARCHAR(100),
userSince DATE,
numberofFans INT,
CONSTRAINT pk_Users_userId PRIMARY KEY (userId)
);


CREATE TABLE P_BusinessCategory(
businessId VARCHAR(50) NOT NULL,
categoryId CHAR (5) NOT NULL,
CONSTRAINT pk_BusinessCategory_businessId_categoryId PRIMARY KEY (businessId, categoryId),
CONSTRAINT fk_BusinessCategory_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_BusinessCategory_categoryId FOREIGN KEY (categoryId)
	REFERENCES P_Category (categoryId)
	ON DELETE NO ACTION ON UPDATE CASCADE 
);


CREATE TABLE P_BusinessLocation (
locationId VARCHAR (50) NOT NULL,
businessId VARCHAR(50), 
latitude NUMERIC (18,15), 
longitude NUMERIC (18,15), 
address VARCHAR (100), 
city VARCHAR (80), 
state VARCHAR (4), 
postalCode VARCHAR (15),
CONSTRAINT pk_BusinessLocation_locationId PRIMARY KEY (locationId),
CONSTRAINT fk_BusinessLocation_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE P_BusinessSuggestion (
suggestionId VARCHAR (20) NOT NULL,
businessId VARCHAR(50), 
userId VARCHAR(50) NOT NULL,
suggestionDate DATE,
suggestionText VARCHAR (2000),
numberofLikes INT,
CONSTRAINT pk_BusinessSuggestion_suggestionId PRIMARY KEY (suggestionId),
CONSTRAINT fk_BusinessSuggestion_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_BusinessSuggestion_userId FOREIGN KEY (userId)
	REFERENCES P_Users (userId)
	ON DELETE NO ACTION ON UPDATE CASCADE
);



CREATE TABLE P_Review (
userId VARCHAR (50) NOT NULL,
businessId VARCHAR (50) NOT NULL,
reviewDate DATE,
reviewText VARCHAR (4000),
reviewRating INT,
numberOfUseful INT, 
numberOfFunny INT, 
numberOfCool INT,
CONSTRAINT pk_Review_userId_businessId PRIMARY KEY (userId, businessId),
CONSTRAINT fk_Review_userId FOREIGN KEY (userId)
	REFERENCES P_Users (userId)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_Review_businessId FOREIGN KEY (businessId)
	REFERENCES P_Business (businessId)
	ON DELETE CASCADE ON UPDATE CASCADE
);




DROP TABLE P_Review;
DROP TABLE P_BusinessSuggestion;
DROP TABLE P_BusinessLocation;
DROP TABLE P_BusinessCategory;
DROP TABLE P_Users;
DROP TABLE P_Business;
DROP TABLE P_Category;

