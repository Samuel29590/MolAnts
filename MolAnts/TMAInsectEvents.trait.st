"
Insects provide this event that is consumed by the simulation manager. This event describe one method positionChnagedFor:oldPos:newPos: that aim to be implemented by the simulation manager to keep the dictionary of insect positions up-to-date.
"
Trait {
	#name : #TMAInsectEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolAnts
}

{ #category : #events }
TMAInsectEvents >> positionChangedFor: aModelObject oldPos: aPoint newPos: anotherPoint [
]
