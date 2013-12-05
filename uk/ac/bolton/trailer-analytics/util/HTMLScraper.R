# TODO: Add comment
# 
# Author: paul
###############################################################################
HTMLScraper = new.env()

HTMLScraper$user <- NULL
HTMLScraper$rawBookmarks <- NULL
HTMLScraper$parsedBookmarks <- NULL
HTMLScraper$htmldocuments <- NULL
#
HTMLScraper$linksInIndexPages <- NULL
HTMLScraper$text <- NULL


HTMLScraper$setURLs = function(urls){
	HTMLScraper$rawBookmarks <- urls
}

HTMLScraper$parse <- function(){
	HTMLScraper$cleanBookmarks()
	HTMLScraper$getHTMLFromBookmarks()
	HTMLScraper$getTextFromHTML()
	###
	unlinked <- do.call(c, unlist(HTMLScraper$text, recursive=FALSE))
	textList <- data.frame(unlinked, stringsAsFactors=FALSE)
	colnames(textList) <- "text"
	# remove links, etc
	textList <- as.data.frame(lapply(textList, function(d){gsub("https?://[[:alnum:][:punct:]]+", "", d)}), stringsAsFactors=FALSE)
	# remove punctuation
	textList <- as.data.frame(lapply(textList, function(d){gsub("[,()/.:;'!?\"]", "", d)}), stringsAsFactors=FALSE)
	# remove \n
	textList <- as.data.frame(lapply(textList, function(d){gsub("\n", "", d)}), stringsAsFactors=FALSE)
	# remove \r
	textList <- as.data.frame(lapply(textList, function(d){gsub("\r", "", d)}), stringsAsFactors=FALSE)
	# trim leading and trailing whitepsce
	textList <- as.data.frame(lapply(textList, function(d){stringUtils$trim(d)}), stringsAsFactors=FALSE)
	# anything less than 1 char remove
	textList <- subset(textList, nchar(as.character(textList$text)) > 1)
	# if value is a number then junk
	textList <- subset(textList, suppressWarnings(is.na(as.numeric(textList$text))))
	HTMLScraper$text <- textList
	
	return (HTMLScraper$text)
}



HTMLScraper$cleanBookmarks = function(){
	# remove entries where there the url is empty
	
	remove <- which(HTMLScraper$rawBookmarks$url=="")
	
	if(!identical(remove, integer(0))){
		HTMLScraper$parsedBookmarks <- HTMLScraper$rawBookmarks[-remove,]
	}else{
		HTMLScraper$parsedBookmarks <- HTMLScraper$rawBookmarks
	}
	
	df <- data.frame(url=character(), title=character(), stringsAsFactors=FALSE)
	
	for (i in 1:length(HTMLScraper$parsedBookmarks$url)) {
		if(url.exists(HTMLScraper$parsedBookmarks$url[[i]])){
			cat(paste(HTMLScraper$parsedBookmarks$url[[i]], "exists\n\r",sep=" "))
			df <- rbind(df, HTMLScraper$parsedBookmarks[i,])				
		}
	}
	HTMLScraper$parsedBookmarks <- df
	# remove any entries with NA - sanity check
	#HTMLScraper$parsedBookmarks <- HTMLScraper$parsedBookmarks[!is.na(HTMLScraper$parsedBookmarks)]
	
}

HTMLScraper$getHTMLFromBookmarks = function(){
	HTMLScraper$htmldocuments <- lapply(HTMLScraper$parsedBookmarks$url, 
			function(f){
				x <- try(getURL(f, cainfo = "cacert.pem"))
				#cat(paste("\n\rURL=",f, "result=",x,"\n\r", sep=" "))
				if (inherits(x, "try-error")) NA else x
				y <- try(htmlParse(x))
				if (inherits(y, "try-error")) NA else y		
			}
	)
	# remove any entries with NA - sanity check
	HTMLScraper$htmldocuments <- HTMLScraper$htmldocuments[!is.na(HTMLScraper$htmldocuments)]
}

HTMLScraper$getLinksFromHTML = function(){
	HTMLScraper$linksInIndexPages <- lapply(HTMLScraper$htmldocuments, 
			function(f){
				X <- try(xpathSApply(f, "//a/@href"))
				if (inherits(X, "try-error")) NA else X
			}
	)	
}

HTMLScraper$getTextFromHTML = function(){
	HTMLScraper$text <- lapply(HTMLScraper$htmldocuments,  
			function(f){
				#X <- xpathApply(f, "//body//text()[not(ancestor::a)][not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]", xmlValue)
				X <- xpathApply(f, "//body//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]", xmlValue)
				if (inherits(X, "try-error")) NA else X
			}
	)	
}
