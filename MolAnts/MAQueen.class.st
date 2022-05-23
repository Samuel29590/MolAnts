Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAQueen >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #queen
]

{ #category : #role }
MAQueen >> doSimulationStepFor: anAnt [

	(Random new nextIntegerBetween: 1 and: 30 ) = 1 ifTrue: [ 
		self getTMARoleEventsNotifier queenLaid.
	]
]

{ #category : #role }
MAQueen >> moveFrom: anAnt [

		^ anAnt position.
]
