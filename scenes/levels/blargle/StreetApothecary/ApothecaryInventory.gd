extends CanvasLayer
class_name ApothecaryInventory

export var mushrooms: int = 3

onready var mushroomLabel = $GridContainer/MushroomLabel

signal update_apothecary_inventory(product, amount)

var player_scene = load("res://scenes/Player.tscn")

func _ready():
	print("inventory ready")
	EventBus.connect("update_apothecary_inventory", self, "_update_apothecary_inventory")

func _update_apothecary_inventory(product: String, amount: int) -> void:
	print("update mushroom value")
	print(amount)
	print(mushroomLabel)

	player_scene.inventory.ingredients[product] = amount

	mushroomLabel.text = str(amount)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
