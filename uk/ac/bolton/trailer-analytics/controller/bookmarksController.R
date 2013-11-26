# TODO: Add comment
# 
# Author: paul
###############################################################################
bookmarksController = new.env()

bookmarksController$rawBookmarks <- NULL
bookmarksController$scrapedContent <- NULL

bookmarksController$getScrapedData = function(){	
	bookmarksController$rawBookmarks <- bookmarksController$getBookmarks(userController$user)
	HTMLScraper$setURLs(bookmarksController$rawBookmarks)	
	bookmarksController$scrapedContent <- HTMLScraper$parse()
	return (bookmarksController$scrapedContent)
}

bookmarksController$getTopics = function(){
	scraps <- bookmarksController$getScrapedData()
    return(topicHandler$parse(scraps))
}

bookmarksController$getBookmarks = function(user){
	userController$setUser(user)
	return (dbHelper$getInitData(user))
}