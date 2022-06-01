"
Roles provide this event that is consumed by the simulation manager. This event describes methods that aim to make the actions of the ants concrete in the system.
"
Trait {
	#name : #TMARoleEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolAnts
}

{ #category : #events }
TMARoleEvents >> ant: anAnt killAt: aPoint [

	
]

{ #category : #events }
TMARoleEvents >> insectDelivered [
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
