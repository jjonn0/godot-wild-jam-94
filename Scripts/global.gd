class_name Global extends Node

enum CARD_TYPE{A, C, G, T}

const A_CARD_COLOR : Color = Color(0.743, 0.608, 0.99, 1.0)
const C_CARD_COLOR : Color = Color(0.604, 0.99, 0.649, 1.0)
const G_CARD_COLOR : Color = Color(0.99, 0.829, 0.604, 1.0)
const T_CARD_COLOR : Color = Color(0.604, 0.791, 0.99, 1.0)

## How many cards are drawn every Gene Editor Phase
var cards_drawn : int = 4
## How many pairs the creature is allowed.
var dna_strand_pairs : int = 2
var card_manager : CardManager
var dna_cards : Array[GeneCard] = []
var music_manager : MusicManager
