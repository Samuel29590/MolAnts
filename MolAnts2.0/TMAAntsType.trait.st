Trait {
	#name : #TMAAntsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
}

{ #category : #'accessing - events' }
TMAAntsType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents }
]

{ #category : #'accessing - services' }
TMAAntsType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAAntServices } 
]

{ #category : #'accessing - services' }
TMAAntsType classSide >> usedComponentServices [
	<componentContract>
	^ {TMAStageServices . TMASimulationServices}
]
