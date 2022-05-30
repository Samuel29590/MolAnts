Trait {
	#name : #TMARoleType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts2.0'
}

{ #category : #'accessing - events' }
TMARoleType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMARoleEvents} 
]

{ #category : #'accessing - services' }
TMARoleType classSide >> providedComponentServices [
	<componentContract>
	^ {TMARoleServices} 
]
