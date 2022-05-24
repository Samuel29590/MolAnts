Trait {
	#name : #TMASimulationManagerType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
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
