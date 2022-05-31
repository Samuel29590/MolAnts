"
Stages provide this event that is consumed by the simulation manager. This event describe one method stageChanged:for: that aim to be implemented by the simulation manager to remove, from the ordered collection ants, ants that are dead.
"
Trait {
	#name : #TMAStageEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolAnts
}

{ #category : #events }
TMAStageEvents >> stageChanged: aSymbol for: anAnt [
]
