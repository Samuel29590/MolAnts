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
