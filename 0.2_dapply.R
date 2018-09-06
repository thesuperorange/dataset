credit = read.df("dataset/Log_reg_credit.csv","csv", header=T, inferSchema = T)

credit_schema = schema(credit)

df2 <- dapply(
  credit,
  function(x) {
    y=x[x$Age>25 ,]
    cbind(1L,y[,-1])
  },
  credit_schema)

collect(df2)

df3 <- dapplyCollect(
  credit,
  function(x) {
    y=x[x$Age>25 ,]
    cbind(y$OBS*3,y)
  })

schema <- structType(structField("waiting", "double"), structField("max_eruption", "double"))
result <- gapply(
  df,
  "waiting",
  function(key, x) {
    y <- data.frame(key, max(x$eruptions))
  },
  schema)

result
collect(result)

families <- c("gaussian", "poisson")
train <- function(family) {
  model <- glm(Sepal.Length ~ Sepal.Width + Species, iris, family = family)
  summary(model)
}
model.summaries <- spark.lapply(families, train)

# Print the summary of each model
print(model.summaries)

