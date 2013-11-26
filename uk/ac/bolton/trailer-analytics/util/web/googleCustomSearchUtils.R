# TODO: Add comment
# 
# Author: paul
###############################################################################
googleCustomSearchUtils = new.env()

googleCustomSearchUtils$apiURL <- "https://www.googleapis.com/customsearch/v1?"
googleCustomSearchUtils$.defaultFormat <- "HTML"
googleCustomSearchUtils$jsonResults <- NULL
googleCustomSearchUtils$modifiedResultMatrix <- NULL

googleCustomSearchUtils$searchJSON = function(searchTerm){	
	# escape url terms
	data <- getURL( paste(googleCustomSearchUtils$apiURL, "key=", properties$googleAPIKey,
					"&cx=", properties$googleServerKey, "&q=", searchTerm, sep = ""), cainfo = "cacert.pem")
	 #jsonList <- fromJSON( data, method='C')
	jsonList <- fromJSON( data, simplify=FALSE)
	# keep hold of this in case we need to search again
	googleCustomSearchUtils$jsonResults <- jsonList
	# format the results into a matrix
	
	googleCustomSearchUtils$modifiedResultMatrix <- matrix(0,nrow=0,ncol=3) 
	colnames(googleCustomSearchUtils$modifiedResultMatrix) <- c('url','title','desc')
	
	for (i in 1:length(googleCustomSearchUtils$jsonResults$items)) {
		link <- googleCustomSearchUtils$jsonResults$items[[i]]$link
		title <- googleCustomSearchUtils$jsonResults$items[[i]]$title		
		snippet <- googleCustomSearchUtils$jsonResults$items[[i]]$snippet	
		googleCustomSearchUtils$modifiedResultMatrix <- rbind(googleCustomSearchUtils$modifiedResultMatrix,c(link,title,snippet))
	}
	return (as.data.frame(googleCustomSearchUtils$modifiedResultMatrix, stringsAsFactors=FALSE))
}

googleCustomSearchUtils$searchHTML = function(searchTerm){
	#TODO
}

googleCustomSearchUtils$searchXML = function(searchTerm){
	#TODO
}

