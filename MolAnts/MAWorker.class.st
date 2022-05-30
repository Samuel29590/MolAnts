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
MAWorker >> avoidPheromone: aPoint for: anAnt [

	| newPos onTop onLeft onRight onBottom |
	"Detecting where is the pheromone from the ant."
	(anAnt position - aPoint) x = 0
		ifTrue: [ 
			onLeft := false.
			onRight := false ]
		ifFalse: [ 
			(anAnt position - aPoint) x < 0
				ifTrue: [ 
					onLeft := false.
					onRight := true ]
				ifFalse: [ 
					onLeft := true.
					onRight := false ] ].

	(anAnt position - aPoint) y = 0
		ifTrue: [ 
			onTop := false.
			onBottom := false ]
		ifFalse: [ 
			(anAnt position - aPoint) y < 0
				ifTrue: [ 
					onTop := false.
					onBottom := true ]
				ifFalse: [ 
					onTop := true.
					onBottom := false ] ].

	"Choosing the new position from the old pheromone."
	newPos := anAnt position.
	onLeft
		ifTrue: [ 
		newPos := newPos + ((Random new nextIntegerBetween: 1 and: 3) @ 0) ]
		ifFalse: [ 
			onRight
				ifTrue: [ 
				newPos := newPos - ((Random new nextIntegerBetween: 1 and: 3) @ 0) ]
				ifFalse: [ 
					newPos := newPos
					          + ((Random new nextIntegerBetween: 1 and: 7) - 4 @ 0) ] ].
	onTop
		ifTrue: [ 
		newPos := newPos + (0 @ (Random new nextIntegerBetween: 1 and: 3)) ]
		ifFalse: [ 
			onBottom
				ifTrue: [ 
				newPos := newPos - (0 @ (Random new nextIntegerBetween: 1 and: 3)) ]
				ifFalse: [ 
					newPos := newPos
					          + (0 @ ((Random new nextIntegerBetween: 1 and: 7) - 4)) ] ].
	^ newPos
]

{ #category : #'life cycle' }
MAWorker >> componentInitialize [

	roleName := #worker.
	phase := #explore.
	oldPositions := OrderedCollection new.
]

{ #category : #role }
MAWorker >> doSimulationStepExplore: anAnt [

	| antRectangle |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.

	anAnt getInsects keysDo: [ :each | 
		| insectRectangle |
		insectRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: insectRectangle) ifTrue: [ 
			self getTMARoleEventsNotifier worker: anAnt eatAt: each.
			phase := #return.
			oldPositions := OrderedCollection new.
			oldPositions add: anAnt position.
			^ self ] ]
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

	| antRectangle antHillRectangle |
	antRectangle := BlBounds
		                origin: anAnt position - (20 @ 20)
		                extent: 40 @ 40.
	antHillRectangle := BlBounds
		                    origin:
		                    MASimulationManager simulationAntHillPosition
		                    extent: 0 @ 0.
	(antRectangle intersects: antHillRectangle) ifTrue: [ 
		phase := #explore.
		self getTMARoleEventsNotifier insectDelivered.
		oldPositions := OrderedCollection new.
		oldPositions add: anAnt position ]
]

{ #category : #position }
MAWorker >> followAnOtherExplorer: aPheromoneOrderedCollection for: anAnt [
	
	| newPos randomPheromone |
	
	randomPheromone := Random new nextIntegerBetween: 1 and: aPheromoneOrderedCollection size .
	newPos := aPheromoneOrderedCollection at: randomPheromone.

	^ newPos.
]

{ #category : #position }
MAWorker >> getMyHightPheromoneAround: anAnt [

	"Function that permit to retrieve all exploration pheromones of an ant around this ant."

	| antRectangle maxIntensity bestPheromonePos |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.

	maxIntensity := 0.
	bestPheromonePos := nil.

	anAnt getPheromonesDict keysAndValuesDo: [ :k :v | 
		| pheromoneRectangle |
		k = anAnt position ifFalse: [ 
			pheromoneRectangle := BlBounds origin: k extent: 0 @ 0.
			(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
				v key = anAnt ifTrue: [ 
					v value > maxIntensity ifTrue: [ 
						maxIntensity := v value.
						bestPheromonePos := k ] ] ] ] ].
	^ bestPheromonePos
]

{ #category : #position }
MAWorker >> getMyPheromonesAround: anAnt [

	"Function that permit to retrieve all exploration pheromones of an ant around this ant."

	| antRectangle othersPheromonesVisibles pheromonesVisibles maxIntensity bestPheromonePos |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.

	othersPheromonesVisibles := OrderedCollection new.
	maxIntensity := 0.
	bestPheromonePos := nil.

	anAnt getPheromonesDict keysAndValuesDo: [ :k :v | 
		| pheromoneRectangle |
		k = anAnt position ifFalse: [ 
			pheromoneRectangle := BlBounds origin: k extent: 0 @ 0.
			(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
				v key = anAnt ifTrue: [ 
					v value > maxIntensity ifTrue: [ 
						maxIntensity := v value.
						bestPheromonePos := k ] ] ] ] ].

	anAnt getPheromonesDict keysDo: [ :each | 
		| pheromoneRectangle |
		each = anAnt position ifFalse: [ 
			pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
			(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
				(anAnt getPheromonesDict at: each) key = anAnt ifTrue: [ 
					pheromonesVisibles add: each ] ] ] ].
	^ pheromonesVisibles
]

{ #category : #position }
MAWorker >> getOthersPheromonesAround: anAnt [

	"Function that permit to retrieve all exploration pheromones of other ants around an ant."

	| antRectangle othersPheromonesVisibles |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.
	othersPheromonesVisibles := OrderedCollection new.
	anAnt getPheromonesDict keysDo: [ :each | 
		| pheromoneRectangle |
		each = anAnt position ifFalse: [ 
			| test |
			test := false.
			oldPositions do: [ :each2 | test := test | (each = each2) ].
			test ifFalse: [ 
				pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
				(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
					(anAnt getPheromonesDict at: each) key componentName
					= anAnt componentName ifFalse: [ 
						othersPheromonesVisibles add: each ] ] ] ] ].



	^ othersPheromonesVisibles
]

{ #category : #position }
MAWorker >> getPheromonesAround: anAnt [

	| antRectangle pheromonesDict pheromonesVisibles |
	antRectangle := BlBounds
		                origin: anAnt position - (6 @ 6)
		                extent: 12 @ 12.
		
	pheromonesDict := anAnt getPheromonesDict.
	pheromonesVisibles := OrderedCollection new.

	pheromonesDict keysDo: [ :each | 
		| pheromoneRectangle |
		oldPositions
			ifNil: [ 
				each = anAnt position ifFalse: [ 
					pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
					(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
						pheromonesVisibles add: each ] ] ]
			ifNotNil: [ 
				| test |
				test := false.
				oldPositions do: [ :each2 | test := test | (each = each2) ].
				test ifFalse: [ 
					pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
					(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
						pheromonesVisibles add: each ] ] ] ].
	^ pheromonesVisibles
]

{ #category : #position }
MAWorker >> moveFrom: anAnt [

	phase = #explore ifTrue: [ ^ self moveFromExplore: anAnt ].
	phase = #return ifTrue: [ ^ self moveFromReturn: anAnt ]
]

{ #category : #position }
MAWorker >> moveFromExplore: anAnt [

	| newPos pheromoneToAvoid othersPheromonesVisibles |
	pheromoneToAvoid := self getMyHightPheromoneAround: anAnt.
	othersPheromonesVisibles := self getOthersPheromonesAround: anAnt.

	othersPheromonesVisibles
		ifNotEmpty: [ 
			(Random new nextIntegerBetween: 1 and: 50) > 1
				ifTrue: [ 
					newPos := self
						          followAnOtherExplorer: othersPheromonesVisibles
						          for: anAnt ]
				ifFalse: [ 
					pheromoneToAvoid
						ifNil: [ newPos := self randomMove: anAnt ]
						ifNotNil: [ 
							(Random new nextIntegerBetween: 1 and: 50) > 1
								ifTrue: [ 
								newPos := self avoidPheromone: pheromoneToAvoid for: anAnt ]
								ifFalse: [ newPos := self randomMove: anAnt ] ] ] ]
		ifEmpty: [ 
			pheromoneToAvoid
				ifNil: [ newPos := self randomMove: anAnt ]
				ifNotNil: [ 
					(Random new nextIntegerBetween: 1 and: 50) > 1
						ifTrue: [ 
						newPos := self avoidPheromone: pheromoneToAvoid for: anAnt ]
						ifFalse: [ newPos := self randomMove: anAnt ] ] ].

	newPos := self newPositionCheckBorder: newPos.

	oldPositions add: anAnt position.
	oldPositions size > 5 ifTrue: [ oldPositions removeFirst ].

	self getTMARoleEventsNotifier
		workerExploringPositionChanged: newPos
		for: anAnt.

	^ newPos
]

{ #category : #position }
MAWorker >> moveFromRandom: anAnt [

	| newPos |
	phase = #explore ifTrue: [ 
		newPos := self randomMove: anAnt.

		newPos := self newPositionCheckBorder: newPos.

		oldPositions add: anAnt position.
		oldPositions size > 5 ifTrue: [ oldPositions removeFirst ].

		self getTMARoleEventsNotifier
			workerExploringPositionChanged: newPos
			for: anAnt ].

	phase = #return ifTrue: [ 
		newPos := self randomMove: anAnt.

		newPos := self newPositionCheckBorder: newPos.

		oldPositions add: anAnt position.
		oldPositions size > 5 ifTrue: [ oldPositions removeFirst ].

		self getTMARoleEventsNotifier
			workerReturningPositionChanged: newPos
			for: anAnt ].
	^ newPos
]

{ #category : #position }
MAWorker >> moveFromReturn: anAnt [

	| newPos pheromonesVisibles |
	pheromonesVisibles := self getPheromonesAround: anAnt.

	pheromonesVisibles
		ifEmpty: [ newPos := self randomMove: anAnt ]
		ifNotEmpty: [ 
			(Random new nextIntegerBetween: 1 and: 10) > 1
				ifTrue: [ 
				newPos := self targetPheromones: pheromonesVisibles for: anAnt ]
				ifFalse: [ newPos := self randomMove: anAnt ] ].

	newPos := self newPositionCheckBorder: newPos.

	oldPositions add: anAnt position.
	oldPositions size > 5 ifTrue: [ oldPositions removeFirst ].

	self getTMARoleEventsNotifier
		workerReturningPositionChanged: newPos
		for: anAnt.
	^ newPos
]

{ #category : #'instance creation' }
MAWorker >> newPositionCheckBorder: aPoint [

	"Check if the ant is in the ground. If not keep the ant on the ground."

	| newPos |
	newPos := aPoint.

	newPos x < 0 ifTrue: [ newPos := 0 @ newPos y ].
	newPos y < 0 ifTrue: [ newPos := newPos x @ 0 ].
	newPos x > MASimulationManager simulationWidth ifTrue: [ 
		newPos := MASimulationManager simulationWidth @ newPos y ].
	newPos y > MASimulationManager simulationHeight ifTrue: [ 
		newPos := newPos x @ MASimulationManager simulationHeight ].
	^ newPos
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
