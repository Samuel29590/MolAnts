Trait {
	#name : #TMAInsectsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
}

{ #category : #'accessing - events' }
TMAInsectsType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents }
]

{ #category : #'accessing - events' }
TMAInsectsType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMAInsectEvents} 
]
