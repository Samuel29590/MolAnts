Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #role }
MAFighter >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #fighter
]

{ #category : #role }
MAFighter >> doSimulationStepFor: anAnt [

	"| antRectangle insectsList |
	
	antRectangle := BlBounds origin: ((anAnt position) - (10@10)) extent: (20@20).
	
	insectsList := anAnt getInsects.
	
	insectsList keysDo: [ :each | | insectRectangle |
		insectRectangle := BlBounds origin: (each) extent: (0@0).
		(antRectangle intersects: insectRectangle) ifTrue: [
			self getTMARoleEventsNotifier ant: anAnt eatAt: each. 
		].
	]."
]

{ #category : #role }
MAFighter >> moveFrom: anAnt [

	| newPos AntHillPos |
	
	newPos := anAnt position + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)).
	AntHillPos := MASimulationManager simulationAntHillPosition.
		
	(newPos x < (AntHillPos x - 50)) ifTrue: [
		newPos := (AntHillPos x - 50)@(newPos y)
	].
	(newPos y < (AntHillPos y - 50)) ifTrue: [
		newPos := (newPos x)@(AntHillPos y - 50)
	].
	(newPos x > (AntHillPos x + 50)) ifTrue: [
		newPos := (AntHillPos x + 50)@(newPos y)
	].
	(newPos y > (AntHillPos y + 50)) ifTrue: [ 
		newPos := (newPos x)@(AntHillPos y + 50)
	].

	self getTMARoleEventsNotifier positionChanged: newPos for: anAnt.
	^ newPos.
]
