babies = read.df("dataset/babies.txt","csv",delimiter = " ",header=T,inferSchema=T)
head(babies)
printSchema(babies)

babies = dropna(babies)

dt_babies_model = spark.decisionTree(babies, bwt~gestation+parity+age+height+weight+smoke, type = "regression",maxDepth = 3, maxBins = 32 )
stats = summary(dt_babies_model)
stats
stats$maxDepth

