extends Node

func applyDamage(target : Actor, damage : float) -> void:
	var modifier : AttributeModifier = AttributeModifier.new(-damage, 0)
	target.stats.addHealth(modifier)

func applyKnockbackFromExplosion(target : Actor, explosionCenter : Vector2, impactPoint : Vector2, explosionRadius : float, knockbackForce : float, damage : float) -> void:
	var distanceExplosionCenterToImpactPoint : float = explosionCenter.distance_to(impactPoint)
	var knockbackDirection : Vector2 = ( target.global_position - explosionCenter ).normalized()
	var explosionCoefficient : float = (1 - distanceExplosionCenterToImpactPoint / explosionRadius)
	target.velocity += knockbackDirection * knockbackForce * explosionCoefficient
	damage = damage * explosionCoefficient
	applyDamage(target, damage)
