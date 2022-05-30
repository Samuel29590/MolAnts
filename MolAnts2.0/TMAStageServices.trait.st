Trait {
	#name : #TMAStageServices,
	#instVars : [
		'role',
		'stageName'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #MolAnts
}

{ #category : #role }
TMAStageServices >> doSimulationStepFor: anAnt [
]

{ #category : #role }
TMAStageServices >> getRole [
]

{ #category : #role }
TMAStageServices >> getRoleName [

	^ self getTMARoleServicesProvider getRoleName
]

{ #category : #role }
TMAStageServices >> getStageName [

	^stageName ifNil: [ stageName := #egg ].
]

{ #category : #testing }
TMAStageServices >> isAlive [
]

{ #category : #role }
TMAStageServices >> moveFrom: anAnt [
]
