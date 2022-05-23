Trait {
	#name : #TMAStageServices,
	#instVars : [
		'role',
		'stageName'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #role }
TMAStageServices >> doSimulationStepFor: anAnt [
]

{ #category : #role }
TMAStageServices >> getRole [

	^ self getTMARoleServicesProvider 
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
