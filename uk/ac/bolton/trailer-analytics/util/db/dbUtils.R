# TODO: Add comment
# 
# Author: paul
###############################################################################
dbUtils = new.env()

dbUtils$user <- "scott"
dbUtils$password <- "tiger"
dbUtils$dbname <- "test"
dbUtils$host <- "localhost"

#### Function: dbUtils$initConnection()
#
dbUtils$initConnection = function(username, password, databasename, dbhost){
	dbUtils$user <- username
	dbUtils$password <- password
	dbUtils$dbname <- databasename
	dbUtils$host <- dbhost
}
attr(dbUtils$initConnection, "comment") <- "Sets your mysql db credentials."
attr(dbUtils$initConnection, "help") <- "Args (username, password, databasename, dbhost)."
#
###################################################

dbUtils$runSelectStatement = function(sql){
	mydb = dbConnect(MySQL(), dbUtils$user, password=dbUtils$password, dbname=dbUtils$dbname, host=dbUtils$host)
	query<-paste(sql)
	data.frame = dbGetQuery(mydb,query)
	dbDisconnect(mydb)
	return(data.frame)
}

dbUtils$testConnection = function(){
	return(paste("dbUtils initialised: $user=", dbUtils$user, " $password=", 
					dbUtils$password, " $dbname=", dbUtils$dbname, 
				" $host=", dbUtils$host))
}


