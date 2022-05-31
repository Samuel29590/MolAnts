"
The actual implementation of the TMAStageType: MAStage, describe the stage of one ant. The stage manages the life cycle of an ant, it determines when an ant is an egg, an adult or when the ant is dead. It also sends to the role the order to do the simulation step and to move.

Variables :

-eggStateDurationInMs, is an integer to determine the duration in ms of the egg state of the ant.

-adultStateDurationInMs, is an integer to determine the duration in ms of the adult state of the ant.
"
Class {
	#name : #MAStage,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAStageType + TMAStageServices',
	#classTraits : 'MolComponentImpl classTrait + TMAStageType classTrait + TMAStageServices classTrait',
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs'
	],
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAStage >> componentInitialize [

	"Initialization of the MAStage component."

	eggStateDurationInMs := (Random new next * 5000) rounded + 1000.
	adultStateDurationInMs := (Random new next * 25000) rounded + 25000.
	self initializeRole
]

{ #category : #'life cycle' }
MAStage >> componentRemove [

	"Removing of the MAStage component."

	self removeRole.
	eggStateDurationInMs := nil.
	adultStateDurationInMs := nil.
	stageName := nil.
	role := nil
]

{ #category : #private }
MAStage >> computeStageFor: anAnt [

	"Checking if an egg hatch."

	self getStageName = #egg ifTrue: [ 
		anAnt ageInMs > eggStateDurationInMs ifTrue: [ "If the egg hatch, adding the role as a producer of TMARoleService associate to this MAStage."
			stageName := #adult.
			self
				forServices: TMARoleServices
				useProvider: (#role , self componentName asSymbol) asSymbol ].
		^ self ].

	"Checking if an adult is dead."

	self getStageName = #adult ifTrue: [ 
		anAnt ageInMs > adultStateDurationInMs ifTrue: [ "If the adult is dead, notify the MASimulationManager."
			stageName := #dead.
			self getTMAStageEventsNotifier stageChanged: stageName for: anAnt ].
		^ self ]
]

{ #category : #private }
MAStage >> doSimulationStepFor: anAnt [

	self computeStageFor: anAnt.
	self getStageName = #adult ifTrue: [ 
		self getRole doSimulationStepFor: anAnt ]
]

{ #category : #role }
MAStage >> getRole [

	^ role
]

{ #category : #role }
MAStage >> getRoleName [

	^ role getRoleName
]

{ #category : #role }
MAStage >> getStageName [

	^ stageName ifNil: [ stageName := #egg ].
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

	"Initialization of the role of an ant."

	| x |
	"The first ant is always a queen."
	componentName = #stageAnt1 ifTrue: [ 
		role := MAQueen start: (#role , self componentName asSymbol) asSymbol.
		^ self ].

	x := Random new nextIntegerBetween: 1 and: 100.
	x = 1 ifTrue: [ 
		role := MAQueen start: (#role , self componentName asSymbol) asSymbol.
		^ self ].
	x < 26 ifTrue: [ 
		role := MAFighter start: (#role , self componentName asSymbol) asSymbol.
		^ self ].
	x <= 100 ifTrue: [ 
		role := MAWorker start: (#role , self componentName asSymbol) asSymbol.
		^ self ]
]

{ #category : #testing }
MAStage >> isAlive [
	^ stageName ~= #dead.
]

{ #category : #role }
MAStage >> moveFrom: anAnt [

	"Perform the moving action of the role."

	self getStageName ~= #adult ifTrue: [ ^ anAnt position ].
	^ self getTMARoleServicesProvider moveFrom: anAnt
]

{ #category : #'life cycle' }
MAStage >> removeRole [

	"Deleting the role associate to the stage."

	role ifNotNil: [ 
		role class stop: (#role , self componentName asSymbol) asSymbol. role := nil. ]
]
