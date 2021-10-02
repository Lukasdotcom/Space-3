extends Node

export(Dictionary) var preferences: = {
	"player" : {
		"brake" : -600,
		"accelerate" : 600,
		"rotation" : 2,
		"reload" : 1000
	},
	"enemy" : {
		"brake" : -500,
		"accelerate" : 500,
		"rotation" : 1.7,
		"reload" : 1200,
		"reloadConsistency" : 100
	},
	"friction" : 0.2,
	"bullet" : {
		"speed" : 700
	}
}

