"
I'm the actual implementation of the fighter role.
"
Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #MolAnts
}

{ #category : #role }
MAFighter >> componentInitialize [

	"Initialization of the MAFighter component."
	roleName := #fighter
]

{ #category : #role }
MAFighter >> doSimulationStepFor: anAnt [

	"For the moment fighter don't do nothing."

	| antRectangle |
	antRectangle := BlBounds
		                origin: anAnt position - (6 @ 6)
		                extent: 12 @ 12.

	anAnt getInsects keysDo: [ :each | 
		| insectRectangle |
		insectRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: insectRectangle) ifTrue: [ 
			self getTMARoleEventsNotifier ant: anAnt killAt: each ] ]
]

{ #category : #role }
MAFighter >> moveFrom: anAnt [

	"A Fighter move randomly around the ant hill."

	| newPos antHillPos |
	newPos := anAnt position + ((Random new next * 10 - 5) rounded
	           @ (Random new next * 10 - 5) rounded).
	antHillPos := MASimulationManager simulationAntHillPosition.

	newPos x < (antHillPos x - 50) ifTrue: [ 
		newPos := antHillPos x - 50 @ newPos y ].
	newPos y < (antHillPos y - 50) ifTrue: [ 
		newPos := newPos x @ (antHillPos y - 50) ].
	newPos x > (antHillPos x + 50) ifTrue: [ 
		newPos := antHillPos x + 50 @ newPos y ].
	newPos y > (antHillPos y + 50) ifTrue: [ 
		newPos := newPos x @ (antHillPos y + 50) ].

	^ newPos
]
