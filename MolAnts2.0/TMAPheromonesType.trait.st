Trait {
	#name : #TMAPheromonesType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
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
