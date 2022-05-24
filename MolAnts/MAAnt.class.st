Class {
	#name : #MAAnt,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsType + TMAAntServices + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsType classTrait + TMAAntServices classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #'MolAnts-Model'
}

{ #category : #accessing }
MAAnt >> ageInMs [

	^ ageInMs
]

{ #category : #'life cycle' }
MAAnt >> componentActivate [

	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAAnt >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	self initializeStage.
	
	self forServices: TMAStageServices useProvider: (#stage, self componentName asSymbol) asSymbol.

	ageInMs := 0.
]

{ #category : #'life cycle' }
MAAnt >> componentPassivate [

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAAnt >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self removeStage.
	position := nil.
	ageInMs := nil.
	stage := nil.
]

{ #category : #private }
MAAnt >> doSimulationStep [

	self getStage isAlive ifTrue: [ 
		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self getStage doSimulationStepFor: self.
		self position: (self getStage moveFrom: self).  
	].
]

{ #category : #services }
MAAnt >> getInsects [

	^ self getTMASimulationServicesProvider insectsPos. 
]

{ #category : #services }
MAAnt >> getPheromonesDict [

	^ self getTMASimulationServicesProvider getPheromonesDict.
]

{ #category : #accessing }
MAAnt >> getRoleName [

	^ self getTMAStageServicesProvider getRoleName.
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
