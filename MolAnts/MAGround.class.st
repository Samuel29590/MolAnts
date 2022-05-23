Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'mySpace',
		'compt'
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
	
	mySpace := self openInNewSpace extent: (MASimulationManager simulationWidth + 5)@(MASimulationManager simulationHeight + 5 + 100).
	
	compt := 0.
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

{ #category : #drawing }
MAGround >> drawMeAndChildrenOnSpartaCanvas: aCanvas [

	self drawOnSpartaCanvas: aCanvas.
	self drawChildrenOnSpartaCanvas: aCanvas
]

{ #category : #drawing }
MAGround >> drawOnSpartaCanvas: aCanvas [

	super drawOnSpartaCanvas: aCanvas.

	aCanvas figure
		path: (aCanvas shape
				 circleAt: MASimulationManager simulationAntHillPosition
				 radius: 20);
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

{ #category : #events }
MAGround >> positionChanged: aPoint for: aModelObject [

	self childWithId: aModelObject componentName ifFound: [ :e |
		e relocate: (aModelObject position - (2@2)).
	].
]

{ #category : #'events - lifecycle' }
MAGround >> simulationStepSent [

	compt := compt + 1.
	compt % 5 = 0 ifTrue: [ self opacity: 1 ]
]

{ #category : #'events - control' }
MAGround >> stopped [

	self removeChildren 	
]

{ #category : #'events - lifecycle' }
MAGround >> workerEat: anAnt [

	self childWithId: anAnt componentName ifFound: [ :e |
		e background: Color orange.	
	].
]
