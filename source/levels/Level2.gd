extends BaseLevel

onready var bossArea : Area2D = $BossArea
onready var boss : Actor = $Actors/AiContainers/Boss/Boss1

func _ready() -> void:
	bossArea.connect("body_entered", self, "_on_body_entered")
	boss.activate(false)

func handlePlayerDeath() -> void:
	handleDefeat()

func handleAiDeath(ai) -> void:
	killAi(ai)
	if ai == boss:
		handleVictory()

func _on_body_entered(_body) -> void:
	_player.hud.addBossHealthBar(boss.stats.health, boss)
	bossArea.queue_free()
	boss.activate(true)
