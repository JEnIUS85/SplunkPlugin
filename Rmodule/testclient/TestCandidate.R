# +++++=======++++++=====+++++=======TEST CANDIDATES=====+++++=======++++++=====+++++=======

#++++++++++++++++++++++++++ DEFAULT CALL +++++++++++++++++++++++++++++++++++++++++++++++#
run <- SplunkInjector()
#should insert "HelloWorld..its a test message" message in Splunk..
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#


#+++++++++++++++++++++++++++SEND LIST AS INPUT ++++++++++++++++++++++++++++++++++++++++++++++#
listvariable <- list()
listvariable$ApplicationName <- "WebTier"
listvariable$ServerName <- "WebTier1"
listvariable$BusinessTransaction <- "Login"
listvariable$MeasureName <- "CallsPerMinute"
listvariable$MeasureValue <- 42
run <- SplunkInjector(message=listvariable)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

#+++++++++++++++++++++++++ SEND XTS OBJECT AS INPUT++++++++++++++++++++++++++++++++++++++++++++++++#
inputfile <- "Air_Water_loggers_15min_example.csv"
file <- read.csv(inputfile, stringsAsFactors = FALSE)

## FORMAT TIME COLUMN TO POSIXlt
file$time15 <- strptime(file$time15, format = "%m/%d/%Y %H:%M")

## ROUND TO NEAREST HOUR
file$time15hr <- round(file$time15, "hour")

df.xts <- xts(x = file[, c(2:7)], order.by = file[, "time15"])

run <- SplunkInjector(message =df.xts) 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
