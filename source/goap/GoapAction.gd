extends Object

class_name GoapAction

var preconditons : Dictionary
var effects : Dictionary
var inRange : bool
var cost : float
var target

func get_class() -> String: 
   return "GoapAction"

#Reset any variables that need to be reset before planning happens again.
func reset() -> void:
    pass

#Is the action done?
func isDone() -> bool:
    return false

#Procedurally check if this action can run. Not all actions
#will need this, but some might.

func checkPrecondition(_agent) -> bool:
    return false

#Run the action.
#Returns True if the action performed successfully or false
#if something happened and it can no longer perform. In this case
#the action queue should clear out and the goal cannot be reached.
func perform(_agent) -> void:
    pass