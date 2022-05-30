Trait {
	#name : #TMAAntServices,
	#instVars : [
		'stage'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #services }
TMAAntServices >> getRoleName [
]

{ #category : #services }
TMAAntServices >> getStage [

	^ self getTMAStageServicesProvider 
]
