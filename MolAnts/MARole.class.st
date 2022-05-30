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
