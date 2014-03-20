# TODO: Add comment
# 
# Author: paul
###############################################################################
bookmarksController = new.env()

bookmarksController$rawBookmarks <- NULL
bookmarksController$scrapedContent <- NULL
bookmarksController$labels <- NULL
bookmarksController$searchTopic <- NULL

bookmarksController$getLabels = function(){
	return (bookmarksController$labels)
}

bookmarksController$getScrapedData = function(){	
	HTMLScraper$setURLs(bookmarksController$rawBookmarks)	
	bookmarksController$scrapedContent <- HTMLScraper$parse()
	return (bookmarksController$scrapedContent)
}

bookmarksController$getTopics = function(){
	scraps <- bookmarksController$getScrapedData()
	bookmarksController$labels <- topicHandler$parse(scraps)
    return(bookmarksController$labels)
}

bookmarksController$getBookmarks = function(userId, tag){
	userController$setUser(userId)
	bookmarksController$searchTopic <- gsub('([[:punct:]])|\\s+','+', tag)
	cat(bookmarksController$searchTopic)
	bookmarksController$rawBookmarks <- deliciousAPIUtils$searchJSON(userId, tag)
	return(bookmarksController$rawBookmarks)
}