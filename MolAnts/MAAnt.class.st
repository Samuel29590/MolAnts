Class {
	#name : #MAAnt,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsType + TMAAntServices + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsType classTrait + TMAAntServices classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAAnt >> ageInMs [

	^ ageInMs
]

{ #category : #'life cycle' }
MAAnt >> componentActivate [
	
	"Activation of the MAAnt component."
	
	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAAnt >> componentInitialize [

	"Initialization of the MAAnt component."

	self initializeStage.

	self
		forServices: TMAStageServices
		useProvider: (#stage , self componentName asSymbol) asSymbol.

	ageInMs := 0
]

{ #category : #'life cycle' }
MAAnt >> componentPassivate [

	"Passivating the MAAnt component."
	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAAnt >> componentRemove [
	"Removing the MAAnt component."

	self removeStage.
	position := nil.
	ageInMs := nil.
	stage := nil
]

{ #category : #private }
MAAnt >> doSimulationStep [

	"Updating the age of the ant, then performing the action and the move of the ant."

	self getStage isAlive ifTrue: [ 
		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self getStage doSimulationStepFor: self.
		self position: (self getStage moveFrom: self) ]
]

{ #category : #services }
MAAnt >> getInsects [

	^ self getTMASimulationServicesProvider getInsectsPos. 
]

{ #category : #services }
MAAnt >> getPheromonesDict [

	^ self getTMASimulationServicesProvider getPheromonesDict: position.
]

{ #category : #services }
MAAnt >> getRole [

	"Returning the MARole's subclass associate to the MAStage associate to this ant."

	^ stage getRole
]

{ #category : #accessing }
MAAnt >> getRoleName [

	^ self getTMAStageServicesProvider getRoleName.
]

{ #category : #services }
MAAnt >> getStage [

	"Returning the MAStage associate to this ant."

	^ stage
]

{ #category : #accessing }
MAAnt >> getStageName [

	^ self getTMAStageServicesProvider getStageName.
]

{ #category : #'component accessing' }
MAAnt >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMASimulationServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAAnt >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAAnt >> getTMAStageServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMAStageServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMAStageServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #stage }
MAAnt >> initializeStage [

	stage := MAStage start: (#stage, self componentName asSymbol) asSymbol
]

{ #category : #accessing }
MAAnt >> position [

	^ position
]

{ #category : #accessing }
MAAnt >> position: aPoint [

	position := aPoint.
]

{ #category : #stage }
MAAnt >> removeStage [

	MAStage stop: (#stage, self componentName asSymbol) asSymbol
]
