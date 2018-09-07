dogs_r = read.csv("dataset/dogs3.txt")
dogs_r[,-1]
cor(dogs_r[,-1])

dogs = read.df("dataset/dogs3.txt","csv",header=T,inferSchema=T,delimiter=" ")
head(dogs)

dogs_split = randomSplit(dogs,c(7,3),2)
dogs_train = dogs_split[[1]]
dogs_test = dogs_split[[2]]

GLM_dogs = spark.glm(dogs_train, adoptedR~.-city,family = "gaussian")
summary(GLM_dogs)

dogs_pred = predict(GLM_dogs,dogs_test)
head(dogs_pred)

y = dogs_test$adoptedR
y_avg <- collect(agg(dogs_test, y_avg = mean(y)))$y_avg
z=dogs_pred$prediction
df <- transform(dogs_pred,sq_res = (y - z)^2, sq_tot = (y - y_avg)^2, res = y - z)
head(df)

head(select(df,sqrt(sum(df$sq_res)/nrow(df))))
