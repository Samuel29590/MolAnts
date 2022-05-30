Trait {
	#name : #TMASimulationToGlobalEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'MolAnts-Molecule Contracts'
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

{ #category : #'events - lifecycle' }
TMASimulationToGlobalEvents >> workerEat: anAnt [

	
]
