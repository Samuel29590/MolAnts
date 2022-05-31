"
This service is provided by the role implementation and used by the stage. It describes methods that the role needs to implement because the stage implementation needs it to work correctly.

Variables :

-roleName, is a symbol used to know the role of an ant: queen, fighter or worker.
"
Trait {
	#name : #TMARoleServices,
	#instVars : [
		'roleName'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #MolAnts
}

{ #category : #role }
TMARoleServices >> doSimulationStepFor: anAnt [
]

{ #category : #accessing }
TMARoleServices >> getRoleName [
]

{ #category : #role }
TMARoleServices >> moveFrom: anAnt [
]
