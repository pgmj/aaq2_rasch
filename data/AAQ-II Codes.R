# setwd("Directory")
# library(ltm)
# 
# #Database
# library(haven)
# Datacl = read_sav("Datafile")
# View(Datacl)
# names(Datacl)
# 
# #Data subsets
# DataBasecl = Datacl[, c(#"DeprLTCritA1_1", "DeprLTCritA1_2", "DeprLTCritA1_3", "DeprLTCritA1_4",
#                   "GenderBirth",                
#                   "Depr30d_i1", "Depr30d_i2", "Depr30d_i3", "Depr30d_i4",
#                   "Anx30d_i1", "Anx30d_i2", "Anx30d_i3", "Anx30d_i4",
#                   "SWB_7items_1", "SWB_7items_2", "SWB_7items_3", "SWB_7items_4",
#                   "SWB_7items_5", "SWB_7items_6", "SWB_7items_7",
#                   "AAQ_II_1", "AAQ_II_2", "AAQ_II_3", "AAQ_II_4", "AAQ_II_5",
#                   "AAQ_II_6", "AAQ_II_7")]
# names(DataBasecl)
# 
# #DataBase for Missing Analysis
# DataMisscl = DataBasecl[10:23]
# #Little Test of MCAR
# library(naniar)
# mcar_test(DataMisscl)
# 
# #DataBase for CFA and IRT Analysis
# library(psych)
# DataAAQcl = DataBasecl[17:23]
# DataAAQcl = DataAAQcl[complete.cases(DataAAQcl),]
# omega(DataAAQcl, nfactors = 1)
# 
# #Dataframes for multivariate analyses
# DataBasecl = as.data.frame(DataBasecl)
# 
# #Descriptives
# library(psych)
# options(digits = 3)
# describe.by(DataBasecl)
# summary(DataBasecl)
# 
# #Multivariate Normality
# library(MVN)
# mvn(DataAAQcl, desc= F, mvnTest = "mardia", univariateTest = "SW",
#     multivariateOutlierMethod = "quan", showOutliers = TRUE)
# cor(na.omit(DataAAQ))
# corPlot(DataBase)
# 
# #Careless Responses
# library(careless)
# IRV = irv(DataAAQ, na.rm=TRUE, split=FALSE, num.split=3)
# IRV = as.data.frame(IRV)
# LSTR = longstring(DataAAQ, avg=FALSE)
# LSTR = as.data.frame(LSTR)
# 
# #CFA Models
# library(lavaan)
# ModelAAQ = 'AAQ =~ AAQ_II_1 + AAQ_II_2 + AAQ_II_3 + AAQ_II_4 +
#                    AAQ_II_5 + AAQ_II_6 + AAQ_II_7'
# ModelAAQcu = 'AAQ =~ AAQ_II_1 + AAQ_II_2 + AAQ_II_3 + AAQ_II_4 +
#                    AAQ_II_5 + AAQ_II_6 + AAQ_II_7
#                    AAQ_II_1 ~~ AAQ_II_4
#                    AAQ_II_2 ~~ AAQ_II_3'
# #Fit indexes estimated for cleaned samples
# fitAAQ = cfa(ModelAAQcu, std.lv= TRUE, estimator = "MLR", 
#              sample.mean = TRUE, data=DataAAQcl, missing= "fiml") 
# #Summaries
# summary(fitAAQ, fit.measures = TRUE, standardized = TRUE, rsquare= TRUE)
# #Modification indexes
# modificationindices(fitAAQ, sort. = TRUE, minimum.value = 20)
# 
# #Local independence
# install.packages("EFA.dimensions")
# library(EFA.dimensions)
# LOCALDEP(DataAAQcl)
# 
# #Monotonicity
# install.packages("mokken")
# library(mokken)
# DataAAQcl = as.data.frame(DataAAQcl)
# coefH(DataAAQcl)
# 
# #IRT Models
# library("mirt")
# #Graded Response Model
# IRTAAQ = mirt(DataAAQcl, 1, itemtype = "graded", SE = TRUE, SE.type = "sandwich")
# IRTAAQ
# summary(IRTAAQ)
# IRTAAQpar = coef(IRTAAQ, IRTpars = TRUE, printSE = TRUE, simplify = FALSE)
# IRTAAQpar
# options(digits = 8)
# 
# #Model fit, item fit, person fit
# ##Model Fit
# ModelFit = M2(IRTAAQ, type = "C2", calcNULL = TRUE, na.rm = TRUE)
# ModelFit
# ##Item Fit
# itemfit(IRTAAQ, na.rm = TRUE)
# ##Person Fit
# head(personfit(IRTAAQ))
# summary(personfit(IRTAAQ))
# 
# #Graphs
# ##Item Characteristic Curves
# install.packages("remotes")
# remotes::install_github("masurp/ggmirt")
# library(ggmirt)
# 
# #Item Characteristic Curves
# ICCs = tracePlot(IRTAAQ, theta_range = c(-3, 3), n.answers = 7, facet = FALSE, legend = TRUE)
# write.table(ICCs$data,
#             "Directory",
#             sep="\t")
# update(itemplot(IRTAAQ, 1, type = "threshold"))
# update(itemplot(IRTAAQ, 2, type = "threshold"))
# update(itemplot(IRTAAQ, 3, type = "threshold"))
# update(itemplot(IRTAAQ, 4, type = "threshold"))
# update(itemplot(IRTAAQ, 5, type = "threshold"))
# update(itemplot(IRTAAQ, 6, type = "threshold"))
# update(itemplot(IRTAAQ, 7, type = "threshold"))
# 
# #Item Information Curves
# IFCs = itemInfoPlot(IRTAAQ, theta_range = c(-3, 3), facet = T)
# write.table(IFCs$data,
#             "Directory",
#             sep="\t")
# 
# #Item Fit Plot
# IOfS = itemfitPlot(IRTAAQ, fit_stats = "infit", color = "black", shape = 6)
# write.table(IOfS$data,
#             "Directory",
#             sep="\t")
# 
# #Person Fit Plots
# PFPl = personfitPlot(IRTAAQ)
# write.table(PFPl$data,
#             "Directory",
#             sep="\t")
# 
# #Test Information Curves
# TIC = testInfoPlot(IRTAAQ, theta_range = c(-3, 3), adj_factor = .125)
# write.table(TIC$data,
#             "Directory",
#             sep="\t")
# 
# install.packages("latticeExtra")
# library(latticeExtra)
# 
# plot(IRTAAQ, type = 'infoSE', theta_lim = c(-3, 3), 
#      main="")
# update(itemplot(my.grm, 1, type = "infotrace"))
# update(itemplot(my.grm, 2, type = "infotrace"))
# update(itemplot(my.grm, 3, type = "infotrace"))
# update(itemplot(my.grm, 4, type = "infotrace"))
# update(itemplot(my.grm, 5, type = "infotrace"))
# update(itemplot(my.grm, 6, type = "infotrace"))
# update(itemplot(my.grm, 7, type = "infotrace"))
# 
# library(mirt)       # Load data set and conduct GRM
# library(dplyr)      # Tidy the codes
# library(psych)      # Find skewness of the item distribution
# library(rmarkdown)  # Display tables in good ones
# library(knitr)      # Display tables in good ones
# library(lavaan)     # Conduct CFA analysis
# 
# #Conditional reliability
# plot(IRTAAQ, type = 'rxx', theta_lim = c(-3, 3), 
#      main="" )
# rel.mirt = function(x) {
#   eap <- mirt::fscores(x, full.scores=T, scores.only=T, full.scores.SE=T)
#   e <- mean(eap[, 2]^2)
#   s <- var(eap[, 1])
#   1-(e/(s+e)) }
# rel.mirt(IRTAAQ)
# 
# #Score characteristic curve
# plot(IRTAAQ, type = 'score', theta_lim = c(-3, 3), main = "")
# SCC = scaleCharPlot(IRTAAQ)
# SCC$data
# write.table(SCC$data,
#             "Directory",
#             sep="\t")
# 
# #Factor Scores
# itempersonMap(IRTAAQ)
# ScoresEAP = fscores(IRTAAQ, method = "EAP")
# hist(ScoresEAP)
# write.table(ScoresEAP,
#             "Directory",
#             sep="\t")