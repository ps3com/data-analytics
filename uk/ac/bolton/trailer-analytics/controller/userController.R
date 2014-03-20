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