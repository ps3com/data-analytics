# TODO: Add comment
# 
# Author: paul
###############################################################################
source('libraries.R')
source('properties.R')
source('util/db/dbHelper.R', chdir=T)
source('util/stringUtils.R', chdir=T)
source('util/HTMLScraper.R', chdir=T)
source('util/topicHandler.R')
source('controller/userController.R', chdir=T)
source('controller/webSearchController.R', chdir=T)
source('controller/bookmarksController.R', chdir=T)

main = new.env()

main$init = function(){
	properties$init()
	dbHelper$init()
	webSearchController$init()
}

# auto start
main$init()