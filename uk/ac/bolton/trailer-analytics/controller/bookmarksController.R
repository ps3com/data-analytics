# TODO: Add comment
# 
# Author: paul
###############################################################################
bookmarksController = new.env()

bookmarksController$rawBookmarks <- NULL
bookmarksController$scrapedContent <- NULL
bookmarksController$labels <- NULL

bookmarksController$getLabels = function(){
	return (bookmarksController$labels)
}

bookmarksController$getScrapedData = function(){	
	bookmarksController$rawBookmarks <- bookmarksController$getBookmarks(userController$user)
	HTMLScraper$setURLs(bookmarksController$rawBookmarks)	
	bookmarksController$scrapedContent <- HTMLScraper$parse()
	return (bookmarksController$scrapedContent)
}

bookmarksController$getTopics = function(){
	scraps <- bookmarksController$getScrapedData()
	bookmarksController$labels <- topicHandler$parse(scraps)
    return(bookmarksController$labels)
}

bookmarksController$getBookmarks = function(user){
	userController$setUser(user)
	return (dbHelper$getInitData(user))
}