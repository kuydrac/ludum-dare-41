extends Node

const weapon1 = preload("res://scenes/Weapon1.tscn")
const weapon2 = preload("res://scenes/Weapon2.tscn")
const dark_red_color = Color(0.5, 0, 0)
const red_color = Color(1.0, 0, 0)
const black_color = Color(0, 0, 0) 
var cur_weapon
var cards = Array()
var poker_hand_idx = Array()
var hand = {
	"type": "Empty",
	"power": 1,
	"color": dark_red_color}
var player_owned = false
signal no_cards

class Card:
	var rank
	var suit
	func print():
		print("%d%s" % [rank, suit])

class MyCardSorter:
	static func sort(a, b):
		if a.rank < b.rank:
			return true
		return false

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func reset():
	cards = Array()
	poker_hand_idx = Array()
	hand = {
		"type": "Empty",
		"power": 1,
		"color": dark_red_color}
	update_hand()
	update_weapon()

func add_card_by_rank_suit(rank, suit):
	var card = Card.new()
	card.rank = rank
	card.suit = suit
	add_card(card)

func check_same_card(card):
	for c in cards:
		if c.rank == card.rank and c.suit == card.suit:
			return true
	return false

func add_card(card):
	if !check_same_card(card):
		if cards.size() == 5:
			cards.pop_front()
		cards.append(card)
		update_hand()
		update_weapon()

func remove_card():
	if cards.size() == 0:
		emit_signal("no_cards")
	else:
		cards.pop_front()
		update_hand()
		update_weapon()

func check_straight(ordered_cards):
	if ordered_cards[0].rank == ordered_cards[1].rank - 1 and \
		ordered_cards[1].rank == ordered_cards[2].rank - 1 and \
		ordered_cards[2].rank == ordered_cards[3].rank - 1 and \
		ordered_cards[3].rank == ordered_cards[4].rank - 1:
			poker_hand_idx = [0, 1, 2, 3, 4]
			return true
	return false

func check_flush(ordered_cards):
	if ordered_cards[0].suit == ordered_cards[1].suit and \
		ordered_cards[1].suit == ordered_cards[2].suit and \
		ordered_cards[2].suit == ordered_cards[3].suit and \
		ordered_cards[3].suit == ordered_cards[4].suit:
			poker_hand_idx = [0, 1, 2, 3, 4]
			return true
	return false

func find_cards_with_value(rank):
	var idxs = Array()
	for i in range(cards.size()):
		if rank == cards[i].rank:
			idxs.append(i)
	return idxs

func check_duplicates(ordered_cards):
	var counts = {}
	var duplicates = Array()
	for card in ordered_cards:
		if !(card.rank in counts):
			counts[card.rank] = 1
		else:
			counts[card.rank] += 1
	for rank in counts:
		if counts[rank] > 1:
			duplicates.append(counts[rank])
			poker_hand_idx += find_cards_with_value(rank)
	
	# if no duplicates, find high single
	if duplicates.size() == 0:
		var high_card = 1
		for card in ordered_cards:
			if card.rank > high_card:
				high_card = card.rank
		poker_hand_idx += find_cards_with_value(high_card)
	return duplicates

func get_poker_hand_power():
	var high_value = 1
	for i in poker_hand_idx:
		if cards[i].rank > high_value:
			high_value = cards[i].rank
	return high_value

func fix_full_house_power():
	var counts = {}
	for card in cards:
		if !(card.rank in counts):
			counts[card.rank] = 1
		else:
			counts[card.rank] += 1
			if counts[card.rank] == 3:
				return card.rank

func get_poker_hand_color():
	var color_black = false
	var color_red = false
	for i in poker_hand_idx:
		if cards[i].suit == "S" or cards[i].suit == "C":
			color_black = true
		elif cards[i].suit == "D" or cards[i].suit == "H":
			color_red = true
	if color_black and color_red:
		return dark_red_color
	if color_black:
		return black_color
	if color_red:
		return red_color
	
func update_hand():
	poker_hand_idx = Array()
	# Check for empty hand
	if cards.size() == 0:
		hand = {
			"type": "Empty",
			"power": 1,
			"color": dark_red_color}
		return
		
	var ordered_cards = cards.duplicate()
	ordered_cards.sort_custom(MyCardSorter,"sort")
	var flush = false
	var straight = false
	var duplicates = Array()
	#Check for 5 card hands straight and flush
	if cards.size() == 5:
		straight = check_straight(ordered_cards)
		flush = check_flush(ordered_cards)
	# Check for pairs, 3 of a kind, 4 of a kind
	duplicates = check_duplicates(ordered_cards)
	
	hand.power = get_poker_hand_power()
	hand.color = get_poker_hand_color()
	
	# Royal Flush
	if flush and straight and ordered_cards[4].rank == 14:
		hand.type = "Royal Flush"
		return
	# Straight Flush
	if flush and straight:
		hand.type = "Straight Flush"
		return
	if duplicates.size() > 0:
		# 4 of a kind
		if duplicates[0] == 4:
			hand.type = "Four of a Kind"
			return
		# Full house
		if duplicates.size() == 2:
			if (duplicates[0] == 3 and duplicates[1] == 2) or \
				(duplicates[0] == 2 and duplicates[1] == 3):
					hand.type = "Full House"
					hand.power = fix_full_house_power()
					return
	# Flush
	if flush:
		hand.type = "Flush"
		return
	# Straight
	if straight:
		hand.type = "Straight"
		return
	if duplicates.size() > 0:
		# Three of a kind
		if duplicates[0] == 3:
			hand.type = "Three of a Kind"
			return
		if duplicates.size() == 2:
			hand.type = "2 Pairs"
			return
		if duplicates[0] == 2:
			hand.type = "A Pair"
			return
	hand.type = "Single"
	
func update_weapon():
	if cur_weapon:
		cur_weapon.queue_free()
	match(hand.type):
		"Empty":
			cur_weapon = weapon1.instance()
		"Single":
			cur_weapon = weapon1.instance()
		"A Pair":
			cur_weapon = weapon2.instance()
		_:
			cur_weapon = weapon1.instance()
	add_child(cur_weapon)
	cur_weapon.weapon_color = hand.color
	cur_weapon.set_power(hand.power)
	if player_owned:
		cur_weapon.set_player_owned()

func fire_weapon():
	if cur_weapon:
		cur_weapon.fire()

func set_position(pos):
	var new_pos = pos
	match(cur_weapon.name):
		"Weapon1":
			new_pos.y -= 16
		_:
			new_pos.y -= 16
	cur_weapon.set_position(new_pos)

func get_weapon_color():
	return cur_weapon.weapon_color