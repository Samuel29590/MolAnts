"
I'm the pheromone type trait.
"
Trait {
	#name : #TMAPheromonesType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
}

{ #category : #'accessing - events' }
TMAPheromonesType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents }
]

{ #category : #'accessing - services' }
TMAPheromonesType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAPheromoneServices} 
]
