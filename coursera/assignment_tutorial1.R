> dataset_url<-"http://s3.amazonaws.com/practice_assignment/diet_data.zip"
> download.file(dataset_url,"diet_data.zip")
URL 'http://s3.amazonaws.com/practice_assignment/diet_data.zip'을 시도합니다
Content type 'application/zip' length 1124 bytes
downloaded 1124 bytes

> unzip("diet_data.zip",exdir="diet_data")
> list.files("diet_data")
[1] "Andy.csv"  "David.csv" "John.csv"  "Mike.csv"  "Steve.csv"
> andy<-read.csv("diet_data/Andy.csv")
> files<-list.files("diet_data")
> files
[1] "Andy.csv"  "David.csv" "John.csv"  "Mike.csv"  "Steve.csv"
> andy_start<-andy[1,"Weight"]
> andy_end<-andy[30,"Weight"]
> andy_loss<-andy_start-andy_end
> andy_loss
[1] 5
> files[3:5]
[1] "John.csv"  "Mike.csv"  "Steve.csv"
> head(read.csv(files[3]))
Error in file(file, "rt") : 커넥션을 열 수 없습니다
추가정보: 경고메시지(들): 
        In file(file, "rt") :
        파일 'John.csv'를 여는데 실패했습니다: No such file or directory
> files_full<-list.files("diet_data",full.names = TRUE)
> files_full
[1] "diet_data/Andy.csv"  "diet_data/David.csv" "diet_data/John.csv" 
[4] "diet_data/Mike.csv"  "diet_data/Steve.csv"
> andy_david<-rbind(andy,read.csv(files_full[2]))
> head(andy_david)
Patient.Name Age Weight Day
1         Andy  30    140   1
2         Andy  30    140   2
3         Andy  30    140   3
4         Andy  30    139   4
5         Andy  30    138   5
6         Andy  30    138   6

> day_25<-andy_david[which(andy_david$Day == 25),]
> day_25
Patient.Name Age Weight Day
25         Andy  30    135  25
55        David  35    203  25

> dat<-data.frame()
> for(i in 1:5){
        +         dat<-rbind(dat,read.csv(files_full[i]))
        + }
> str(dat)
'data.frame':	150 obs. of  4 variables:
        $ Patient.Name: Factor w/ 5 levels "Andy","David",..: 1 1 1 1 1 1 1 1 1 1 ...
$ Age         : int  30 30 30 30 30 30 30 30 30 30 ...
$ Weight      : int  140 140 140 139 138 138 138 138 138 138 ...
$ Day         : int  1 2 3 4 5 6 7 8 9 10 ...
> for(i in 1:5){
        +         dat2<-data.frame()
        +         dat2<-rbind(dat2,read.csv(files_full[i]))
        + }
> str(dat2)
'data.frame':	30 obs. of  4 variables:
        $ Patient.Name: Factor w/ 1 level "Steve": 1 1 1 1 1 1 1 1 1 1 ...
$ Age         : int  55 55 55 55 55 55 55 55 55 55 ...
$ Weight      : int  225 225 225 224 224 224 223 223 223 223 ...
$ Day         : int  1 2 3 4 5 6 7 8 9 10 ...
> head(dat2)
Patient.Name Age Weight Day
1        Steve  55    225   1
2        Steve  55    225   2
3        Steve  55    225   3
4        Steve  55    224   4
5        Steve  55    224   5
6        Steve  55    224   6
> View(files)
> median(dat$Weight)
[1] NA
> median(dat$Weight, na.rm=TRUE)
[1] 190
> dat_30<-dat[which(dat[,"Day"]==30),]
> dat_30
Patient.Name Age Weight Day
30          Andy  30    135  30
60         David  35    201  30
90          John  22    177  30
120         Mike  40    192  30
150        Steve  55    214  30
> dat_1<-dat[which(dat[,"Day"]==1),]
> dat_1
Patient.Name Age Weight Day
1           Andy  30    140   1
31         David  35    210   1
61          John  22    175   1
91          Mike  40    188   1
121        Steve  55    225   1
> median(dat_30$Weight)
[1] 192
> median(dat_1$Weight)
[1] 188
> weightmedian<-function(directory,day){
        +         files_list<-list.files(directory,full.names = TRUE)
        +         df<-data.frame()
        +         for(i in 1:5){
                +                 df<-rbind(df,read.csv(files_full[i]))
                +         }
        +         df_subset<-dat[which(dat[,"Day"]==day),]
        +         median(df_subset[,"Weight"],na.rm = TRUE)
        + }
> weightmedian(directory = "diet_data",day=20)
[1] 197.5
> summary(files_full)
Length     Class      Mode 
5 character character 
> tmp<-vector(mode = "list",length = length(files_full))
> summary(tmp)
Length Class  Mode
[1,] 0      -none- NULL
[2,] 0      -none- NULL
[3,] 0      -none- NULL
[4,] 0      -none- NULL
[5,] 0      -none- NULL
