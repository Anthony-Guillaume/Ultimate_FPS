extends Object

class_name GoapAgent

var sm
var planner #: GoapPlanner
var availableActions : Dictionary
var currentActions : Dictionary

# IGoap dataProvider; // this is the implementing class that provides our world data and listens to feedback on planning



func get_class() -> String: 
   return "GoapAgent"
