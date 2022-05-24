Class {
	#name : #MAInsect,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsType + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsType classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs',
		'stage'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAInsect >> componentActivate [

	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAInsect >> componentInitialize [

	ageInMs := 0.
	stage := #alive.
]

{ #category : #'life cycle' }
MAInsect >> componentPassivate [

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAInsect >> doSimulationStep [

	stage = #alive ifTrue: [
		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self position: (position + (((Random new next * 2 - 1) rounded) @ ((Random new next * 2 - 1) rounded))).  
	].
]

{ #category : #'component accessing' }
MAInsect >> getTMAInsectEventsNotifier [
	^self eventsNotifiers at: TMAInsectEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAInsectEvents name: nil].
]

{ #category : #'component accessing' }
MAInsect >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'life cycle' }
MAInsect >> position [

	^ position
]

{ #category : #'life cycle' }
MAInsect >> position: aPoint [

	| oldPos |
	position ~= aPoint ifFalse: [ ^ self ].
	oldPos := position.
	position := aPoint.

	position x < 0 ifTrue: [ position := 0 @ position y ].
	position y < 0 ifTrue: [ position := position x @ 0 ].
	position x >= MASimulationManager simulationWidth ifTrue: [ 
		position := MASimulationManager simulationHeight @ position y ].
	position y >= MASimulationManager simulationHeight ifTrue: [ 
		position := position x @ MASimulationManager simulationWidth ].

	self getTMAInsectEventsNotifier 
		positionChangedFor: self
		oldPos: oldPos
		newPos: position
]
