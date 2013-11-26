# TODO: Add comment
# 
# Author: paul
###############################################################################
userController = new.env()

userController$user <- NULL

userController$setUser = function(user){
	userController$user <- user	
}

userController$getUser = function(){
	return (userController$user)
}

userController$getAllUsers = function(){
	return (dbHelper$getUserData())
}

userController$getRandomUser = function(){
	users <- dbHelper$getUserData()		
	randomNumber <- sample(1:length(users), 1)  
	randomUser <- users[[randomNumber]]
	return (randomUser)
}
