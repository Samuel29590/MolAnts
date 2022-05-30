Trait {
	#name : #TMAInsectsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
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
