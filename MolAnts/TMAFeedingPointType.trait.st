"
I'm the feeding points type trait.
"
Trait {
	#name : #TMAFeedingPointType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
}

{ #category : #'accessing - services' }
TMAFeedingPointType classSide >> providedComponentServices [

	<componentContract>
	^ { TMAFeedingPointServices }
]
