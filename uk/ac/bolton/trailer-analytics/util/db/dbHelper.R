# TODO: Add comment
# 
# Author: paul
###############################################################################
source('dbUtils.R', chdir=T)

dbHelper = new.env()

dbHelper$init = function(){
	# TODO check that the properties are loaded otherwise flag an error
	dbUtils$initConnection(properties$dbUsername, properties$dbPassword, properties$dbName, properties$dbHost)
}

dbHelper$getInitData = function(tUser){
	sqlSelectStatement <- "SELECT url, title FROM mdl_ilc_activity"
	if(length(tUser) != 0L) {
		sqlSelectStatement <- paste (sqlSelectStatement, " where userToken='", tUser, "'", sep = "")
	}		
	results <- dbUtils$runSelectStatement(sqlSelectStatement)
	return(results)
}


dbHelper$getUserData = function(){
	sqlSelectStatement <- "SELECT DISTINCT userToken FROM mdl_ilc_activity"	
	results <- dbUtils$runSelectStatement(sqlSelectStatement)
	# put into correct format for option box
	uNames <- results$userToken;
	return(uNames)
}
