people = read.df("dataset/people.json","json")
people_csv = read.df("dataset/people.csv","csv",sep=";", header=T,  inferSchema = "true")
write.df(people,path="people.parquet", source = "parquet", mode="overwrite")
collect(sum(people$age))
sum =select(people,sum(people$age))
collect(sum)

credit = read.df("dataset/Log_reg_credit.csv","csv", header=T, inferSchema = T)
group_major = count(groupBy(credit,credit$Major))
collect(arrange(group_major,desc(group_major$count)))
filter(credit,credit$GPA>3)


appx = select(credit,approxCountDistinct(credit$Gender))
collect(appx)

credit_rm = withColumnRenamed(credit, "OBS",  "num")
head(credit_rm)
collect(people[people$age>20])

collect(people)
collect(dropna(people))
collect(fillna(people,list(age=30)))


