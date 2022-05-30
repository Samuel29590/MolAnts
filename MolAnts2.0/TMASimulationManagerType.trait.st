Trait {
	#name : #TMASimulationManagerType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
}

{ #category : #'accessing - events' }
TMASimulationManagerType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
			TMAStageEvents .
		  TMARoleEvents.
		  TMAInsectEvents }
]

{ #category : #'accessing - events' }
TMASimulationManagerType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents }
]

{ #category : #'accessing - services' }
TMASimulationManagerType classSide >> providedComponentServices [
	<componentContract>
	^ {TMASimulationServices} 
]

{ #category : #'accessing - services' }
TMASimulationManagerType classSide >> usedComponentServices [

	<componentContract>
	^ { TMAPheromoneServices }
]
