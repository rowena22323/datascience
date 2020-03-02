library(dplyr)

chicago<-readRDS("chicago.rds")

dim(chicago)

str(chicago)

names(chicago)

names(chicago)[1:3]

subset<-select(chicago,city:dptp) # to specify a range of variable names

head(subset)

head(select(chicago,-(city:dptp))) # omit variables by using the negative sign

subset<-select(chicago,ends_with("2")) # specify variable names based on patterns

str(subset)

subset<-select(chicago,starts_with("d")) # choose variables in dataframe which starts "d"

str(subset)

chic.f<-filter(chicago, pm25tmean2 > 30)

str(chic.f)

summary(chic.f$pm25tmean2)

chic.f<-filter(chicago, pm25tmean2>30 & tmpd >80) # can place arbitrary complex logical sequence inside of.

select(chic.f,date,tmpd,pm25tmean2) # subset rows which the conditions are met

chicago<-arrange(chicago, date)

head(select(chicago,date,pm25tmean2),3)

tail(select(chicago,date,pm25tmean2),3)

chicago<-arrange(chicago,desc(date)) # columns can be arranged order too by using the special desc()operator.

head(select(chicago,date,pm25tmean2),3)

tail(select(chicago, date, pm25tmean2),3)

head(chicago[,1:5],3)

chicago <- rename(chicago, dewpoint=dptp, pm25=pm25tmean2) 
# renamed obscure variables to be more sensible.
# syntax in rename()function is new name on the left sideof the `=` sign

head(chicago[,1:5],3)

chicago<-mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))

head(chicago)

head(transmute(chicago, 
              pm10dtrend = pm10tmean2 - mean(pm10tmean2, na.rm=TRUE),
              o3dtrend = o3tmean2 - mean(o3tmean2, na.rm=TRUE)))
#theotehr variables are not transmuted. then drop.

chicago<-mutate(chicago, year=as.POSIXlt(date)$year +1900)

years<-group_by(chicago, year)

summarize(years, pm25=mean(pm25, na.rm=TRUE),
         o3=max(o3tmean2, na.rm=TRUE),
         no2=median(no2tmean2, na.rm=TRUE))
# summarize returns a data frame with year as the first column, and then the annual averages of pm25, o3, no2

# average levels of o3 and on2 within quintiles (5 parts of distributions) of pm25
qq<-quantile(chicago$pm25, seq(0,1,0.2), na.rm=TRUE)

chicago<-mutate(chicago, pm25.quint=cut(pm25, qq))

quint<-group_by(chicago, pm25.quint)

summarize(quint, o3=mean(o3tmean2, na.rm=TRUE),
          no2=mean(no2tmean2, na.rm=TRUE)) # there appears to be a positive correlation between pm25 and no2

mutate(chicago, pm25.quint = cut(pm25,qq)) %>%
group_by(pm25.quint) %>%
summarize(o3=mean(o3tmean2, na.rm=TRUE),
         no2=mean(no2tmean2, na.rm=TRUE))
# Once you travel down the pipeline  with %>%, the first argument is taken to be the output of the previous element in the pipeline.

mutate(chicago, month=as.POSIXlt(date)$mon + 1) %>%
group_by(month) %>%
summarize(pm25=mean(pm25, na.rm=TRUE),
         o3=mean(o3tmean2, na.rm=TRUE),
         no2=mean(no2tmean2, na.rm=TRUE))
