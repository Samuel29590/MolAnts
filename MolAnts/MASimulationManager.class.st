Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMAStateEvents + TMASimulationServices',
	#classTraits : 'TMASimulationManagerType classTrait + TMAStateEvents classTrait + TMASimulationServices classTrait',
	#instVars : [
		'simulationThread',
		'ground',
		'isAntHillCreated'
	],
	#category : #'MolAnts-Core'
}

{ #category : #properties }
MASimulationManager class >> simulationStepDurationInMs [

	^ 50
]

{ #category : #scripts }
MASimulationManager class >> startSimulation [
	<script>
	
	self start.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [ 

	super componentActivate.
	ground := MAGround start. 

	self start.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [ 
	"Create a ground"

	super componentInitialize.

]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	self getTMAStateEventsSubscriber unsubscribe: self.

	self stop.

	super componentPassivate.

]

{ #category : #private }
MASimulationManager >> createAntHill [

	"Create x ants"
	1 to: 50 do:[ :e | | ant name |
		"Create Ant"
		name := ('Ant', e printString) asSymbol.
		ant := MAAnt start: name.
		ant position: 200@200.

		"Adding events producer into SimulationMManager and Ground"
		self forEvents: TMAStateEvents addProducer: name. 
		ground forEvents: TMAPositionEvents addProducer: name.
		
		"Notify Ant creation"
		self getTMASimulationEventsNotifier antBorn: ant.
	].

	self flag:'PLA : deux bugs à résoudre, ne pas tenir compte de lordre entre addProducer and subscribe + pouvoir relancer la simulation après un Stop'.
	self getTMAStateEventsSubscriber subscribe: self.
	ground getTMAPositionEventsSubscriber subscribe: ground.
	
	self isAntHillCreated: true.
]

{ #category : #'component accessing' }
MASimulationManager >> getTMASimulationEventsNotifier [
	^self eventsNotifiers at: TMASimulationEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationEvents name: nil].
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAStateEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAStateEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAStateEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated [

	^ isAntHillCreated ifNil:[ isAntHillCreated := false ]
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated: anObject [

	isAntHillCreated := anObject
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

{ #category : #private }
MASimulationManager >> removeAntHill [

	"Delete x ants"
	1 to: 50 do:[ :e | | name |
		"Delete Ant"
		name := ('Ant', e printString) asSymbol.
		MAAnt stop: name.
	].

	self flag:'PLA : il faut corriger le problème de déclaration des providers pour pouvoir refaire un play derrière'.
	
	self isAntHillCreated: false.
]

{ #category : #services }
MASimulationManager >> start [

	self isRunning ifTrue:[^self].

	self isAntHillCreated ifFalse:[self createAntHill].

	self startSimulationLoop.

	isRunning := true.
	self getTMASimulationEventsNotifier started.
]

{ #category : #private }
MASimulationManager >> startSimulationLoop [

	simulationThread ifNil:[
		simulationThread := [
			[true] whileTrue: [ 
				self getTMASimulationEventsNotifier simulationStepSent.
				(Delay forMilliseconds: self class simulationStepDurationInMs) wait. 	
			].
		] newProcess priority: Processor userBackgroundPriority.

		simulationThread name: 'Molecule SimulationManager Process'.
	].
	
	simulationThread resume.
]

{ #category : #events }
MASimulationManager >> stateChanged: aSymbol for: aModelObject [

	aSymbol = #dead ifFalse:[^self].
	
	self getTMASimulationEventsNotifier antDead: aModelObject.
]

{ #category : #services }
MASimulationManager >> stop [

	self stopSimulationLoop.

	self isAntHillCreated ifTrue:[	self removeAntHill ].

	isRunning := false.
	self getTMASimulationEventsNotifier stopped.
]

{ #category : #private }
MASimulationManager >> stopSimulationLoop [

	simulationThread ifNil:[^self].

	simulationThread terminate.
	simulationThread := nil.	
	
]