Class {
	#name : #MAPheromones,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMASimulationEvents + TMAPheromoneServices',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMASimulationEvents classTrait + TMAPheromoneServices classTrait',
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromoneOwnersDict',
		'pheromonesReturnDict'
	],
	#category : #'MolAnts-Model'
}

{ #category : #accessing }
MAPheromones class >> maxIntensity [

	^ 300.
]

{ #category : #'life cycle' }
MAPheromones >> componentActivate [

	self getTMASimulationEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAPheromones >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	maxIntensity := 100.
	pheromonesDict := Dictionary new.
	pheromoneOwnersDict := Dictionary new.
	pheromonesReturnDict := Dictionary new.
]

{ #category : #'life cycle' }
MAPheromones >> componentPassivate [

	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAPheromones >> componentRemove [

	pheromonesDict := nil.
	pheromoneOwnersDict := nil.
	pheromonesReturnDict := nil.
]

{ #category : #'events - lifecycle' }
MAPheromones >> doSimulationStep [

	pheromonesDict keysDo: [ :each | 
		pheromonesDict at: each update: [ :v | v-1 ].
		(pheromonesDict at: each) <= 0 ifTrue: [ 
			pheromonesDict removeKey: each.
			pheromoneOwnersDict removeKey: each
		].
	].

	pheromonesReturnDict keysDo: [ :each | 
		pheromonesReturnDict at: each update: [ :v | v-1 ].
		(pheromonesReturnDict at: each) <= 0 ifTrue: [ 
			pheromonesReturnDict removeKey: each.
		].
	].
]

{ #category : #services }
MAPheromones >> getMaxIntensity [

	^ maxIntensity.
]

{ #category : #services }
MAPheromones >> getPheromoneOwnersDict [

	^ pheromoneOwnersDict .
]

{ #category : #services }
MAPheromones >> getPheromonesDict [

	^ pheromonesDict.
]

{ #category : #services }
MAPheromones >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #events }
MAPheromones >> pheromoneNew: aPoint for: anAnt [

		(pheromonesDict includesKey: aPoint) ifFalse:[
			pheromonesDict add: (aPoint -> maxIntensity).
			pheromoneOwnersDict add: (aPoint -> anAnt).
		] ifTrue: [
			pheromonesDict at: aPoint  update: [:v | v - v + maxIntensity].
		].
	
]

{ #category : #events }
MAPheromones >> pheromoneReturnNew: aPoint for: anAnt [

		(pheromonesReturnDict includesKey: aPoint) ifFalse:[
			pheromonesReturnDict add: (aPoint -> maxIntensity).
		] ifTrue: [
			pheromonesReturnDict at: aPoint  update: [:v | v - v + maxIntensity].
		].
	

]

{ #category : #'events - lifecycle' }
MAPheromones >> simulationStepSent [

	self doSimulationStep.
]
