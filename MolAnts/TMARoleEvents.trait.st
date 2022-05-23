Trait {
	#name : #TMARoleEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #events }
TMARoleEvents >> ant: anAnt eatAt: aPoint [
]

{ #category : #events }
TMARoleEvents >> positionChanged: aPoint for: anAnt [
]

{ #category : #events }
TMARoleEvents >> queenLaid [
]

{ #category : #events }
TMARoleEvents >> worker: anAnt eatAt: aPoint [
]

{ #category : #events }
TMARoleEvents >> workerExploringPositionChanged: aPoint for: anAnt [
]

{ #category : #events }
TMARoleEvents >> workerReturningPositionChanged: aPoint for: anAnt [
]
