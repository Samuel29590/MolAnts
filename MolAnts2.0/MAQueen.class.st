Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAQueen >> componentInitialize [

	"Initialization of the MAQueen component."

	roleName := #queen
]

{ #category : #role }
MAQueen >> doSimulationStepFor: anAnt [

	"A queen as 33% of chance to laid at each step."

	(Random new nextIntegerBetween: 1 and: 3) = 1 ifTrue: [ 
		self getTMARoleEventsNotifier queenLaid ]
]

{ #category : #role }
MAQueen >> moveFrom: anAnt [

	"A queen don't move."

	^ anAnt position
]
