Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#instVars : [
		'phase',
		'oldPositions'
	],
	#category : #'MolAnts-Model'
}

{ #category : #position }
MAWorker >> avoidPheromones: aPheromoneOrderedCollection for: anAnt [
	
	| newPos onTop onLeft randomPheromone |
				
	randomPheromone := Random new nextIntegerBetween: 1 and: aPheromoneOrderedCollection size .
	((anAnt position - aPheromoneOrderedCollection at: randomPheromone) x < 0)
		ifTrue: [ onLeft := false. ] ifFalse: [ 	onLeft := true. ].	
	((anAnt position - aPheromoneOrderedCollection at: randomPheromone) y < 0)
		ifTrue: [ onTop := false. ] ifFalse: [ onTop := true. ].
		
	"newPos := (anAnt position) + (((Random new nextIntegerBetween: 1 and: 3) rounded) @ ((Random new nextIntegerBetween: 1 and: 3) rounded)). "
	newPos := anAnt position.	
	onLeft 
		ifTrue: [ newPos := newPos + (((Random new nextIntegerBetween: 1 and: 3) rounded)@0).  ]
		ifFalse: [ newPos := newPos - (((Random new nextIntegerBetween: 1 and: 3) rounded)@0). ].
	onTop
		ifTrue: [ newPos := newPos + (0@((Random new nextIntegerBetween: 1 and: 3) rounded)).  ]
		ifFalse: [ newPos := newPos - (0@((Random new nextIntegerBetween: 1 and: 3) rounded)). ].

	^ newPos.
]

{ #category : #'life cycle' }
MAWorker >> componentInitialize [

	roleName := #worker.
	phase := #explore.
]

{ #category : #role }
MAWorker >> doSimulationStepExplore: anAnt [

	| antRectangle insectsList |

	antRectangle := BlBounds origin: ((anAnt position) - (5@5)) extent: (10@10).
	
	insectsList := anAnt getInsects.
	
	insectsList keysDo: [ :each | | insectRectangle |
		insectRectangle := BlBounds origin: (each) extent: (0@0).
		(antRectangle intersects: insectRectangle) ifTrue: [
			self getTMARoleEventsNotifier worker: anAnt eatAt: each.
			phase := #return.
			oldPositions := OrderedCollection new.
			oldPositions add: anAnt position.	
			^ self.
		].
	].
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [

	phase = #explore ifTrue: [
		self doSimulationStepExplore: anAnt.
	].

	phase = #return ifTrue: [
			self doSimulationStepReturn: anAnt.
	].

]

{ #category : #role }
MAWorker >> doSimulationStepReturn: anAnt [

	| antRectangle  antHillRectangle |
			
	antRectangle := BlBounds origin: ((anAnt position) - (20@20)) extent: (40@40).
	antHillRectangle := BlBounds origin: MASimulationManager simulationAntHillPosition extent: (0@0).
	(antRectangle intersects: antHillRectangle) ifTrue: [
		phase := #explore.
		oldPositions := nil.
	].
]

{ #category : #position }
MAWorker >> getPheromonesAround: anAnt [ 

	| antRectangle pheromonesDict pheromoneOwnersDict othersPheromonesVisibles myPheromonesVisibles |
			
	antRectangle := BlBounds origin: ((anAnt position) - (5@5)) extent: (10@10).
	pheromonesDict := anAnt getPheromonesDict.
	pheromoneOwnersDict := anAnt getPheromoneOwnersDict.
	myPheromonesVisibles := OrderedCollection new.
	othersPheromonesVisibles := OrderedCollection new.
	pheromonesDict keysDo: [ :each | | pheromoneRectangle |
		oldPositions ifNil: [
			each = anAnt position ifFalse:[
				pheromoneRectangle := BlBounds origin: (each) extent: (0@0).
				(antRectangle intersects: pheromoneRectangle) ifTrue: [
					(pheromoneOwnersDict at: each) = anAnt ifTrue:[
						myPheromonesVisibles add: each.
					] ifFalse: [
						othersPheromonesVisibles add: each.
					].
				].	
			].
		] ifNotNil:[ | test |
			test := false.
			oldPositions do: [ :each2 |
				test := test | (each = each2).
			].
			test ifFalse:[
				pheromoneRectangle := BlBounds origin: (each) extent: (0@0).
				(antRectangle intersects: pheromoneRectangle) ifTrue: [
					myPheromonesVisibles add: each.
				].
			].
		].
	].
	^ myPheromonesVisibles.
]

{ #category : #position }
MAWorker >> moveFrom: anAnt [
	
	| newPos |
	
	phase = #explore ifTrue: [ | pheromonesVisibles |
			
		pheromonesVisibles := self getPheromonesAround: anAnt.
	
		pheromonesVisibles ifEmpty: [
			newPos := self randomMove: anAnt.
		] ifNotEmpty: [
			(Random new nextIntegerBetween: 1 and: 10) > 1 ifTrue: [
				newPos := self avoidPheromones: pheromonesVisibles for: anAnt.
			] ifFalse: [ 
				newPos := self randomMove: anAnt.
			].
		].
	
		newPos := self newPositionCheckBorder: newPos.
		self getTMARoleEventsNotifier workerExploringPositionChanged: newPos for: anAnt.
		^ newPos.
	].
	phase = #return ifTrue: [ | pheromonesVisibles |
		
		pheromonesVisibles := self getPheromonesAround: anAnt.
	
		pheromonesVisibles ifEmpty: [
			newPos := self randomMove: anAnt.
		] ifNotEmpty: [
			(Random new nextIntegerBetween: 1 and: 10) > 1 ifTrue: [
				newPos := self targetPheromones: pheromonesVisibles for: anAnt.
			] ifFalse: [ 
				newPos := self randomMove: anAnt.
			].
		].

		newPos := self newPositionCheckBorder: newPos.

		oldPositions add: anAnt position.
		oldPositions size > 10 ifTrue:[
			oldPositions removeFirst.
		].

		self getTMARoleEventsNotifier workerReturningPositionChanged: newPos for: anAnt .

		^ newPos.
	].
]

{ #category : #position }
MAWorker >> newPositionCheckBorder: aPoint [
	"Check if the ant is in the ground. If not keep the ant on the ground."
	| newPos |
	
	newPos:=aPoint.	

	(newPos x < 0) ifTrue: [
		newPos := 0@(newPos y)
	].
	(newPos y < 0) ifTrue: [
		newPos := (newPos x)@0
	].
	(newPos x > MASimulationManager simulationWidth) ifTrue: [
		newPos := (MASimulationManager simulationHeight)@(newPos y)
	].
	(newPos y > MASimulationManager simulationHeight ) ifTrue: [ 
		newPos := (newPos x)@(MASimulationManager simulationWidth)
	].
	^ newPos.
]

{ #category : #position }
MAWorker >> randomMove: anAnt [

	^ (anAnt position) + ((((Random new nextIntegerBetween: 0 and: 6)-3) rounded) @ (((Random new nextIntegerBetween: 0 and: 6)-3) rounded)). 
]

{ #category : #position }
MAWorker >> targetPheromones: aPheromoneOrderedCollection for: anAnt [
	
	| newPos randomPheromone |
	
	randomPheromone := Random new nextIntegerBetween: 1 and: aPheromoneOrderedCollection size .
	newPos := aPheromoneOrderedCollection at: randomPheromone.
	
	^ newPos.
]
