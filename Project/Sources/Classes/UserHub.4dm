//The UserHub is the main class handling the list of connected users
//Any process can add or remove users from its Collection by calling the appropriate shared functions

property userList : Collection  //Collection of all the users
property currentUserId : Integer  //Id of the current user (so all users get a different id)

//shared singleton keywords mean it's an application wide singleton
shared singleton Class constructor()
	
	This:C1470.currentUserId:=0
	This:C1470.userList:=New shared collection:C1527()
	
	//The shared keyword is equivalent to use/end use
shared Function newUser()
	If (cs:C1710.User.me._id=-1)
		This:C1470.currentUserId+=1
		cs:C1710.User.me.id:=This:C1470.currentUserId
		This:C1470.userList.push(cs:C1710.User.me)
		This:C1470.sortList()
	End if 
	
shared Function removeUser()
	
	cs:C1710.User.me.disconnectedTime:=Tickcount:C458
	This:C1470.sortList()
	
	//The exposed keyword allows Qodly to call this function
exposed shared Function connect()
	
	This:C1470.newUser()
	
	//The exposed keyword allows Qodly to call this function
exposed shared Function disconnect()
	
	This:C1470.removeUser()
	
shared Function refresh()
	
	This:C1470.userList:=This:C1470.userList
	
shared Function sortList()
	
	This:C1470.userList.sort("SortByDate")
	
	While ((This:C1470.userList.last()#Null:C1517) && (This:C1470.userList.last()._disconnectedTime>0) && (Tickcount:C458>(This:C1470.userList.last()._disconnectedTime+(60*60))))
		This:C1470.userList.pop()
	End while 
	
	//The exposed keyword allows Qodly to call this function
exposed shared Function getUserList()->$userList : Collection
	
	This:C1470.sortList()
	
	$userList:=New collection:C1472()
	For each ($item; This:C1470.userList)
		$user:=New object:C1471("_disconnectionTime"; $item._disconnectionTime; "_id"; $item._id; "_statusName"; $item._statusName; "_name"; $item._name; "_activity"; $item._activity)
		$userList.push($user)
	End for each 
	
	//The exposed keyword allows Qodly to call this function
exposed shared Function changeCurrentUserName($name : Text)
	
	cs:C1710.User.me.name:=$name
	
exposed shared Function changeCurrentUserActivity($activity : Text)
	
	cs:C1710.User.me.activity:=$activity