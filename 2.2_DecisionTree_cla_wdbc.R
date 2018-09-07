wdbc2 = read.csv("dataset/wdbc.data","csv",header=F,sep=",")

wdbc2[,2]=as.numeric(wdbc2[,2])
res=cor(wdbc2)
library(corrplot)
corrplot(res, type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)

wdbc = read.df("dataset/wdbc.data","csv",header=F,inferSchema=T)
wdbc = dropna(wdbc)
wdbc$`_c0`=NULL

wdbc = withColumnRenamed(wdbc,"_c1","Diagnosis")

wdbc_split = randomSplit(wdbc,c(7,3),2)
wdbc_train = wdbc_split[[1]]
wdbc_test = wdbc_split[[2]]



dt_wdbc_model = spark.decisionTree(wdbc_train,Diagnosis~., type = "classification",maxDepth = 5, maxBins = 16 )

stats2 <- summary(dt_wdbc_model)
stats2$numFeatures
stats2$maxDepth
# stats2$depth
# stats2$numNodes
# stats2$numClasses

predictions = predict(dt_wdbc_model,wdbc_test)

createOrReplaceTempView(predictions, "predictions")
correct <- sql("SELECT prediction, Diagnosis FROM predictions WHERE prediction=Diagnosis")
count(correct)
# 149
acc = count(correct)/count(predictions)
acc

