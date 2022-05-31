"
This event is consumed by all the entities of the simulation: ground, ants, insects and pheromones. Thanks to this event, the simulation loop in the simulation thread send at each step of the simulation the simulationStepSent message to all the entities. This permit for each entity of the simulation to do their actions.

This event also provides two messages: pheromoneNew:for: and pheromoneReturnNew:for, that needs to be implemented by the pheromone component. This two messages notify the Pheromone component of a pheromone creation or update.
"
Trait {
	#name : #TMASimulationToGlobalEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolAnts
}

{ #category : #'events - lifecycle' }
TMASimulationToGlobalEvents >> pheromoneNew: aPoint for: anAnt [

	
]

{ #category : #'events - lifecycle' }
TMASimulationToGlobalEvents >> pheromoneReturnNew: aPoint for: anAnt [

	
]

{ #category : #'events - lifecycle' }
TMASimulationToGlobalEvents >> simulationStepSent [

	self doSimulationStep 
]

{ #category : #'events - control' }
TMASimulationToGlobalEvents >> started [

	
]

{ #category : #'events - control' }
TMASimulationToGlobalEvents >> stopped [

	
]
