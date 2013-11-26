# TODO: Add comment
# 
# Author: paul
###############################################################################
duckDuckGoUtils = new.env()

duckDuckGoUtils$apiURL <- "http://api.duckduckgo.com/?q="
duckDuckGoUtils$.defaultFormat <- "HTML"
duckDuckGoUtils$jsonResults <- NULL
duckDuckGoUtils$modifiedResultMatrix <- NULL

duckDuckGoUtils$searchHTML = function(searchTerm){
	data <- getURL( paste(duckDuckGoUtils$apiURL, searchTerm, "&format=", 
					duckDuckGoUtils$.defaultFormat, sep = "") ) 
	return (data)
}

duckDuckGoUtils$searchXML = function(searchTerm){
	data <- getURL( paste(duckDuckGoUtils$apiURL, searchTerm, 
					"&format=xml", sep = "") ) 
	return (data)
}

duckDuckGoUtils$searchJSON = function(searchTerm){
	data <- getURL( paste(duckDuckGoUtils$apiURL, searchTerm, 
					"&format=json",sep = "") )
	#jsonlist<-fromJSON( data, method='C')
	jsonList <- fromJSON( data, simplify=FALSE)
	duckDuckGoUtils$jsonResults <- jsonList
	
	duckDuckGoUtils$modifiedResultMatrix <- matrix(0,nrow=0,ncol=3) 
	colnames(duckDuckGoUtils$modifiedResultMatrix) <- c('url','title','desc')
	
	for (i in 1:length(duckDuckGoUtils$jsonResults$RelatedTopics)) {
		link <- duckDuckGoUtils$jsonResults$RelatedTopics[[i]]$FirstURL
		title <- duckDuckGoUtils$jsonResults$RelatedTopics[[i]]$Text	
		snippet <- duckDuckGoUtils$jsonResults$RelatedTopics[[i]]$Text	
		duckDuckGoUtils$modifiedResultMatrix <- rbind(duckDuckGoUtils$modifiedResultMatrix,c(link,title,snippet))
	}
	return (as.data.frame(duckDuckGoUtils$modifiedResultMatrix, stringsAsFactors=FALSE))
}