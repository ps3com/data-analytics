# TODO: Add comment
# 
# Author: paul
###############################################################################
farooUtils = new.env()
farooUtils$apiURL <- "http://www.faroo.com/api?"
farooUtils$.defaultFormat <- "HTML"
farooUtils$jsonResults <- NULL
farooUtils$modifiedResultMatrix <- NULL
farooUtils$start <- 1
farooUtils$length <- 10
farooUtils$src <- "web"

farooUtils$searchJSON = function(searchTerm){	
	# escape url terms
	st <- paste(farooUtils$apiURL, "key=", properties$farooAPIKey,
			"&start=", farooUtils$start, "&length=", farooUtils$length,
			"&src=", farooUtils$src, "&f=json",
			"&q=", searchTerm, sep = "")
	#cat(paste(st, "\n", sep=""))
	data <- getURL(st , cainfo = "cacert.pem")
	#jsonList <- fromJSON( data, method='C')
	jsonList <- fromJSON( data, simplify=FALSE)
	# keep hold of this in case we need to search again
	farooUtils$jsonResults <- jsonList
	# format the results into a matrix
	
	farooUtils$modifiedResultMatrix <- matrix(0,nrow=0,ncol=3) 
	colnames(farooUtils$modifiedResultMatrix) <- c('url','title','desc')
	
	for (i in 1:length(farooUtils$jsonResults$results)) {
		link <- farooUtils$jsonResults$results[[i]]$url
		title <- farooUtils$jsonResults$results[[i]]$title		
		snippet <- farooUtils$jsonResults$results[[i]]$kwic	
		farooUtils$modifiedResultMatrix <- rbind(farooUtils$modifiedResultMatrix,c(link,title,snippet))
	}
	return (as.data.frame(farooUtils$modifiedResultMatrix, stringsAsFactors=FALSE))
}

