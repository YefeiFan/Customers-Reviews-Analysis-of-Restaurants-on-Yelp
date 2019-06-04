library(jsonlite)
library(dplyr)
library(reshape2)
library(data.table)
library(stringr)
library(tm)
library(qdap)
library(ggplot2)



#Identify business that are restaurant in business.jason file
#Use the business_id from above dataset to find suggestions and reviews
#USe user_id from suggestions and reviews file to get users dataset




#Extracting data from "buinssess.json" file
yelp_business3<-stream_in(textConnection(readLines("business.json", n=300000)),verbose=F)
yelp_business3<-yelp_business3[,-which(colnames(yelp_business3) %in% c("attributes","hours"))]

t<-yelp_business3%>%group_by(city,state)%>%summarise(count=n())%>%arrange(desc(count))%>%filter(state=='AZ')

yelp_business2<-yelp_business3[which(yelp_business3$city=="Mississauga"),]


#Business Categories
for (i in 1:length(yelp_business2$categories)){
  yelp_business2$categories2[i]=toString(yelp_business2$categories[[i]],sep=" ")
}


#Identify Businesses that are Restaurants
for (i in 1:nrow(yelp_business2)){
  if(yelp_business2$categories2[i] %like% c("Restaurants")){
    yelp_business2$restaurant[i]="Code1"
  }
  else {
    yelp_business2$restaurant[i]="NULL"
  }
}

business_data<-yelp_business2[which(yelp_business2$restaurant=="Code1"),]



#Check for Categories
b<-word_list(yelp_business2$categories2)


#Build Columns for Each Entry
for (i in 1:nrow(business_data)){
  if(business_data$categories2[i] %like% c("American")){
    business_data$american[i]="Code3"
  }
  else {
    business_data$american[i]="NULL"
  }
}


for (i in 1:nrow(business_data)){
  if(business_data$categories2[i] %like% c("Mexican")){
    business_data$mexican[i]="Code2"
  }
  else {
    business_data$mexican[i]="NULL"
  }
}



for (i in 1:nrow(business_data)){
  if(business_data$categories2[i] %like% c("Italian")){
    business_data$italian[i]="Code4"
  }
  else {
    business_data$italian[i]="NULL"
  }
}



for (i in 1:nrow(business_data)){
  if(business_data$categories2[i] %like% c("Chinese")){
    business_data$chinese[i]="Code5"
  }
  else {
    business_data$chinese[i]="NULL"
  }
}



#BUSINESS CATEGORY
cat1<-business_data[,c(1,15)]
colnames(cat1)<-c("business_id","category_id")
cat2<-business_data[,c(1,16)]
colnames(cat2)<-c("business_id","category_id")
cat3<-business_data[,c(1,17)]
colnames(cat3)<-c("business_id","category_id")
cat4<-business_data[,c(1,18)]
colnames(cat4)<-c("business_id","category_id")
cat5<-business_data[,c(1,19)]
colnames(cat5)<-c("business_id","category_id")


business_category<-bind_rows(cat1,cat2,cat3,cat4,cat5)
business_category<-business_category[which(business_category$category_id!="NULL"),]
write.csv(business_category,"Data/Business_Category.csv",row.names = FALSE)



#BUSINESS LOCATION AND BUSINESS DETAILS
business_total<-subset(yelp_business2,business_id %in% business_category$business_id)
business_location<-business_total[,which(colnames(business_total) %in% c("business_id","latitude","longitude","address","city","state","postal_code"))]
for (i in 1:nrow(business_location)){
  business_location$location_id[i]<-paste(business_location$business_id[i],"00_",i,sep = '')
}
business_location<-business_location[,c("location_id","business_id","latitude","longitude","address","city","state","postal_code")]
business_details<-business_total[,(which(colnames(business_total) %in% c("business_id","name","neighborhood","is_open")))]

write.csv(business_details,"Data/Business.csv",row.names = FALSE)
write.csv(business_location,"Data/Business_Location.csv",row.names = FALSE)






#Extracting data from "tip.json" file
yelp_tip2<-stream_in(textConnection(readLines("tip.json", n=5000000)),verbose=F)

business_suggestions<-subset(yelp_tip2,business_id %in% business_details$business_id)
for (i in 1:nrow(business_suggestions)){
  business_suggestions$suggestion_id[i]<-paste("sugg_",i,sep = '')
}

business_suggestions<-business_suggestions[,c(6,4,5,2,1,3)]
write.csv(business_suggestions,"Data/Suggestions.csv",row.names = FALSE)







#Extracting data from "review.json" file
yelp_review2<-stream_in(textConnection(readLines("review.json", n=10000000)),verbose=F)
business_reviews<-subset(yelp_review2,business_id %in% business_category$business_id)
business_reviews<-business_reviews[,c(2,3,5,6,4,7,8,9)]
write.csv(business_reviews,"Data/business_reviews.csv",row.names = FALSE)



a<-business_reviews[!(business_reviews$user_id %in% business_suggestions$user_id),]
b<-business_suggestions[!(business_suggestions$user_id %in% business_reviews$user_id),]










#Extracting data from "user.json" file
dtemp<-readLines("user.json", n=1326101)
yelp_user<-list()
b<-list()

k<-0
l<-0
for (i in 1:26){
  k=((i-1)*50000+1)
  l=(i*50000)
  b[[i]]<-dtemp[k:l]
  yelp_user[[i]]<-stream_in(textConnection(b[[i]]),verbose=F)
}

b[[27]]<-dtemp[(26*50000+1):1326101]
yelp_user[[27]]<-stream_in(textConnection(b[[27]]),verbose=F)

user_data<-rbind(yelp_user[[1]],yelp_user[[2]],yelp_user[[3]],yelp_user[[4]],yelp_user[[5]],yelp_user[[6]],
                 yelp_user[[7]],yelp_user[[8]],yelp_user[[9]],yelp_user[[10]],yelp_user[[11]],yelp_user[[12]],
                 yelp_user[[13]],yelp_user[[14]],yelp_user[[15]],yelp_user[[16]],yelp_user[[17]],yelp_user[[18]],
                 yelp_user[[19]],yelp_user[[20]],yelp_user[[21]],yelp_user[[22]],yelp_user[[23]],yelp_user[[24]],
                 yelp_user[[25]],yelp_user[[26]],yelp_user[[27]])

business_user<-user_data[,which(names(user_data) %in% c("user_id","name","yelping_since","fans"))]


#write.csv(business_user2,"Data/User_all.csv",row.names = FALSE)

a<-as.character(business_suggestions$user_id)
b<-as.character(business_reviews$user_id)
user_id2<-unique(c(a,b))
business_user2<-subset(business_user, user_id %in% user_id2)

write.csv(business_user2,"Data/User.csv",row.names = FALSE)


