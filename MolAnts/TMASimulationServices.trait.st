Trait {
	#name : #TMASimulationServices,
	#instVars : [
		'isRunning'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #MolAnts
}

{ #category : #services }
TMASimulationServices >> getAnts [

	
]

{ #category : #services }
TMASimulationServices >> getInsectsPos [

	
]

{ #category : #services }
TMASimulationServices >> getNbDelivered [

	
]

{ #category : #services }
TMASimulationServices >> getPheromonesDict: aPoint [
]

{ #category : #services }
TMASimulationServices >> getPheromonesReturnDict [
]

{ #category : #services }
TMASimulationServices >> isRunning [

	^isRunning ifNil: [ isRunning := false ].
	
]

{ #category : #services }
TMASimulationServices >> start [
]

{ #category : #services }
TMASimulationServices >> stop [
]
