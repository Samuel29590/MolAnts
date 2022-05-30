Trait {
	#name : #TMAGroundType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
}

{ #category : #'accessing - events' }
TMAGroundType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents }
]

{ #category : #'accessing - services' }
TMAGroundType classSide >> usedComponentServices [
	<componentContract>
	^ {TMAPheromoneServices . TMASimulationServices}
]
