Class {
	#name : #MAFeedingPoint,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAFeedingPointType + TMAFeedingPointServices',
	#classTraits : 'MolComponentImpl classTrait + TMAFeedingPointType classTrait + TMAFeedingPointServices classTrait',
	#instVars : [
		'position',
		'capacity'
	],
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAFeedingPoint >> componentInitialize [

	capacity := 10.
	position := (Random new
			           nextIntegerBetween: 1
			           and: MASimulationManager simulationWidth) @ (Random new
			           nextIntegerBetween: 1
			           and: MASimulationManager simulationHeight)
]

{ #category : #events }
MAFeedingPoint >> eated [

	capacity := capacity - 1.
	^ capacity
]

{ #category : #accessing }
MAFeedingPoint >> position [

	^position
]
