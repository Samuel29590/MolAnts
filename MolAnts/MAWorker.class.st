"
I'm the actual implementation of the worker role.

MAWorker variables :

-phase, is a symbol to represent the actual phase of the ant: explore of return.

-oldPositions, is and ordered collection of 5 points used by the worker role do not move on the last 5 position the worker already visit.
"
Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#instVars : [
		'phase',
		'oldPositions'
	],
	#category : #MolAnts
}

{ #category : #position }
MAWorker >> avoidPheromone: aPoint for: anAnt [

	"This method return the new position of the ant after analyzing the highest pheromone around him."

	| newPos onTop onLeft onRight onBottom |
	"Detecting where is the pheromone around the ant."
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

	"Choosing the new position to avoid the highest pheromone."
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

	"Initialization of the MAWorker component."

	roleName := #worker.
	phase := #explore.
	oldPositions := OrderedCollection new
]

{ #category : #role }
MAWorker >> doSimulationStepExplore: anAnt [

	"A worker that explore, look at each step if their are insects visible by him. And if an insect is visible, the worker eat it and notify the MASimulationManager of an eating and change his phase."

	| antRectangle |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.

	anAnt getInsects keysDo: [ :each | 
		| insectRectangle |
		insectRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: insectRectangle) ifTrue: [ 
			self getTMARoleEventsNotifier ant: anAnt killAt: each.
			phase := #return.
			oldPositions := OrderedCollection new.
			oldPositions add: anAnt position.
			^ self ] ].

	anAnt getFeedingPoints keysDo: [ :each | 
		| feedingPointRectangle |
		feedingPointRectangle := BlBounds
			                         origin: each - (5 @ 5)
			                         extent: 10 @ 10.
		(antRectangle intersects: feedingPointRectangle) ifTrue: [ 
			self getTMARoleEventsNotifier worker: anAnt eatAt: each.
			phase := #return.
			oldPositions := OrderedCollection new.
			oldPositions add: anAnt position.
			^ self ] ]
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [

	phase = #explore ifTrue: [ self doSimulationStepExplore: anAnt ].
	phase = #return ifTrue: [ self doSimulationStepReturn: anAnt ]
]

{ #category : #role }
MAWorker >> doSimulationStepReturn: anAnt [

	"A worker that is returning to the ant hill look at each step if he is around the ant hill. If he is around the ant hill he notify the MASimulationMangaer of a delivery and change is phase."

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

	"This method return a random pheromone in an ordered collection of pheromones."

	| newPos randomPheromone |
	randomPheromone := Random new
		                   nextIntegerBetween: 1
		                   and: aPheromoneOrderedCollection size.
	newPos := aPheromoneOrderedCollection at: randomPheromone.

	^ newPos
]

{ #category : #position }
MAWorker >> getMyHightPheromoneAround: anAnt [

	"This method return the pheromone with the highest intensity around an ant."

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
MAWorker >> getOthersPheromonesAround: anAnt [

	"Function that permit to retrieve all exploration pheromones of other ants around an ant."

	| antRectangle othersPheromonesVisibles |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.
	othersPheromonesVisibles := OrderedCollection new.
	anAnt getPheromonesDict keysDo: [ :each | 
		| pheromoneRectangle |
		pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
			(anAnt getPheromonesDict at: each) key componentName
			= anAnt componentName ifFalse: [ 
				othersPheromonesVisibles add: each ] ] ].

		othersPheromonesVisibles remove: anAnt position ifAbsent: [  ].
	oldPositions do: [ :each | 
		othersPheromonesVisibles remove: each ifAbsent: [  ] ].
	^ othersPheromonesVisibles
]

{ #category : #position }
MAWorker >> getPheromonesAround: anAnt [

	"This method permit to get all pheromone around anAnt, the old positions of the ant aren't in the orderedCollection that is returning."

	| antRectangle pheromonesDict pheromonesVisibles |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.

	pheromonesDict := anAnt getPheromonesDict.
	pheromonesVisibles := OrderedCollection new.

	pheromonesDict keysDo: [ :each | 
		| pheromoneRectangle |
					pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
					(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
						pheromonesVisibles add: each ] ] .
				pheromonesVisibles remove: anAnt position ifAbsent: [  ].
	oldPositions do: [ :each | 
		pheromonesVisibles remove: each ifAbsent: [  ] ].	
				
	^ pheromonesVisibles
]

{ #category : #position }
MAWorker >> getPheromonesOfReturnAround: anAnt [

	"Function that permit to retrieve all return pheromones of return around an ant."

	| antRectangle pheromonesVisibles |
	antRectangle := BlBounds
		                origin: anAnt position - (5 @ 5)
		                extent: 10 @ 10.
	pheromonesVisibles := OrderedCollection new.
	anAnt getPheromonesReturnDict keysDo: [ :each | 
		| pheromoneRectangle |
		pheromoneRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: pheromoneRectangle) ifTrue: [ 
			pheromonesVisibles add: each ] ].

	pheromonesVisibles remove: (anAnt position) ifAbsent: [  ].
	oldPositions do:[ :each | 
	pheromonesVisibles remove: each ifAbsent: [  ].].
	^ pheromonesVisibles
]

{ #category : #position }
MAWorker >> moveFrom: anAnt [

	phase = #explore ifTrue: [ ^ self moveFromExplore: anAnt ].
	phase = #return ifTrue: [ ^ self moveFromReturn: anAnt ]
]

{ #category : #position }
MAWorker >> moveFromExplore: anAnt [

	"This method is the actual behavior of ants. If an ant detect pheromones of other ants it will follow them. But if their is no others pheromones, the ant take his own track by avoiding is precedent pheromones. Of course some time their is random move to keep deplacement more realistic."

	| newPos pheromoneToAvoid othersPheromonesVisibles pheromonesOfReturn |
	pheromonesOfReturn := self getPheromonesOfReturnAround: anAnt.
	pheromonesOfReturn
		ifNotEmpty: [ 
		newPos := self followAnOtherExplorer: pheromonesOfReturn for: anAnt ]
		ifEmpty: [ 
			othersPheromonesVisibles := self getOthersPheromonesAround: anAnt.
			othersPheromonesVisibles
				ifNotEmpty: [ 
					newPos := self
						          followAnOtherExplorer: othersPheromonesVisibles
						          for: anAnt ]
				ifEmpty: [ 
					oldPositions
						ifNotEmpty: [ newPos := self movingWithOldPositions: anAnt ]
						ifEmpty: [ 
							pheromoneToAvoid := self getMyHightPheromoneAround: anAnt.
							pheromoneToAvoid
								ifNil: [ newPos := self randomMove: anAnt ]
								ifNotNil: [ 
									(Random new nextIntegerBetween: 1 and: 50) > 1
										ifTrue: [ 
										newPos := self avoidPheromone: pheromoneToAvoid for: anAnt ]
										ifFalse: [ newPos := self randomMove: anAnt ] ] ] ] ].

	newPos := self newPositionCheckBorder: newPos.

	oldPositions add: anAnt position.
	oldPositions size > 10 ifTrue: [ oldPositions removeFirst ].

	self getTMARoleEventsNotifier
		workerExploringPositionChanged: newPos
		for: anAnt.

	^ newPos
]

{ #category : #position }
MAWorker >> moveFromRandom: anAnt [

	"Random move for anAnt, this method is udes to test performance of the system (normally this method isn't used in the system)."

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

	"This method is used by ants when they are returning to the ant hill. So it permit to get all pheromones around the ant and follow the track. If their is no pheromones around, the ant move randomly."

	| newPos pheromonesVisibles pheromonesOfReturn |
	pheromonesOfReturn := self getPheromonesOfReturnAround: anAnt.
	pheromonesOfReturn
		ifNotEmpty: [ 
		newPos := self followAnOtherExplorer: pheromonesOfReturn for: anAnt ]
		ifEmpty: [ 
			pheromonesVisibles := self getPheromonesAround: anAnt.

			pheromonesVisibles
				ifEmpty: [ 
					oldPositions
						ifNotEmpty: [ newPos := self movingWithOldPositions: anAnt ]
						ifEmpty: [ newPos := self randomMove: anAnt ] ]
				ifNotEmpty: [ 
				newPos := self followAnOtherExplorer: pheromonesVisibles for: anAnt ] ].

	newPos := self newPositionCheckBorder: newPos.

	oldPositions add: anAnt position.
	oldPositions size > 10 ifTrue: [ oldPositions removeFirst ].

	self getTMARoleEventsNotifier
		workerReturningPositionChanged: newPos
		for: anAnt.
	^ newPos
]

{ #category : #position }
MAWorker >> movingWithOldPositions: anAnt [

	"| res |
	res := 0 @ 0.
	oldPositions size > 1 ifTrue: [ 
		2 to: oldPositions size do: [ :value | 
			res := res
			       + ((oldPositions at: value) - (oldPositions at: value - 1)) ] ].

	res := res + (anAnt position - (oldPositions at: oldPositions size)).

	res x > 5 ifTrue: [ res := 5 @ res y ].
	res x < -5 ifTrue: [ res := -5 @ res y ].
	res y > 5 ifTrue: [ res := res x @ 5 ].
	res y < -5 ifTrue: [ res := res x @ -5 ].

	res := anAnt position + ((res x / oldPositions size) rounded
	        + (Random new nextIntegerBetween: 1 and: 3) - 2
	        @ ((res y / oldPositions size) rounded
		         + (Random new nextIntegerBetween: 1 and: 3) - 2)).
	^ res"

	| res |
	res := 0 @ 0.
	oldPositions size > 3 ifTrue: [ 
		res := res + ((oldPositions at: oldPositions size)
		        - (oldPositions at: oldPositions size - 1)).
		res := res + ((oldPositions at: oldPositions size - 1)
		        - (oldPositions at: oldPositions size - 2)).
		res := res + ((oldPositions at: oldPositions size - 2)
		        - (oldPositions at: oldPositions size - 3)) ].
	res := res + (anAnt position - (oldPositions at: oldPositions size)).
	res := (res x / 4) rounded
	       + (Random new nextIntegerBetween: 1 and: 5) - 3
	       @
	       ((res y / 4) rounded
	        + (Random new nextIntegerBetween: 1 and: 5) - 3).

	res x > 3 ifTrue: [ res := 3 @ res y ].
	res x < -3 ifTrue: [ res := -3 @ res y ].
	res y > 3 ifTrue: [ res := res x @ 3 ].
	res y < -3 ifTrue: [ res := res x @ -3 ].

	res := anAnt position + res.
	^ res
]

{ #category : #'instance creation' }
MAWorker >> newPositionCheckBorder: aPoint [

	"This method check if the ant is in the ground. If not, it keep the ant on the ground."

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

	"This method return a random move."

	^ anAnt position
	  + (((Random new nextIntegerBetween: 0 and: 6) - 3) rounded
		   @ ((Random new nextIntegerBetween: 0 and: 6) - 3) rounded)
]
