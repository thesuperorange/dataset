credit = read.df("dataset/Log_reg_credit.csv","csv",inferSchema=T,header=T)

logModel2 = spark.glm(credit, Risk~.-OBS, family = "binomial")
summary(logModel2)

pred_credit = predict(logModel2,credit)
head(pred_credit)

pred_credit_2 = transform(pred_credit,ifelse(pred_credit$prediction>0.5,1,0))
head(pred_credit_2)

Logit_credit = spark.logit(credit, Risk~.-OBS, family = "auto")
summary(Logit_credit)

write.ml(Logit_credit,"model/Logit_credit",overwrite = TRUE)
Log_ml = read.ml("model/Logit_credit")

predictions= predict(Log_ml,credit)
head(predictions)

createOrReplaceTempView(predictions, "predtable")
correct <- sql("SELECT prediction, Risk FROM predtable WHERE prediction=Risk")
count(correct)/count(predictions)

