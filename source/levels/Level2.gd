extends BaseLevel

onready var bossArea : Area2D = $BossArea
onready var boss : Actor = $Actors/AiContainers/Boss/Boss1

func _ready() -> void:
	bossArea.connect("body_entered", self, "_on_body_entered")

func handlePlayerDeath() -> void:
	handleDefeat()

func handleAiDeath(ai) -> void:
	killAi(ai)

func _on_body_entered(_body) -> void:
	_player.hud.addBossHealthBar(boss.stats.health, boss)
	bossArea.queue_free()
