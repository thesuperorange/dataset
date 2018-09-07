transport = read.df("dataset/Transportation.csv","csv", header=T, inferSchema = T)

transport_split = randomSplit(transport,c(7,3),2)
transport_split[[1]]
transport_split[[2]]


model <- spark.logit(transport_split[[1]], Transportation ~ .,family = "auto")


predictions = predict(model,transport_split[[2]])

createOrReplaceTempView(predictions, "predictions")
correct <- sql("SELECT prediction, Transportation FROM predictions WHERE prediction=Transportation")
count(correct)
# 149
acc = count(correct)/count(predictions)
acc

