extends Node

export(Dictionary) var preferences: = {
	"player" : {
		"brake" : -600,
		"accelerate" : 600,
		"rotation" : 2,
		"reload" : 1000
	},
	"enemy" : {
		"AI" : [
			{
				"action" : "accelerate",
				"strength" : 1,
				"time" : 3000,
				"variance" : 100
			},
			{
				"action" : "brake",
				"strength" : 0,
				"time" : 1000,
				"variance" : 100
			}
		],
		"brake" : -500,
		"accelerate" : 500,
		"rotation" : 1.7,
		"reload" : 1200,
		"reloadConsistency" : 100
	},
	"friction" : 0.2,
	"scale" : 1,
	"bullet" : {
		"speed" : 700
	}
}

