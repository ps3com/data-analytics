# properties.R
#
# Reads in values set in a "local.app.properties" or "app.properties" 
# file found in the same folder as this script
# 
# Author: Paul Sharples
###############################################################################
properties = new.env()

properties$appFileDefault <- "app.properties"
properties$dataSrc <- NULL
properties$appTitle <- NULL
properties$dbUsername <- NULL
properties$dbPassword <- NULL
properties$dbName <- NULL
properties$dbHost <- NULL
properties$webSearchImplementation <- NULL
properties$googleAPIKey <- NULL
properties$googleServerKey <- NULL
properties$farooAPIKey <- NULL

properties$init = function(){
	# override the "app.properties" file with your "local.app.properties" if present
	fileToLoad <- NULL
	localFile <- paste("local.", properties$appFileDefault, sep = "")
	
	if (file.exists(localFile)){
		fileToLoad <- localFile
	}
	else{
		fileToLoad <- properties$appFileDefault
		if (!file.exists(fileToLoad)){
			stop(paste("Could not find a property file to load. Tried both" , localFile, "and", properties$appFileDefault, sep=" "))
		}
	}
	# update this so that we know which property file is going to be loaded
	properties$appFileDefault <- fileToLoad
	properties$dataSrc = read.table(fileToLoad, header=FALSE, stringsAsFactors=FALSE, col.names=c("prefName","prefValue"), sep="=")

	# load database settings
	properties$appTitle <- properties$.loadValue("appTitle", TRUE)
	properties$dbUsername <- properties$.loadValue("dbUsername", TRUE)
	properties$dbPassword <- properties$.loadValue("dbPassword", TRUE)
	properties$dbName <- properties$.loadValue("dbName", TRUE)
	properties$dbHost <- properties$.loadValue("dbHost", TRUE)
	
	# load which search API to use
	properties$webSearchImplementation <- properties$.loadValue("webSearchImplementation", TRUE)
	
	# load google custom search api settings
	properties$googleAPIKey <- properties$.loadValue("googleAPIKey", FALSE)
	properties$googleServerKey <- properties$.loadValue("googleServerKey", FALSE)
	# load faroo search API key
	properties$farooAPIKey <- properties$.loadValue("farooAPIKey", FALSE)
	
}

properties$.loadValue = function(valueName, mandatory){
	#browser()
	result <- properties$dataSrc[properties$dataSrc$prefName == valueName, "prefValue"]
	# check there is actually something there and not an empty string

	if(nchar(result) < 1 && mandatory) {
		stop(paste(valueName, 'not found in properties file', properties$appFileDefault, sep=" "))
	}
	return (result)
}