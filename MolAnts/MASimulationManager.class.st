Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMASimulationServices + TMARoleEvents + TMAInsectEvents + TMAStageEvents',
	#classTraits : 'TMASimulationManagerType classTrait + TMASimulationServices classTrait + TMARoleEvents classTrait + TMAInsectEvents classTrait + TMAStageEvents classTrait',
	#instVars : [
		'isFirstStep',
		'simulationThread',
		'ground',
		'isAntHillCreated',
		'isInsectsCreated',
		'ants',
		'nbAnt',
		'insectsPos',
		'pheromones',
		'nbDelivered'
	],
	#category : #MolAnts
}

{ #category : #'accessing - events' }
MASimulationManager class >> consumedComponentEvents [
	<componentContract>
	^ {TMAStageEvents . TMARoleEvents . TMAInsectEvents}
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

	^ 400 @ 250
]

{ #category : #properties }
MASimulationManager class >> simulationHeight [

	^ 500
]

{ #category : #properties }
MASimulationManager class >> simulationStepDurationInMs [

	^ 30
]

{ #category : #properties }
MASimulationManager class >> simulationWidth [

	" Minimum recommended : 500 for a clear UI"

	^ 800
]

{ #category : #scripts }
MASimulationManager class >> startSimulation [

	<script>
	self start.
	self passivate
]

{ #category : #scripts }
MASimulationManager class >> stopSimulation [
	<script>
	
	self stop.
	MolComponentManager cleanUp.
	
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [

	"Activation of the MASimulationManager component."

	super componentActivate.
	self getTMAStageEventsSubscriber subscribe: self.
	self getTMARoleEventsSubscriber subscribe: self.
	self getTMAInsectEventsSubscriber subscribe: self.
	isRunning := true
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [

	"Initialization of the MASimulationManager component."

	super componentInitialize.
	isFirstStep := true.
	simulationThread := nil.
	ground := nil.
	isAntHillCreated := false.
	isInsectsCreated := false.
	ants := OrderedCollection new.
	nbAnt := 0.
	nbDelivered := 0.
	insectsPos := Dictionary new.
	pheromones := MAPheromones start: 'Pheromones'.
	self
		forServices: TMAPheromoneServices
		useProvider: pheromones componentName asSymbol.
	ground := MAGround start: 'Ground'.
	ground
		forServices: TMAPheromoneServices
		useProvider: pheromones componentName asSymbol.
	self start
]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	"Passivating the MASimulationManager component."

	super componentPassivate.
	
	self getTMAStageEventsSubscriber unsubscribe: self.
	self getTMARoleEventsSubscriber unsubscribe: self.
	self getTMAInsectEventsSubscriber unsubscribe: self.
	isRunning := false
]

{ #category : #'component life cycle' }
MASimulationManager >> componentRemove [

	"Removing the MASimulationManager component."
	self stop
]

{ #category : #private }
MASimulationManager >> createAnt [

	"Creation of a new ant"

	| name ant |
	isAntHillCreated ifTrue: [ 
		nbAnt := nbAnt + 1.
		name := ('Ant' , nbAnt printString) asSymbol.
		ant := MAAnt start: name.
		ant position: self class simulationAntHillPosition.

		"Adding event producer into SimulationManager"

		self forEvents: TMARoleEvents addProducer: ant getRole componentName.

		"Adding the ant to the OrderedCollection of ants"

		ants add: ant ]
]

{ #category : #private }
MASimulationManager >> createAntHill [

	"Creation of the first ant hill and the first ant of this ant hill."

	self isAntHillCreated: true.
	self createAnt
]

{ #category : #private }
MASimulationManager >> createInsects [

	"Creation of the 50 firt insects"

	self isInsectsCreated: true.
	1 to: 50 do: [ :e | 
		| insect name newPos |
		name := ('Insect' , e printString) asSymbol.
		insect := MAInsect start: name.
		newPos := (Random new
			           nextIntegerBetween: 1
			           and: MASimulationManager simulationWidth) @ (Random new
			           nextIntegerBetween: 1
			           and: MASimulationManager simulationHeight).
		insect position: newPos.

		"Adding events producer into SimulationMManager"
		self forEvents: TMAInsectEvents addProducer: name.

		"Add the insect to the dictionary of insects positions."
		(insectsPos includesKey: newPos)
			ifFalse: [ 
				| collection |
				collection := OrderedCollection new.
				collection add: insect.
				insectsPos add: newPos -> collection ]
			ifTrue: [ (insectsPos at: newPos) addLast: insect ] ]
]

{ #category : #services }
MASimulationManager >> getAnts [

	"Returning an OrderedCollection of all the ant currently alive in the system."

	^ ants
]

{ #category : #services }
MASimulationManager >> getInsectsPos [

	"Returning a Dictionary of the insects positions (key: a Point / value: an OrderedCollection of MAInsect instances"

	^ insectsPos
]

{ #category : #services }
MASimulationManager >> getNbDelivered [

	"Returning the number of insects delivered to the ant hill."

	^ nbDelivered
]

{ #category : #services }
MASimulationManager >> getPheromonesDict: aPoint [

	"Returning a Dictionary of all pheromone of exploration in the system (key: position / value: (the ant that create it -> intensity))"

	^ self getTMAPheromoneServicesProvider getPheromonesDict: aPoint.
]

{ #category : #services }
MASimulationManager >> getPheromonesReturnDict [

	"Returning a Dictionary of all pheromone of return in the system (key: position / value: (the ant that create it -> intensity))"

	^ self getTMAPheromoneServicesProvider getPheromonesReturnDict
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAInsectEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAInsectEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAInsectEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAPheromoneServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMAPheromoneServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMAPheromoneServices named: servicesSymbol]. 
	^servicesProvider
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
MASimulationManager >> getTMASimulationToGlobalEventsNotifier [
	^self eventsNotifiers at: TMASimulationToGlobalEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationToGlobalEvents name: nil].
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

{ #category : #events }
MASimulationManager >> insectDelivered [

	"Counting the number of insects delivered to the ant hill."

	nbDelivered := nbDelivered + 1
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

{ #category : #events }
MASimulationManager >> positionChangedFor: anInsect oldPos: aPoint newPos: anotherPoint [

	"Add or update the insect position in the dictionary."

	"remove the old position."

	(insectsPos includesKey: aPoint) ifTrue: [ 
		(insectsPos at: aPoint) remove: anInsect ifAbsent: [  ].
		(insectsPos at: aPoint) isEmpty ifTrue: [ 
			insectsPos removeKey: aPoint ] ].

	"Add to the new position."
	(insectsPos includesKey: anotherPoint)
		ifFalse: [ 
			| collection |
			collection := OrderedCollection new.
			collection add: anInsect.
			insectsPos add: anotherPoint -> collection ]
		ifTrue: [ (insectsPos at: anotherPoint) addLast: anInsect ]
]

{ #category : #events }
MASimulationManager >> queenLaid [

	"Creation of a new ant."

	self createAnt
]

{ #category : #private }
MASimulationManager >> removeAntHill [

	"Delete nbAnt ants"

	ants do: [ :e | MAAnt stop: e componentName ].
	ants := nil.
	nbAnt := 0.
	self isAntHillCreated: false
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

	"delete all pheromones of the system."

	pheromones := nil.
	MAPheromones stop: 'Pheromones'
]

{ #category : #events }
MASimulationManager >> stageChanged: aSymbol for: anAnt [

	"Removing an ant"

	aSymbol = #dead ifTrue: [ ants remove: anAnt. MAAnt stop: anAnt componentName]
]

{ #category : #services }
MASimulationManager >> start [

	self isRunning ifTrue: [ ^ self ].
	self isAntHillCreated ifFalse: [ self createAntHill ].
	self createInsects.
	self startSimulationLoop.
	isRunning := true.
	self getTMASimulationToGlobalEventsNotifier started
]

{ #category : #private }
MASimulationManager >> startSimulationLoop [

	simulationThread ifNil: [ 
		simulationThread := [ 
		                    [ true ] whileTrue: [ 
			                    self getTMASimulationToGlobalEventsNotifier
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
	self getTMASimulationToGlobalEventsNotifier stopped
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
	"Removing the insect in the dictionary."
	(insectsPos includesKey: aPoint) ifTrue: [ 
		insect := (insectsPos at: aPoint) removeFirst.
		(insectsPos at: aPoint) isEmpty ifTrue: [ 
			insectsPos removeKey: aPoint ] ].

	"Stoping the insect's component instance."
	MAInsect stop: insect componentName
]

{ #category : #events }
MASimulationManager >> workerExploringPositionChanged: aPoint for: anAnt [

	"Creation or update of a new pheromone of exploration."

	self getTMASimulationToGlobalEventsNotifier
		pheromoneNew: aPoint
		for: anAnt
]

{ #category : #events }
MASimulationManager >> workerReturningPositionChanged: aPoint for: anAnt [

	"Creation or update of a new pheromone of return."

	self getTMASimulationToGlobalEventsNotifier
		pheromoneReturnNew: aPoint
		for: anAnt
]
