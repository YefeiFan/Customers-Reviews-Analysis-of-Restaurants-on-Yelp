# Customers-Reviews-Analysis-of-Restaurants-on-Yelp

Yefei Fan, Spencer Glass, Tariq Haque, Liya Zhang

Kehu is an application that takes unique user-generated restaurant reviews and processes them with SQL and RShiny to gain insights on overall trends in the reviews. It uses real-world Yelp reviews as its data source. The brand name is derived from Chinese words 客户获取 (Kèhù huòqǔ) meaning customer acquisition.

## Our mission statement:

“to leverage user-generated data to develop analytical solutions that will allow clients to improve sales effectiveness”

Kehu provides business intelligence tool to sales force to help them engage effectively with their customer during sales calls. To achieve this, Kehu allows a restaurant (a customer that has sought consulting services about their reviews) to sort and view analyzed reviews by many categories. Kehu also uses a sentiment analysis package to quantify sentiment trends in reviews. Kehu can also identify a business’ competitors by their similar attributes and then compare them via metrics like overall star ratings and sentiment ratings.

## DATA SOURCE

Yelp provides the data for open challenges however the data was in NDJSON format. We used jsonlite package of R to parse data and store into csv formats. The code for parsing and storing as csv file is also included with the suite.

## DATABASE DESIGN

Since the on-premise server space provided by the business school was behind firewall, we used public cloud offered by amazon web services to host our data.  AWS gave us choice to enable database access to any inbound traffic.

 

 The database can be accessed using the details as follows from the Microsoft Management Studio 2012:

 	Server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com; 1433
Database=Group_Project_BUDT758Y
UID=thaque786
PASSWRD=tariq214H



For data insertion on database, we have used csv files to upload the document on server and then used alter table to set primary and foreign keys. The following screen shot provided the required details. We have included the .SQL file for alter table with the suite.

 


## FINAL PRODUCT

Kehu is hosted online, at https://kehu2050.shinyapps.io/finalversion22/




