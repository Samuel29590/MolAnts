Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMAStageEvents + TMASimulationServices + TMARoleEvents + TMAPositionEvents',
	#classTraits : 'TMASimulationManagerType classTrait + TMAStageEvents classTrait + TMASimulationServices classTrait + TMARoleEvents classTrait + TMAPositionEvents classTrait',
	#instVars : [
		'simulationThread',
		'ground',
		'isAntHillCreated',
		'isInsectsCreated',
		'ants',
		'nbAnt',
		'insectsPos',
		'pheromones'
	],
	#category : #'MolAnts-Core'
}

{ #category : #'accessing - events' }
MASimulationManager class >> consumedComponentEvents [
	<componentContract>
	^ {TMAStageEvents . TMARoleEvents . TMAPositionEvents}
]

{ #category : #scripts }
MASimulationManager class >> pauseSimulation [
	<script>
	
	self passivate
]

{ #category : #scripts }
MASimulationManager class >> playSimulation [
	<script>
	
	self activate.
]

{ #category : #properties }
MASimulationManager class >> simulationAntHillPosition [

	^ 200@200.
]

{ #category : #properties }
MASimulationManager class >> simulationHeight [

	^ 500
]

{ #category : #properties }
MASimulationManager class >> simulationStepDurationInMs [

	^ 50
]

{ #category : #properties }
MASimulationManager class >> simulationWidth [

	^ 500
]

{ #category : #scripts }
MASimulationManager class >> startSimulation [
	<script>
	
	self start.
]

{ #category : #scripts }
MASimulationManager class >> stopSimulation [
	<script>
	
	self stop.
	MolComponentManager cleanUp.
	
]

{ #category : #events }
MASimulationManager >> ant: anAnt eatAt: aPoint [

	| insect |
	
	"remove the insect in the dictionary."
	(insectsPos includesKey: aPoint) ifTrue: [
		insect := (insectsPos at: aPoint) removeFirst.
		(insectsPos at: aPoint) isEmpty ifTrue:[
			insectsPos removeKey: aPoint.
		].
	].
]

{ #category : #accessing }
MASimulationManager >> ants [

	^ ants.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [ 

	super componentActivate.
	self getTMAStageEventsSubscriber subscribe: self.
	self getTMARoleEventsSubscriber subscribe: self.
	self getTMAPositionEventsSubscriber subscribe: self.
	isRunning := true.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [

	super componentInitialize.
	simulationThread := nil.
	ground := nil.
	isAntHillCreated := false.
	isInsectsCreated := false.
	ants := OrderedCollection new.
	nbAnt := 0.
	insectsPos := Dictionary new.
	pheromones := MAPheromones start: 'Pheromones'.
	ground := MAGround start: 'Ground'.
	ground
		forServices: TMAPheromoneServices
		useProvider: pheromones componentName asSymbol asSymbol.
	self start
]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	super componentPassivate.
	self getTMAStageEventsSubscriber unsubscribe: self.
	self getTMARoleEventsSubscriber unsubscribe: self.
	self getTMAPositionEventsSubscriber unsubscribe: self.
	isRunning := false.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentRemove [

	self stop.

]

{ #category : #private }
MASimulationManager >> createAnt [
	
	| name ant |

	isAntHillCreated ifTrue: [ 
		
		nbAnt := nbAnt + 1.
		
		name := ('Ant', nbAnt printString) asSymbol.
		ant := MAAnt start: name.
		ant position: self class simulationAntHillPosition.
		
		"Adding events producer into SimulationMManager and Ground"
		self forEvents: TMAStageEvents addProducer: (ant getStage componentName). 
		self forEvents: TMARoleEvents addProducer: (ant getStage getRole componentName). 
		self forEvents: TMAPositionEvents addProducer: name.
		
		ants add: ant.
	].

	
]

{ #category : #private }
MASimulationManager >> createAntHill [

	self isAntHillCreated: true.

	"Create x ants"
	"1 to: 50 do:[ :e |
		self createAnt.
	]."
	
	"Create the first queen of ants"
	self createAnt.
	
]

{ #category : #private }
MASimulationManager >> createInsects [

	self isInsectsCreated: true.

	"Create 50 insects"
	1 to: 50 do:[ :e | | insect name newPos |
		"Create Ant"
		name := ('Insect', e printString) asSymbol.
		insect := MAInsect start: name.
		
		newPos := (Random new nextIntegerBetween: 1 and: MASimulationManager simulationWidth)@(Random new nextIntegerBetween: 1 and: MASimulationManager simulationHeight).
		insect position: newPos.
		
		"Adding events producer into SimulationMManager"
		self forEvents: TMAPositionEvents addProducer: name.
		
		"Add the insect to the dictionary of their positions."
		(insectsPos includesKey: newPos) ifFalse:[ | collection |
			collection := (OrderedCollection new).
			collection add:insect.
			insectsPos add: (newPos -> collection ).
		] ifTrue: [
			(insectsPos at: newPos) addLast: insect.
		].
	].
	
]

{ #category : #services }
MASimulationManager >> getPheromoneOwnersDict [

	^ pheromones getPheromoneOwnersDict.
]

{ #category : #services }
MASimulationManager >> getPheromonesDict [

	^ pheromones getPheromonesDict.
]

{ #category : #services }
MASimulationManager >> getPheromonesReturnDict [

	^ pheromones getPheromonesReturnDict.
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAPositionEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAPositionEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAPositionEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMARoleEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMARoleEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMARoleEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMASimulationEventsNotifier [
	^self eventsNotifiers at: TMASimulationEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationEvents name: nil].
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAStageEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAStageEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAStageEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #services }
MASimulationManager >> insectsPos [

	^ insectsPos.
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated [

	^ isAntHillCreated ifNil:[ isAntHillCreated := false ]
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated: anObject [

	isAntHillCreated := anObject
]

{ #category : #accessing }
MASimulationManager >> isInsectsCreated [

	^ isInsectsCreated
]

{ #category : #accessing }
MASimulationManager >> isInsectsCreated: anObject [

	isInsectsCreated := anObject
]

{ #category : #services }
MASimulationManager >> pause [

	self isRunning ifFalse:[^self].
	self pauseSimulationLoop.
	isRunning := false.
	self getTMASimulationEventsNotifier paused.
]

{ #category : #private }
MASimulationManager >> pauseSimulationLoop [

	simulationThread ifNil:[^self].
	simulationThread suspend.
]

{ #category : #events }
MASimulationManager >> positionChanged: aPoint for: aModelObject [

	"self getTMASimulationEventsNotifier positionChanged: aPoint for: aModelObject."
]

{ #category : #events }
MASimulationManager >> positionChangedFor: aModelObject oldPos: aPoint newPos: anotherPoint [

	"Add the insect position in the dictionary."
	
	"remove the old position."
	(insectsPos includesKey: aPoint) ifTrue: [
		(insectsPos at: aPoint) remove: aModelObject ifAbsent: [].
		(insectsPos at: aPoint) isEmpty ifTrue:[
			insectsPos removeKey: aPoint.
		].
	].
	
	"Add to the new position."
	(insectsPos includesKey: anotherPoint) ifFalse:[ | collection |
		collection := (OrderedCollection new).
		collection add: aModelObject.
		insectsPos add: (anotherPoint -> collection ).
	] ifTrue: [
		(insectsPos at: anotherPoint) addLast: aModelObject.
	].
]

{ #category : #events }
MASimulationManager >> queenLaid [

	self createAnt.
]

{ #category : #private }
MASimulationManager >> removeAntHill [

	"Delete nbAnt ants"
	ants do:[ :e | 
		MAAnt stop: (e componentName).
	].
	ants := nil.
	nbAnt := 0.
	self isAntHillCreated: false.
]

{ #category : #private }
MASimulationManager >> removeInsects [

	"Delete insects"
	insectsPos do: [ :each | | name |
		each do: [ :insect |
			"Delete insect"
			name := insect componentName.
			MAInsect stop: name.
		].
	].
	insectsPos := nil.
	self isInsectsCreated: false.
]

{ #category : #private }
MASimulationManager >> removePheromones [

	pheromones := nil.
	MAPheromones stop: 'Pheromones'.
]

{ #category : #events }
MASimulationManager >> roleChanged: aSymbol for: aModelObject [

	self getTMASimulationEventsNotifier ant: aModelObject changeRole: aSymbol.
	^ self
]

{ #category : #events }
MASimulationManager >> stageNameChanged: aSymbol for: aModelObject [

	aSymbol = #dead ifTrue: [ ants remove: aModelObject ]
]

{ #category : #services }
MASimulationManager >> start [

	self isRunning ifTrue: [ ^ self ].
	self isAntHillCreated ifFalse: [ self createAntHill ].

	self createInsects.

	self startSimulationLoop.
	isRunning := true.
	self getTMASimulationEventsNotifier started
]

{ #category : #private }
MASimulationManager >> startSimulationLoop [

	simulationThread ifNil: [ 
		simulationThread := [ 
		                    [ true ] whileTrue: [ 
			                    self getTMASimulationEventsNotifier
				                    simulationStepSent.
			                    (Delay forMilliseconds:
				                     self class simulationStepDurationInMs) wait ] ]
			                    newProcess priority:
			                    Processor userBackgroundPriority.

		simulationThread name: 'Molecule SimulationManager Process' ].

	simulationThread resume
]

{ #category : #services }
MASimulationManager >> stop [

	self stopSimulationLoop.

	MAGround stop: 'Ground'.
	ground := nil.

	self isAntHillCreated ifTrue: [ self removeAntHill ].
	self isInsectsCreated ifTrue: [ self removeInsects ].
	self removePheromones.

	isRunning := false.

	self getTMASimulationEventsNotifier stopped
]

{ #category : #private }
MASimulationManager >> stopSimulationLoop [

	simulationThread ifNil: [ ^ self ].
	simulationThread terminate.
	simulationThread := nil
]

{ #category : #events }
MASimulationManager >> worker: anAnt eatAt: aPoint [

	| insect |
	"remove the insect in the dictionary."
	(insectsPos includesKey: aPoint) ifTrue: [ 
		insect := (insectsPos at: aPoint) removeFirst.
		(insectsPos at: aPoint) isEmpty ifTrue: [ 
			insectsPos removeKey: aPoint ] ].

	"Tell the insect that he is dead."
	MAInsect stop: insect componentName
]

{ #category : #events }
MASimulationManager >> workerExploringPositionChanged: aPoint for: anAnt [

	self getTMASimulationEventsNotifier pheromoneNew: aPoint for: anAnt.
	"self getTMASimulationEventsNotifier positionChanged: aPoint for: anAnt."
]

{ #category : #events }
MASimulationManager >> workerReturningPositionChanged: aPoint for: anAnt [
	
	self getTMASimulationEventsNotifier pheromoneReturnNew: aPoint for: anAnt.
	"self getTMASimulationEventsNotifier positionChanged: aPoint for: anAnt."
]
