# Association Rule Mining:
# Following examples use The Titanic dataset, a 4-dimensional table
# with summarized information on the fate of passengers on the
# Titanic according to social class, sex, age and survival
# It can be found in https://www.rdatamining.com/datasets

# get current script folder
myPath <- dirname(rstudioapi::getSourceEditorContext()$path)

#load dataset (assuming it is in script's folder)
load(paste0(myPath,"/titanic.raw.rdata"))
str(Titanic)


library(arules)
# find association rules with default settings
rules <- apriori(titanic.raw)
inspect(rules)
## use code below if above code does not work
arules::inspect(rules)

# rules with rhs (right-hand side) containing "Survived" only
rules <- apriori(titanic.raw, control = list(verbose=F)
                 ,parameter = list(minlen=2, supp=0.005, conf=0.8)
                 ,appearance = list(rhs=c("Survived=No", "Survived=Yes")
                                    ,default="lhs"))
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)
# Removing Redundancy, find redundant rules
redundant <- is.redundant(rules.sorted)
which(redundant)
# remove redundant rules
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)
# Visualizing Association Rules
library(arulesViz)
plot(rules.pruned[1:3])
plot(rules.pruned[1:3], method="graph", control=list(type="items"))
plot(rules.pruned[1:3], method="paracoord", control=list(reorder=TRUE))