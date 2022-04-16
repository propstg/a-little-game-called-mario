# Attach this as a scene child to your player enable coin collecion
extends BaseInventoryHandle
class_name CoinInventoryHandle

func change_coins(delta: int) -> bool:
	if not can_change_coins(delta):
		return false

	inventory.coins += delta
	EventBus.emit_signal("coin_collected", {"value": delta, "total": inventory.coins, "type": "coin"})
	return true
	
func can_change_coins(delta: int) -> bool:
	return delta == 0 or inventory.coins + delta >= 0

# Try to find an inventory on the node + children and change the coins. Returns true when successful.
static func change_coins_on(node: Node2D, coin_delta: int) -> bool:
	var node_to_use = find_node_to_use(node)
	print(node_to_use)
	if node_to_use != null:
		return node_to_use.change_coins(coin_delta)
	
	return false

# Just check to see if coins can be deducted from inventory. Returns true when change_coins_on would succeed.
static func can_change_coins_on(node: Node2D, coin_delta: int) -> bool:
	var node_to_use = find_node_to_use(node)
	if node_to_use:
		return node_to_use.can_change_coins(coin_delta)
	
	return false

# Try to find an inventory on the node + children
static func find_node_to_use(node: Node2D) -> Node2D:
	# operator 'is' has a bug and causes dependency cycle, use 'as' instead
	if node as CoinInventoryHandle:
		return node
		
	for child in node.get_children():
		if child as CoinInventoryHandle:
			return child
			
	return null
