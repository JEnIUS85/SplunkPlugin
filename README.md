# SplunkPlugin
Provides utilities to push data into Splunk through HEC ( Http-Endpoint-Connector)

Utility #1 : R Code.

In case you need an R module to push data to Splunk then code under R module can help. 
you need to call following function from your R module:

SplunkInjector(message,time).

Here, 
message ==> You can pass a string (character) vector, or a List object or an XTS object. 
            It will be converted your message input into JSON format by code before pushing to Splunk.
       
Ex: message <- “ApplicationName=WCSTier,ServerName=WCS_Server,BusinessTransaction=Login,MeasureName=CallsPerMinute,MeasureValue=42”
here setting message as a string vector containin performance stats..

time ==>    OPTIONAL attribute. Has to be epoch time(long). If provided then will be used as timestamp while inserted record in Splunk.
            By Default, current timestamp is picked by R code.
            it XTS object is provided as message then time value from index column is picked while inserting data into Splunk
