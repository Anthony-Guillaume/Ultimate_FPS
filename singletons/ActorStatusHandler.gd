extends Node

func applyDamage(target : Actor, damage : float) -> void:
	var modifier : AttributeModifier = AttributeModifier.new(-damage, 0)
	target.stats.addHealth(modifier)

func applyKnockbackFromExplosion(target : Actor, explosionCenter : Vector2, explosionRadius : float, knockbackForce : float, damage : float) -> void:
	var distanceExplosionCenterToTarget : float = explosionCenter.distance_to(target.global_position)
	var knockbackDirection : Vector2 = ( target.global_position - explosionCenter ).normalized()
	target.velocity += knockbackDirection * knockbackForce * (1 - distanceExplosionCenterToTarget / explosionRadius)
	damage = damage * (1 - distanceExplosionCenterToTarget / explosionRadius)
	applyDamage(target, damage)
