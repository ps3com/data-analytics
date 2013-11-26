# TODO: Add comment
# 
# Author: paul
###############################################################################
source('../main.R', chdir=T)

# Define server logic 
shinyServer(function(input, output) {
			
			# show the chosen user in the chosenUserText div
			output$pTitle <- renderText(	
					as.character(properties$appTitle)
			)			
			
			# setup the usersList div to contain all the users obtained from the db			
			output$usersControl <- renderUI(				 
					selectInput("usersList", "Choose a user:", 
							#choices = dbHelper$getUserData()
							choices = userController$getAllUsers()
					)
			)			
			
			# show the chosen user in the chosenUserText div
			output$chosenUserText <- renderText(	
					as.character(input$usersList)
			)
			
			# listen for changes in the option box (created above) and react
			#usersListInput <- reactive({	
			#			browser()
			#	switch(input$usersList, dbHelper$getUserData())
			#})
			
			output$bookmarkDataset <- renderUI({	
						if (!is.null(input$usersList) ) {												
							dataSet <- bookmarksController$getBookmarks(as.character(input$usersList))
							dataSet <- suppressWarnings(as.data.frame(sapply(dataSet, as.character)))	
							toJSON(as.data.frame(t(dataSet)), .withNames=FALSE)
						}else{
							# note - returning the proper NULL object causes the usersList not to render
							return ('null')
						}
					})	
			
			############################ Handle the web search  ##########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search
			getSearchResults <- reactive({
						if (input$goSearch == 0)
							return(NULL)
						isolate({
									
									# todo url encode values in controller
									return (webSearchController$searchJSON(input$searchTerms))								
								})
					})
			
			output$searchResultDataset <- renderUI({
						#dataSet2 <- gen.Results()
						
						#
						dataSet2 <- getSearchResults()
						dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
						toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE)
					})			
			
			
			#############################################################################################
			
			############################ Handle the bookmarks scrape  ###########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search		
			scrapeBookmarks <- reactive({
						if (input$goBookmarkTopics == 0)
							return(NULL)
						isolate({					
									# todo url encode values in controller
									return (bookmarksController$getTopics())								
								})
					})
			
			output$bookmarkTermsDataset <- renderUI({
						#if (input$goBookmarkTopics != 0)
						#	output$bookmarkTermsLegend <- renderText("Searching, please wait")	
						dataSet2 <- scrapeBookmarks()
						dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
						toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE, container = TRUE)
					})			
			
			
			
			#############################################################################################
			
			############################ Handle the web search scrape  ###########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search
			
			scrapeSearchResults <- reactive({
						if (input$goSearchTopics == 0)
							return(NULL)
						isolate({
									# todo url encode values in controller
									return (webSearchController$getTopics())								
								})
					})
			
			output$searchTermsDataset <- renderUI({
						dataSet2 <- scrapeSearchResults()
						dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
						toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE, container = TRUE)
					})			
			
		})

#############################################################################################
