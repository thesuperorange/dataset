trainidxs <- base::sample(nrow(iris), nrow(iris) * 0.7)

traindf <- as.DataFrame(iris[trainidxs, ])
testdf <- as.DataFrame(iris[-trainidxs, ])
model <- spark.logit(traindf, Species ~ .,family = "multinomial")

summary(model)

iris_pred = predict(model,testdf)
head(iris_pred)

dropTempView("predtable")

createOrReplaceTempView(iris_pred, "predtable")
correct <- sql("SELECT prediction, Species FROM predtable WHERE prediction=Species")
count(correct)/count(iris_pred)

