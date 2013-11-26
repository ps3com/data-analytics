# TODO: Add comment
# 
# Author: paul
###############################################################################

stringUtils = new.env()

stringUtils$trim = function(x){
	gsub("^\\s+|\\s+$", "", x)
}

stringUtils$substrRight <- function(x, n){
	substr(x, nchar(x)-n+1, nchar(x))
}

