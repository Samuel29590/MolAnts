"
The actual implementation of the TMAFeedingPointType: MAFeedingPoint, describe one feeding point. This implementation is very simple, feeding point only receive eated message. This message decrease their capacity and when their capacity is equal to 0 the feeding point disappear from the ground.

Variables :

-position, is a point.

-capacity, is an integer.
"
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
