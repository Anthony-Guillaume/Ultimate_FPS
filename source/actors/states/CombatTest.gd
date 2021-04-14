extends Reference

class_name CombatTest

func get_class() -> String:
    return "CombatTest"

var sm

func _ready() -> void:
    var states : Dictionary = { "SHOOTING" : State.new(self, "", "", "handlePatrolling"),
                                "PURSUING" : State.new(self, "", "", "handleCombatting"),
                                "OBSERVING" : State.new(self, "", "", "handleReloading"),
                                "PATROLLING" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
    sm.setStates(states)
    sm.startWithState("PATROLLING")
    sm.changeState("COMBATTING")

func shoot() -> void:
    pass

func handlePatrolling(delta : float) -> void:
    pass

func handlePursuing(delta : float) -> void:
    pass

func handleObserving(delta : float) -> void:
    pass
    # wait timer for n secondes (3s ?) before patrolling, unless player is seen

    # cas d'une platforme aérienne
# func pursue(target : Actor) -> void:
#     if target in range and raycast OK
#         return
#     if target not in sight and below
#         go to extrem platform then observe
#     if target not in sight and above
#         observe
#         go to extrem platform then observe
#     if target out of range
#         advance
#     if target take portal # les cas ci-dessus devraient pouvoir le gérer

#     if change platforme cause of knockback
#         observe
