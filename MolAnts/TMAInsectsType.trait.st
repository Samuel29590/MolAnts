"
I'm the insect type trait.
"
Trait {
	#name : #TMAInsectsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
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
