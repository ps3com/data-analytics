# TODO: Add comment
# 
# Author: paul
###############################################################################
source('../util/web/duckDuckGoUtils.R', chdir=T)
source('../util/web/googleCustomSearchUtils.R', chdir=T)
source('../util/web/farooUtils.R', chdir=T)

webSearchController = new.env()

webSearchController$searchTerms <- NULL
#webSearchController$searchTermsEncoded <- NULL
webSearchController$searchResults <- NULL
#webSearchController$allowedImpl <- factor(c("googleCustomSearch", "faroo", "duckDuckGo"))
webSearchController$impl <- NULL
webSearchController$scrapedContent <- NULL
webSearchController$labels <- NULL

webSearchController$init = function(){
	# TODO compare this against allowed impls in above factor levels
	webSearchController$impl <- properties$webSearchImplementation	
}

webSearchController$searchJSON = function(searchText){
	#webSearchController$searchTerms <- searchText
	webSearchController$searchTerms <- gsub('([[:punct:]])|\\s+','+', searchText) 
			#str_replace_all(searchText,"[[:punct:]\\s]+","+")
	#webSearchController$searchTerms <-  URLencode(searchText)
	searchJSONfunction <- get("searchJSON", envir= eval(parse(text=webSearchController[['impl']])))
	webSearchController$searchResults <- searchJSONfunction(webSearchController$searchTerms)
}

webSearchController$getNames = function(){
	#return (names(webSearchController$searchResults))
}

webSearchController$getLength = function(){
	#return (length(webSearchController$searchResults[6][[1]]))
}

webSearchController$printResults = function(){
	#
}

webSearchController$getTopics = function(){
	scraps <- webSearchController$getScrapedData()
	webSearchController$labels <- topicHandler$parse(scraps)
	return(webSearchController$labels)
}

webSearchController$getScrapedData = function(){
	HTMLScraper$setURLs(webSearchController$searchResults)	
	webSearchController$scrapedContent <- HTMLScraper$parse()
	return (webSearchController$scrapedContent)
}

webSearchController$getLabels = function(){
	return (webSearchController$labels)
}