Class {
	#name : #MAStage,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAStageType + TMAStageServices',
	#classTraits : 'MolComponentImpl classTrait + TMAStageType classTrait + TMAStageServices classTrait',
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAStage >> componentInitialize [

	eggStateDurationInMs := (Random new next * 5000) rounded + 1000.
	adultStateDurationInMs := (Random new next * 25000) rounded + 25000.

	self initializeRole
]

{ #category : #'life cycle' }
MAStage >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self removeRole.
	eggStateDurationInMs := nil.
	adultStateDurationInMs := nil.
	role := nil.
	stageName := nil.
]

{ #category : #private }
MAStage >> computeStageFor: anAnt [

	self getStageName = #egg ifTrue: [ 
		anAnt ageInMs > eggStateDurationInMs ifTrue: [ 
			stageName := #adult.
			self
				forServices: TMARoleServices
				useProvider: (#role , self componentName asSymbol) asSymbol ].
		^ self ].

	self getStageName = #adult ifTrue: [ 
		anAnt ageInMs > adultStateDurationInMs ifTrue: [ 
			stageName := #dead.
			self getTMAStageEventsNotifier stageChanged: stageName for: anAnt ].
		^ self ]
]

{ #category : #private }
MAStage >> doSimulationStepFor: anAnt [

	self computeStageFor: anAnt.
	
	self getStageName = #adult ifTrue:[
		self getRole doSimulationStepFor: anAnt.
	].
]

{ #category : #role }
MAStage >> getRole [

	^ role.
]

{ #category : #role }
MAStage >> getRoleName [

	^ role getRoleName.
]

{ #category : #'component accessing' }
MAStage >> getTMARoleServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMARoleServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMARoleServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAStage >> getTMAStageEventsNotifier [
	^self eventsNotifiers at: TMAStageEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAStageEvents name: nil].
]

{ #category : #initialization }
MAStage >> initializeRole [
	
	| x |
	
	componentName = #stageAnt1 ifTrue: [ 
		role := MAQueen start: (#role, self componentName asSymbol) asSymbol.
		^ self.
	].
	
	x := Random new nextIntegerBetween: 1 and: 100. 
	x=1 ifTrue: [ 
		role := MAQueen start: (#role, self componentName asSymbol) asSymbol.
		^ self.
	].
	x<26 ifTrue: [ 
		role := MAFighter start: (#role, self componentName asSymbol) asSymbol.
		^ self.
	].
	x<=100 ifTrue: [ 
		role := MAWorker start: (#role, self componentName asSymbol) asSymbol.
		^ self.
	].
]

{ #category : #testing }
MAStage >> isAlive [
	^ stageName ~= #dead.
]

{ #category : #role }
MAStage >> moveFrom: anAnt [

	self getStageName ~= #adult ifTrue:[^anAnt position].
	^ (self getRole moveFrom: anAnt).

]

{ #category : #'life cycle' }
MAStage >> removeRole [

	role ifNotNil:[
	role class stop: (#role , self componentName asSymbol) asSymbol]
]
