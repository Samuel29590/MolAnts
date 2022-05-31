"
The actual implementation of the TMARoleeType: MARole, describe the role of one stage. The role provides the behavior of an ant at each step. Actually roles are implemented by MAQueen, MAFighter or MAWorker that are subclass of MARole. In each different implementation there is one method: doSimulationStepFor: that manage the action of the ant and one method: moveFrom: that manage the position of the ant at each step.
"
Class {
	#name : #MARole,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMARoleType + TMARoleServices',
	#classTraits : 'MolComponentImpl classTrait + TMARoleType classTrait + TMARoleServices classTrait',
	#category : #MolAnts
}

{ #category : #accessing }
MARole >> getRoleName [

	^ roleName.
]

{ #category : #'component accessing' }
MARole >> getTMARoleEventsNotifier [
	^self eventsNotifiers at: TMARoleEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMARoleEvents name: nil].
]

{ #category : #role }
MARole >> moveFrom: anAnt [
]
