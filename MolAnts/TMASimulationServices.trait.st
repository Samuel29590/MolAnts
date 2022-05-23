Trait {
	#name : #TMASimulationServices,
	#instVars : [
		'isRunning'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #services }
TMASimulationServices >> getPheromonesDict [
]

{ #category : #services }
TMASimulationServices >> getPheromonesReturnDict [
]

{ #category : #services }
TMASimulationServices >> insectsPos [
]

{ #category : #services }
TMASimulationServices >> isRunning [

	^isRunning ifNil: [ isRunning := false ].
	
]

{ #category : #services }
TMASimulationServices >> pause [
]

{ #category : #services }
TMASimulationServices >> restart [
]

{ #category : #services }
TMASimulationServices >> start [
]

{ #category : #services }
TMASimulationServices >> stop [
]
