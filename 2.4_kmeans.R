iris_df = createDataFrame(iris[,-5])
iris_kmeans_model = spark.kmeans(iris_df, ~., k = 3, maxIter = 20, initMode = "random", seed = NULL)
summary(iris_kmeans_model)

#R
iris_new = iris[,-5]
iris.kmeans  = kmeans(iris_new,3)
iris.kmeans$cluster
iris.kmeans$centers

table(iris.kmeans$cluster,iris[,5])

prediction = predict(iris_kmeans_model,iris_df)

schema <- structType(structField("Sepal_Length", "double"), structField("Sepal_width", "double"), structField("Petal_Length", "double")
                     ,structField("Petal_Width", "double"), structField("prediction_Spark", "integer"), structField("prediction_R", "integer"))
df1 <- dapply(prediction, function(x) { x <- cbind(x, iris.kmeans$cluster) }, schema)

ColorBird = read.df("dataset/ColorBird.csv","csv",header="T",inferSchema=T)

