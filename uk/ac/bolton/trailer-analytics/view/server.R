# TODO: Add comment
# 
# Author: paul
###############################################################################
source('../main.R', chdir=T)

# Define server logic 
shinyServer(function(input, output) {
			
			bookmarkButtonCount <- 0;
			
			############################ Handle the bookmarks scrape  ###########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search		
			scrapeBookmarks <- reactive({
						if (input$goBookmarkTopics == 0)
							return(NULL)
						isolate({	
							output$bookmarkPlot <- renderPlot({
								#wordcloud(topicHandler$labels, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
								#wordcloud(topicHandler$labels, scale=c(8,.2),min.freq=1, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
								wordcloud(bookmarksController$getLabels(), scale=c(3,.2), min.freq=1, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
							})										
						return (bookmarksController$getTopics())			###@@@@@					
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
			
			
			############################ Handle getting bookmarks  ######################################
			# reactive function to check that the search button was pressed before
			# actually doing the search
			getBookmarkResults <- reactive({
						#if (input$getBookmarks == 0)
						if(bookmarkButtonCount == input$getBookmarks){
							cat(paste("A:",input$getBookmarks,bookmarkButtonCount,"\n",sep=" "))
							return(NULL)
						}
						isolate({
									bookmarkButtonCount <- input$getBookmarks
									cat(paste("B:",input$getBookmarks,bookmarkButtonCount,"\n",sep=" "))
									return (bookmarksController$getBookmarks(input$userId, input$tTag))									
								})
					})
			
			output$bookmarkDataset <- renderUI({
						out <- tryCatch(
								{
									cat(paste("*",input$userId, ":", input$tTag,"*\n",sep=""))
									dataSet2 <- getBookmarkResults()
									dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
									toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE)
								},
								error=function(cond) {
									eMessage <- paste("Cannot create url with args", input$userId, input$tTag, sep=" ")
									return(paste('{"APPERROR": "',eMessage, '"}' ,sep=""))
								},
								warning=function(cond) {
									message("Here's the original warning message:")
									message(cond)
									# Choose a return value in case of warning
									return(NULL)
								},
								finally={
									
								}
						)    
						return(out)
						
					})						
			
			

			
			#############################################################################################
			
			
			############################ Handle the web search  ##########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search
			getSearchResults <- reactive({
						if (input$goSearch == 0){
							cat(paste("1 inputGoSearch=",input$goSearch,"*\n",sep=""))
							return(NULL)
						}
						isolate({
									cat(paste("2 inputGoSearch=",input$goSearch,"*\n",sep=""))
									#cat(paste("<",input$searchTerms,">\n",sep=""))
									# todo url encode values in controller
									return (webSearchController$searchJSON(input$searchTerms))									
								})
					})
			
			output$searchResultDataset <- renderUI({
						cat(paste("*",input$searchTerms,"*\n",sep=""))
						dataSet2 <- getSearchResults()
						dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
						toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE)
					})			
			
			
			#############################################################################################			
			
			############################ Handle the web search scrape  ###########################################
			
			# reactive function to check that the search button was pressed before
			# actually doing the search
			
			scrapeSearchResults <- reactive({
						if (input$goSearchTopics == 0)
							return(NULL)
						isolate({
									output$searchPlot <- renderPlot({
												wordcloud(webSearchController$getLabels(), scale=c(3,.2), min.freq=1, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
											})	
									return (webSearchController$getTopics())								
								})
					})
			
			output$searchTermsDataset <- renderUI({
						dataSet2 <- scrapeSearchResults()
						dataSet2 <- suppressWarnings(as.data.frame(sapply(dataSet2, as.character)))
						toJSON(as.data.frame(t(dataSet2)), .withNames=FALSE, container = TRUE)
					})			
		
		

			#output$bookmarkPlot <- renderPlot({
		#		wordcloud(topicHandler$labels, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
		#	})
#############################################################################################



})