
$prompt:=Request:C163("What is your current activity (for example: in a meeting, at the beach, coffee break, etc...)?")

cs:C1710.User.me.activity:=$prompt
cs:C1710.UserHub.me.refresh()
