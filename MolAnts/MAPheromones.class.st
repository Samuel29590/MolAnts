Class {
	#name : #MAPheromones,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMAPheromoneServices + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMAPheromoneServices classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromonesReturnDict'
	],
	#category : #'MolAnts-Model'
}

{ #category : #accessing }
MAPheromones class >> maxIntensity [

	^ 200
]

{ #category : #'life cycle' }
MAPheromones >> componentActivate [

	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	maxIntensity := 100.
	pheromonesDict := Dictionary new.
	pheromonesReturnDict := Dictionary new.
]

{ #category : #'life cycle' }
MAPheromones >> componentPassivate [

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentRemove [

	pheromonesDict := nil.
	pheromonesReturnDict := nil.
]

{ #category : #'events - lifecycle' }
MAPheromones >> doSimulationStep [

	pheromonesDict keysDo: [ :each | 
		pheromonesDict at: each update: [ :v | v value: v value -1 ].
		((pheromonesDict at: each) value) <= 0 ifTrue: [ 
			pheromonesDict removeKey: each.
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
MAPheromones >> getPheromonesDict [

	^ pheromonesDict.
]

{ #category : #services }
MAPheromones >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #events }
MAPheromones >> pheromoneNew: aPoint for: anAnt [

	(pheromonesDict includesKey: aPoint)
		ifFalse: [ 
			| pointRectangle antHillRectangle |
			pointRectangle := BlBounds
				                  origin: anAnt position - (20 @ 20)
				                  extent: 40 @ 40.

			antHillRectangle := BlBounds
				                    origin:
				                    MASimulationManager simulationAntHillPosition
				                    extent: 0 @ 0.

			(pointRectangle intersects: antHillRectangle) ifFalse: [ 
				pheromonesDict add: aPoint -> (anAnt -> maxIntensity) ] ]
		ifTrue: [ pheromonesDict at: aPoint put: anAnt -> maxIntensity ]
]

{ #category : #events }
MAPheromones >> pheromoneReturnNew: aPoint for: anAnt [

		(pheromonesReturnDict includesKey: aPoint) ifFalse:[
			pheromonesReturnDict add: (aPoint -> maxIntensity).
		] ifTrue: [
			pheromonesReturnDict at: aPoint  update: [:v | v - v + maxIntensity].
		].
	

]
