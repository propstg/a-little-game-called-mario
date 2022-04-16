extends Node2D
class_name StreetApothecary

const ingredients: Dictionary = {
	"mushroom": 99,
	"corn": 99,
	"cactus": 99,
	"soup": 99,
}
var ingredient_labels: Dictionary

func _ready() -> void:
	_init_labels()
	_reset()
	_connect_handlers()

func _init_labels() -> void:
	ingredient_labels["mushroom"] = $ApothecaryInventory/GridContainer/MushroomValue
	ingredient_labels["corn"] = $ApothecaryInventory/GridContainer/CornValue
	ingredient_labels["cactus"] = $ApothecaryInventory/GridContainer/CactusValue
	ingredient_labels["soup"] = $ApothecaryInventory/GridContainer/SoupValue
	
func _connect_handlers() -> void:
	EventBus.connect("update_ingredient_count", self, "_on_update_ingredient_count")
	EventBus.connect("player_died_softly", self, "_on_player_died_softly")

static func can_update_ingredient(ingredient: String, delta: int) -> bool:
	var ingredientCount = ingredients[ingredient]
	print(ingredient, ingredientCount)
	return ingredientCount + delta >= 0


func _reset() -> void:
	CoinInventoryHandle.change_coins_on(self, 10)
	_reset_ingredient_counts()

func _reset_ingredient_counts() -> void:
	for ingredient in ingredients:
		_update_ingredient_count(ingredient, 0)

func _on_update_ingredient_count(data) -> void:
	_update_ingredient_count(data.ingredient, data.delta)

func _update_ingredient_count(ingredient: String, delta: int) -> void:
	if delta == 0:
		ingredients[ingredient] = 0
	else:
		ingredients[ingredient] += delta
	ingredient_labels[ingredient].text = str(ingredients[ingredient])

func _process(_delta) -> void:
	pass

func _on_player_died_softly() -> void:
	print("player died softly")
	# TODO teleport to end game
	# TODO stop timer
