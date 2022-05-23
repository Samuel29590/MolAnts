Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'mySpace',
		'compt',
		'nbInsects',
		'nbPheromones',
		'nbEggs',
		'nbAnts',
		'time',
		'refreshing'
	],
	#category : #'MolAnts-View'
}

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeRole: aSymbol [

	aSymbol = #queen ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: 'e000ff').
			e size: 6@6.
			e relocate: (aModelObject position - (3@3)).
		].
	].

	aSymbol = #fighter ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '68ff00').
			e size: 4@4.
			e relocate: (aModelObject position - (2@2)).
		].
	].
]

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeStage: aSymbol [
	
	aSymbol = #adult ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '#DFFF00').
			e size: 4@4.
			e relocate: (aModelObject position - (2@2)).
		].
	].
]

{ #category : #'life cycle' }
MAGround >> componentActivate [
	
	self getTMASimulationEventsSubscriber subscribe: self.

]

{ #category : #'life cycle' }
MAGround >> componentInitialize [

	compt := 0.
	refreshing := 5.
	mySpace := self openInNewSpace extent:
		           MASimulationManager simulationWidth
		           @ (MASimulationManager simulationHeight + 200).

	self createInfoPanel
]

{ #category : #'life cycle' }
MAGround >> componentPassivate [
	
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAGround >> componentRemove [
	
	compt := 0.
	self stopped.
	mySpace ifNotNil:[
		mySpace close.
	].
]

{ #category : #initialization }
MAGround >> createInfoPanel [

	| infoPanel button |
	infoPanel := BlElement new.
	infoPanel background: Color lightGray.
	infoPanel relocate: 0 @ MASimulationManager simulationHeight.
	infoPanel size: MASimulationManager simulationWidth @ 200.
	infoPanel constraintsDo: [ :c | 
		c maxHeight: 200.
		c horizontal matchParent ].
	mySpace addChild: infoPanel.


	"Adding Pause button"
	button := BlElement new.
	button background: Color orange.
	button size: 100 @ 25.
	button relocate: 50 @ 10.
	button addChild:
		((BlTextElement new relocate: 30 @ 5) text: 'Pause' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ 
					 self isRunning ifTrue: [ MASimulationManager pauseSimulation ] ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.

	"Adding Play button"
	button := BlElement new.
	button background: Color green.
	button size: 100 @ 25.
	button relocate: 200 @ 10.
	button addChild:
		((BlTextElement new relocate: 35 @ 5) text: 'Play' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ 
					 self isRunning ifFalse: [ MASimulationManager playSimulation ] ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.

	"Adding Stop button"
	button := BlElement new.
	button background: Color red.
	button size: 100 @ 25.
	button relocate: 350 @ 10.
	button addChild:
		((BlTextElement new relocate: 35 @ 5) text: 'Stop' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ MASimulationManager stopSimulation ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.
	
	infoPanel addChild: ((BlTextElement new
			  relocate: 50 @ 50;
			  background: Color transparent) text: 'Refreshing every :' asRopedText).
			
	button := BlElement new.
	button background: Color gray.
	button size: 25 @ 20.
	button relocate: 200 @ 50.
	button addChild:
		((BlTextElement new relocate: 10 @ 5) text: '1' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ self setRefreshingTo: 1 ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.
	
	"Adding Pause button"
	button := BlElement new.
	button background: Color gray.
	button size: 25 @ 20.
	button relocate: 230 @ 50.
	button addChild:
		((BlTextElement new relocate: 10 @ 5) text: '2' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ self setRefreshingTo: 2 ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.
	
	"Adding Pause button"
	button := BlElement new.
	button background: Color gray.
	button size: 25 @ 20.
	button relocate: 260 @ 50.
	button addChild:
		((BlTextElement new relocate: 10 @ 5) text: '5' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ self setRefreshingTo: 5 ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.
	
	"Adding Pause button"
	button := BlElement new.
	button background: Color gray.
	button size: 35 @ 20.
	button relocate: 290 @ 50.
	button addChild:
		((BlTextElement new relocate: 10 @ 5) text: '10' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ self setRefreshingTo: 10 ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.
	
	"Adding Pause button"
	button := BlElement new.
	button background: Color gray.
	button size: 35 @ 20.
	button relocate: 330 @ 50.
	button addChild:
		((BlTextElement new relocate: 10 @ 5) text: '20' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ self setRefreshingTo: 20 ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.


	"Ajout de l'heure à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate: 50 @ 80;
			  background: Color transparent) text: 'Time :' asRopedText).
	time := BlTextElement new
		        relocate: 50 @ 100;
		        background: Color transparent;
		        text: '000' asRopedText.
	infoPanel addChild: time.

	"Ajout du nombre de proies à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate: 50 @ 130;
			  background: Color transparent) text:
			 'Number of insects :' asRopedText).
	nbInsects := BlTextElement new
		             relocate: 50 @ 150;
		             background: Color transparent;
		             text: '000' asRopedText.
	infoPanel addChild: nbInsects.

	"Ajout du nombre de pheromones à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate: 250 @ 130;
			  background: Color transparent) text:
			 'Nunber of pheromones :' asRopedText).
	nbPheromones := BlTextElement new
		                relocate: 250 @ 150;
		                background: Color transparent;
		                text: '000' asRopedText.
	infoPanel addChild: nbPheromones.

	"Ajout du nombre de fourmis à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate: 250 @ 80;
			  background: Color transparent) text:
			 'Number of ants :' asRopedText).

	infoPanel addChild: ((BlTextElement new
			  relocate: 250 @ 100;
			  background: Color transparent) text: 'Eggs : ' asRopedText).
	nbEggs := BlTextElement new
		          relocate: 305 @ 100;
		          background: Color transparent;
		          text: '000' asRopedText.
	infoPanel addChild: nbEggs.

	infoPanel addChild: ((BlTextElement new
			  relocate: 350 @ 100;
			  background: Color transparent) text: 'Adults : ' asRopedText).
	nbAnts := BlTextElement new
		          relocate: 415 @ 100;
		          background: Color transparent;
		          text: '000' asRopedText.
	infoPanel addChild: nbAnts
]

{ #category : #drawing }
MAGround >> drawMeAndChildrenOnSpartaCanvas: aCanvas [

	self drawOnSpartaCanvas: aCanvas.
	self drawChildrenOnSpartaCanvas: aCanvas
]

{ #category : #drawing }
MAGround >> drawOnSpartaCanvas: aCanvas [

	super drawOnSpartaCanvas: aCanvas.

	aCanvas figure
		path: (Rectangle origin: (MASimulationManager simulationAntHillPosition - (20@20)) extent: 40@40);
		background: Color white;
		draw.

	self getTMAPheromoneServicesProvider getPheromonesDict ifNotNil: [ 
		self getTMAPheromoneServicesProvider getPheromonesDict 
			keysAndValuesDo: [ :k :v | 
				aCanvas figure
					path: (aCanvas shape circleAt: k radius: 2);
					background: Color blue;
					backgroundAlpha:
						v / self getTMAPheromoneServicesProvider getMaxIntensity;
					draw ] ].

	self getTMAPheromoneServicesProvider getPheromonesReturnDict 
		ifNotNil: [ 
			self getTMAPheromoneServicesProvider getPheromonesReturnDict 
				keysAndValuesDo: [ :k :v | 
					aCanvas figure
						path: (aCanvas shape circleAt: k radius: 2);
						background: Color cyan;
						backgroundAlpha:
							v / self getTMAPheromoneServicesProvider getMaxIntensity;
						draw ] ].

	self getInsects ifNotNil: [ 
		self getInsects keysAndValuesDo: [ :k :v | 
			aCanvas figure
				path: (aCanvas shape circleAt: k radius: 2);
				background: Color black;
				backgroundAlpha: 1;
				draw ] ].
		
	self getAnts ifNotNil: [ 
		self getAnts  do: [ :ant | 
			
			ant getRoleName = #queen ifTrue: [ 
				aCanvas figure
					path: (aCanvas shape circleAt: (ant position) radius: 5);
					background: Color pink;
					backgroundAlpha: 1;
					draw ] .
			ant getRoleName = #worker ifTrue: [ 
				aCanvas figure
					path: (aCanvas shape circleAt: (ant position) radius: 3);
					background: Color orange;
					backgroundAlpha: 1;
					draw ].
			ant getRoleName = #fighter ifTrue: [ 
				aCanvas figure
					path: (aCanvas shape circleAt: (ant position) radius: 3);
					background: Color green;
					backgroundAlpha: 1;
					draw ]
			] ] 
]

{ #category : #services }
MAGround >> getAnts [

	^ self getTMASimulationServicesProvider ants. 
]

{ #category : #services }
MAGround >> getInsects [

	^ self getTMASimulationServicesProvider insectsPos. 
]

{ #category : #'component accessing' }
MAGround >> getTMAPheromoneServicesProvider [
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
MAGround >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAGround >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMASimulationServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #initialization }
MAGround >> initialize [ 

	super initialize.
	self size: (MASimulationManager simulationWidth + 5)@(MASimulationManager simulationHeight + 5).
	

	self background: (Color fromHexString: 'c7baae').
]

{ #category : #services }
MAGround >> isRunning [

	^ self getTMASimulationServicesProvider isRunning. 
]

{ #category : #events }
MAGround >> positionChanged: aPoint for: aModelObject [

	self childWithId: aModelObject componentName ifFound: [ :e |
		e relocate: (aModelObject position - (2@2)).
	].
]

{ #category : #initialization }
MAGround >> setRefreshingTo: anInteger [

	refreshing := anInteger.
]

{ #category : #'events - lifecycle' }
MAGround >> simulationStepSent [

	compt := compt + 1.
	compt % refreshing = 0 ifTrue: [ self updateInfoPanel ]
]

{ #category : #'events - control' }
MAGround >> stopped [

	self removeChildren 	
]

{ #category : #initialization }
MAGround >> updateInfoPanel [

	| eggs |
	time text: compt asRopedText.
	nbInsects text: self getInsects size asRopedText.
	nbPheromones text:
		(self getTMAPheromoneServicesProvider getPheromonesDict size
		 + self getTMAPheromoneServicesProvider getPheromonesReturnDict size)
			asRopedText.

	eggs := 0.
	self getAnts do: [ :ant | 
		ant getStageName = #egg ifTrue: [ eggs := eggs + 1 ] ].
	nbEggs text: eggs asRopedText.
	nbAnts text: (self getAnts size - eggs) asRopedText
]

{ #category : #'events - lifecycle' }
MAGround >> workerEat: anAnt [

	self childWithId: anAnt componentName ifFound: [ :e |
		e background: Color orange.	
	].
]
