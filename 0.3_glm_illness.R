illness_r = read.csv("dataset/illness.csv")
cor(illness_r[,-1])

pairs(illness_r)

illness_df = read.df("dataset/illness.csv","csv",header=T,inferSchema=T)
GLM1 = spark.glm(illness_df, satisfy~age,family = "gaussian")
summary(GLM1)

GLM2 = spark.glm(illness_df, satisfy~age+anxiety+illness,family = "gaussian")
summary(GLM2)

illness_prediction = predict(GLM2,illness_df)
head(illness_prediction)

illness_split = randomSplit(illness_df,c(7,3),2)
illness_train = illness_split[[1]]
illness_test = illness_split[[2]]

GLM3 = spark.glm(illness_train, satisfy~age+anxiety+illness,family = "gaussian")
summary(GLM3)

ill_pred2 = predict(GLM3,illness_test)
head(ill_pred2)

y = illness_test$satisfy
y_avg <- collect(agg(illness_test, y_avg = mean(y)))$y_avg
z=ill_pred2$prediction
df <- transform(ill_pred2,sq_res = (y - z)^2, sq_tot = (y - y_avg)^2, res = y - z)
head(df)


