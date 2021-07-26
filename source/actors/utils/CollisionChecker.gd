extends Object

class_name CollisionChecker

# static func canFall(spaceState : Physics2DDirectSpaceState, agent : Actor) -> bool:
#     var from : Vector2 = agent.global_position + Vector2(agent.width * 1.5, 0.0) * runDirection
#     var to : Vector2 = from + Vector2(0.0, hitboxHalfHeight + 30.0)
#     var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer())
#     return collisionInfo.empty()

# static func isPlayerOnSamePlatform(spaceState : Physics2DDirectSpaceState) -> bool:
#     return isPlayerIsInSamePlatformRightSide(spaceState) or isPlayerIsInSamePlatformLeftSide(spaceState)

# static func isPlayerIsInSamePlatformRightSide(spaceState : Physics2DDirectSpaceState) -> bool:
#     var from : Vector2 = global_position
#     var to : Vector2 = from + Vector2.RIGHT * sightDistance
#     var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
#     return not collisionInfo.empty() and collisionInfo.collider == player

# static func isPlayerIsInSamePlatformLeftSide(spaceState : Physics2DDirectSpaceState) -> bool:
#     var from : Vector2 = global_position
#     var to : Vector2 = from + Vector2.LEFT * sightDistance
#     var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
#     return not collisionInfo.empty() and collisionInfo.collider == player

# static func isPlayerInSight(spaceState : Physics2DDirectSpaceState) -> bool:
#     return isFacingPlayer() and isPlayerInsideDistance(sightDistance) and isRaycastIntersectPlayer()

# static func isRaycastIntersectPlayer(spaceState : Physics2DDirectSpaceState) -> bool:
#     var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, player.global_position, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
#     return not collisionInfo.empty() and collisionInfo.collider == player

# static func isPlayerInsideDistance(distance : float) -> bool:
#     return player.global_position.distance_to(global_position) < distance
    
# static func isFacingPlayer() -> bool:
#     var playerSide : int = int(sign((player.global_position - global_position).x))
#     return playerSide == runDirection