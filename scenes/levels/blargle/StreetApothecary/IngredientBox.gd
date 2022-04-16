# Extends the CoinBox to buy or sell ingredients
extends "res://scripts/boxes/CoinBox.gd"

export var ingredient: String
export var cost: int
export var ingredientChangeAmount: int

func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")

func _process(_delta):
	pass

# use this to update the enabled/disabled based on coin total
func _on_coin_collected(data) -> void:
	var enabled: bool = true
	
	if data.type == "coin":
		if cost < 0:
			print("cost is ", cost)
			print("enabled is ", data.total, " >= ", cost, " (",data.total >= cost,")")
			enabled = data.total >= cost
		else:
			print("cost is < 0")
			print("does player have enough ", ingredient, " to buy ", ingredientChangeAmount, "? ", does_player_have_enough_ingredients(ingredient, ingredientChangeAmount))
			enabled = does_player_have_enough_ingredients(ingredient, ingredientChangeAmount)
		
		if enabled:
			reenable()
		else:
			disable()
	pass
	# EventBus.emit_signal("coin_collected", {"value": delta, "total": inventory.coins, "type": "coin"})

func on_bounce(body: KinematicBody2D):
	print("on bounce")
	if (body is Player
		and does_player_have_enough_ingredients(ingredient, ingredientChangeAmount)
		and does_player_have_enough_coin(body, cost)):
		
		particle_emitter.restart()
		particle_emitter.emitting = true
		audio_coin.play()
		EventBus.emit_signal("update_ingredient_count", {"ingredient": ingredient, "delta": ingredientChangeAmount})

func does_player_have_enough_ingredients(ingredient: String, delta: int) -> bool:
	return StreetApothecary.can_update_ingredient(ingredient, delta)
	
func does_player_have_enough_coin(body: KinematicBody2D, coins: int):
	return CoinInventoryHandle.change_coins_on(body, coins)
