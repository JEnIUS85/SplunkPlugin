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

Make sure splunkconfiguration.properties file is available .

Need to provide following detials in the properties file:

*** provide Splunk Http Endpoint Connector (HEC) url. 
** Currently support for Https endpoint is not built due to SSL issues.
HEC_ENDPOINT =http://localhost:8088/services/collector

*** Splunk source type against which data will be inserted. It can be anything userdefined.
SourceType =Rmodule


*** Splunk HEC Authentication. it will be provided once HEC option is enabled..
Authorization =Splunk B3CB2D7E-3040-441F-A87F-9B7B3A8A2A53
