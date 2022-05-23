Class {
	#name : #MAInsect,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'position',
		'ageInMs',
		'stage'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAInsect >> componentActivate [
		
	self getTMASimulationEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAInsect >> componentInitialize [

	ageInMs := 0.
	stage := #alive.
]

{ #category : #'life cycle' }
MAInsect >> componentPassivate [
		
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAInsect >> doSimulationStep [

	stage = #alive ifTrue: [
		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self position: (position + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded))).  
	].
]

{ #category : #'component accessing' }
MAInsect >> getTMAPositionEventsNotifier [
	^self eventsNotifiers at: TMAPositionEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAPositionEvents name: nil].
]

{ #category : #'component accessing' }
MAInsect >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #accessing }
MAInsect >> insectDead: anInsect [

	self = anInsect ifTrue: [
		stage := #dead.
	]
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

	self getTMAPositionEventsNotifier
		positionChangedFor: self
		oldPos: oldPos
		newPos: position
]

{ #category : #'life cycle' }
MAInsect >> simulationStepSent [

	self doSimulationStep.
]
