"
The actual implementation of the TMAInsectsType: MAInsect, describe one insect. It means that if there are 50 insects on the simulation, there are also 50 instances of MAInsects. This implementation is very simple, insect only move on the ground randomly (waiting to be eaten...) at each step of the simulation.

Variables :

-position, is a point.

-ageInMs, is an integer.
"
Class {
	#name : #MAInsect,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsType + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsType classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAInsect >> componentActivate [

	"Activation of the MAInsect component."

	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAInsect >> componentInitialize [

	"Initialization of the MAInsect component."

	ageInMs := 0.
]

{ #category : #'life cycle' }
MAInsect >> componentPassivate [


	"Passivating the MAInsect component."
	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAInsect >> doSimulationStep [

	"At each step an insect just move randomly, waiting to be eaten ..."

		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self position: position
			+
			((Random new next * 2 - 1) rounded
			 @ (Random new next * 2 - 1) rounded) 
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
