# Test script to fire events to Splunk HTTP-Event-Collector (HEC) endpoint...

#library(httr)
library(uuid)
library(curl)
library(bitops)
library(RCurl)
library(RJSONIO)
library(properties)



SplunkInjector <- function(flag=TRUE,message="HelloWorld..its a test message",...){
  print("Splunk Plugin Started.. Please wait while we inject the message into Splunk DB")
  inputList <- list(...)
  
  time <- ""
  # setup the time variable...#if time is provided as input or not.
  if(!is.null(inputList$time)){
    time <- inputList$time
  }else{
    time <- as.integer(format(round(as.integer( as.POSIXct(  Sys.time() ) ), 3), nsmall=3))
  } 
  
  propertyFile  <- Initializer()
  HEC_ENDPOINT <- propertyFile$HEC_ENDPOINT
  SplunkSourceType <- propertyFile$SourceType
  Authorization <- propertyFile$Authorization
  
  # Create Random UUID variable 
  uuidvariable <- UUIDgenerate(FALSE)
  
  # Create Header Section...
  httpheader <- c("Accept"="application/json; charset=UTF-8",
                  "Content-Type"="application/json",
                  "X-Splunk-Request-Channel" = uuidvariable,
                  "Authorization" = Authorization)
  
  jsonbody <- ""
  
  #if message passed is List object or XTS then need to format it before creating post body
  if(typeof(message) == 'character'){
    #do nothing.. use the Passed value of message variable as it is in the jsonbody
    jsonbody <- RJSONIO::toJSON(list("time"=time,"sourcetype"=SplunkSourceType,"event"=message))
  }
  else if(typeof(message) == 'list'){
    #parse the message value.. convert from list to string ...
    message <- parseList(message)
    #message <- toJSON(listvariable, pretty=TRUE)
    jsonbody <- RJSONIO::toJSON(list("time"=time,"sourcetype"=SplunkSourceType,"event"=message))
  }
  else if (is.xts(message)){
    #print("message is xts object")
    
    # provided input is xts object type. need to filter out date index and core matrix.
    # core matrix could be n X n format. So need to iterate through each row and column to 
    ## to build the message
    timestampVector <- index(message)
    core_data <- coredata(message) 
    colCount <- ncol(core_data)
    rowCount <- nrow(core_data)
    colname <-colnames(core_data)
    
    # initiate for loop to iterate over all the elements of Core-Data object..
    for(i in 1:rowCount){
      timestampvalue <- timestampVector[i]
      timestampvalue <- as.integer(format(round(as.integer( as.POSIXct(timestampvalue)), 3), nsmall=3))
      timestring <-paste0(timestampvalue,".000",sep="")
      
      #print(timestring)
      
      msg <- toJSON(core_data[i,], pretty=TRUE)
      msg <- RJSONIO::toJSON(list("time"=timestring,"sourcetype"=SplunkSourceType,"event"=msg))
      
      if(i==1){
        jsonbody = msg
      }else{
        jsonbody <- paste0(jsonbody,msg,sep="")
      }
      
    }# for loop to iterate Core-Data object over..
    
  }#else if condiction for xts object over..
  
  # create JSON body that need to be inserted.
  #jsonbody <- RJSONIO::toJSON(list("time"=time,"sourcetype"=SplunkSourceType,"event"=message))
  
  #print(jsonbody)
  
  # insert data into Splunk...
  httpResponse <- postForm(HEC_ENDPOINT
                           ,.opts=list(httpheader=httpheader
                                       ,postfields=jsonbody
                                       ,proxy=ie_get_proxy_for_url(target_url = HEC_ENDPOINT)
                                       ,followlocation=TRUE
                                       ,verbose=FALSE
                                       ,ssl.verifypeer=FALSE))
  print("Splunk Plugin Stopped..")
  
}# Splunk Injector Function over..

Initializer <- function(...){
  inputList <- list(...)
  propertyFile <- properties::read.properties("splunkconfiguration.properties")
  
  return (propertyFile)
}# Initializer() Function over..
