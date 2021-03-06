# TODO: Add comment
# 
# Author: paul
###############################################################################
topicHandler = new.env()
topicHandler$labels <- NULL
topicHandler$words <- NULL
topicHandler$topic_docs <- NULL
topicHandler$documents <- NULL
topicHandler$df3m <- NULL

topicHandler$parse <- function(scraps){
	#documents <- data.frame(text = bookmarksController$text[,1],
	#		id =   make.unique(bookmarksController$text[,1]),
	#		class = bookmarksController$text[,1], 
	#		stringsAsFactors=FALSE)
	
	
	documents <- data.frame(text = scraps$text,
			id =   make.unique(scraps$text),
			class = scraps$text, 
			stringsAsFactors=FALSE)
	
	#mallet.instances <- mallet.import(documents$id, documents$text, "D:/mallet-2.0.7/stoplists/en.txt", token.regexp = "\\p{L}[\\p{L}\\p{P}]+\\p{L}")
	mallet.instances <- mallet.import(documents$id, documents$text, "en.txt", token.regexp = "\\p{L}[\\p{L}\\p{P}]+\\p{L}")
	
	## Create a topic trainer object.
	n.topics <- 30
	topic.model <- MalletLDA(n.topics)
	
	## Load our documents. We could also pass in the filename of a 
	##  saved instance list file that we build from the command-line tools.
	topic.model$loadDocuments(mallet.instances)
	
	## Get the vocabulary, and some statistics about word frequencies.
	##  These may be useful in further curating the stopword list.
	vocabulary <- topic.model$getVocabulary()
	word.freqs <- mallet.word.freqs(topic.model)
	
	## Optimize hyperparameters every 20 iterations, 
	##  after 50 burn-in iterations.
	topic.model$setAlphaOptimization(20, 50)
	
	## Now train a model. Note that hyperparameter optimization is on, by default.
	##  We can specify the number of iterations. Here we'll use a large-ish round number.
	topic.model$train(200)
	
	## NEW: run through a few iterations where we pick the best topic for each token, 
	##  rather than sampling from the posterior distribution.
	topic.model$maximize(10)
	
	## Get the probability of topics in documents and the probability of words in topics.
	## By default, these functions return raw word counts. Here we want probabilities, 
	##  so we normalize, and add "smoothing" so that nothing has exactly 0 probability.
	doc.topics <- mallet.doc.topics(topic.model, smoothed=T, normalized=T)
	topic.words <- mallet.topic.words(topic.model, smoothed=T, normalized=T)
	
	# from http://www.cs.princeton.edu/~mimno/R/clustertrees.R
	## transpose and normalize the doc topics
	topic.docs <- t(doc.topics)
	topic.docs <- topic.docs / rowSums(topic.docs)
	
	## Get a vector containing short names for the topics
	topics.labels <- rep("", n.topics)
	for (topic in 1:n.topics) topics.labels[topic] <- paste(mallet.top.words(topic.model, topic.words[topic,], num.top.words=5)$words, collapse=" ")
	# have a look at keywords for each topic
	
	
	# create data.frame with columns as authors and rows as topics
	topicHandler$topic_docs <- data.frame(topic.docs)
	names(topicHandler$topic_docs) <- documents$id
	
	topicHandler$documents <- documents
	topicHandler$labels <- topics.labels
	topicHandler$words <- topic.words
	
	return (topics.labels)
}