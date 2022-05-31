"
This service is provided by the stage implementation and used by the ant implementation. It describes methods that the stage needs to implement because the ant implementation needs it to work correctly.

Variables :

-stageName, is an symbol used to know the actual stage of the ant: egg or adult.

-role, containing the role associate to the stage. It is used to access to the correct role to do actions and to stop the role component correctly.
"
Trait {
	#name : #TMAStageServices,
	#instVars : [
		'stageName',
		'role'
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
]

{ #category : #testing }
TMAStageServices >> isAlive [
]

{ #category : #role }
TMAStageServices >> moveFrom: anAnt [
]
