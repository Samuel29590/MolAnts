"
I'm the stage type trait.
"
Trait {
	#name : #TMAStageType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
}

{ #category : #'accessing - events' }
TMAStageType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMAStageEvents }
]

{ #category : #'accessing - services' }
TMAStageType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAStageServices} 
]

{ #category : #'accessing - services' }
TMAStageType classSide >> usedComponentServices [
	<componentContract>
	^ {TMARoleServices}
]
