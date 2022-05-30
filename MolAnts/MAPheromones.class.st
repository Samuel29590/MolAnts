Class {
	#name : #MAPheromones,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMAPheromoneServices + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMAPheromoneServices classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'maxIntensity',
		'pheromonesReturnDict',
		'pheromonesDict'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAPheromones class >> maxIntensity [

	^ 200
]

{ #category : #'life cycle' }
MAPheromones >> componentActivate [

	"Activation of the MAPheromones component."
	self getTMASimulationToGlobalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentInitialize [

	"Initialization of the MAPheromones component."

	maxIntensity := 100.

	pheromonesDict := OrderedCollection new.
	pheromonesDict add: Dictionary new.
	pheromonesDict add: Dictionary new.
	pheromonesDict add: Dictionary new.
	pheromonesDict add: Dictionary new.

	pheromonesReturnDict := Dictionary new
]

{ #category : #'life cycle' }
MAPheromones >> componentPassivate [

	"Passivating the MAPheromones component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentRemove [

	"Removing the MAPheromones component."

	pheromonesDict := nil.

	pheromonesReturnDict := nil
]

{ #category : #'events - lifecycle' }
MAPheromones >> doSimulationStep [

	"At each step, all pheromones loose 1 to their intensity. If a pheromone has 0 as intensity it's remove from the dictionaries."

	pheromonesDict do: [ :value | 
		value keysDo: [ :each | 
			value at: each update: [ :v | v value: v value - 1 ].
			(value at: each) value <= 0 ifTrue: [ value removeKey: each ] ] ].

	pheromonesReturnDict keysDo: [ :each | 
		pheromonesReturnDict at: each update: [ :v | v - 1 ].
		(pheromonesReturnDict at: each) <= 0 ifTrue: [ 
			pheromonesReturnDict removeKey: each ] ]
]

{ #category : #services }
MAPheromones >> getMaxIntensity [

	^ maxIntensity.
]

{ #category : #services }
MAPheromones >> getPheromonesDict: aPoint [

	aPoint x < (MASimulationManager simulationWidth / 2)
		ifTrue: [ 
			aPoint y < (MASimulationManager simulationHeight / 2)
				ifTrue: [ ^ pheromonesDict at: 1 ]
				ifFalse: [ ^ pheromonesDict at: 3  ] ]
		ifFalse: [ 
			aPoint y < (MASimulationManager simulationHeight / 2)
				ifTrue: [ ^ pheromonesDict at: 2 ]
				ifFalse: [ ^ pheromonesDict at: 4 ] ]
]

{ #category : #services }
MAPheromones >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #events }
MAPheromones >> pheromoneNew: aPoint for: anAnt [

	"Adding or updating a pheromone of exploration at a specific point."

	aPoint x < (MASimulationManager simulationWidth / 2 + 5)
	& (aPoint y < (MASimulationManager simulationHeight / 2 + 5)) 
		ifTrue: [ 
			((pheromonesDict at: 1) includesKey: aPoint)
				ifFalse: [ "The following code permit to not create pheromones in the ant hill. In order to keep the ant hill clear."
					| pointRectangle antHillRectangle |
					pointRectangle := BlBounds
						                  origin: anAnt position - (20 @ 20)
						                  extent: 40 @ 40.

					antHillRectangle := BlBounds
						                    origin:
						                    MASimulationManager
							                    simulationAntHillPosition
						                    extent: 0 @ 0.
					(pointRectangle intersects: antHillRectangle) ifFalse: [ 
						(pheromonesDict at: 1) add: aPoint -> (anAnt -> maxIntensity) ] ]
				ifTrue: [ (pheromonesDict at: 1) at: aPoint put: anAnt -> maxIntensity ] ].

	aPoint x < (MASimulationManager simulationWidth / 2 + 5)
	& (aPoint y > (MASimulationManager simulationHeight / 2 - 5)) 
		ifTrue: [ 
			((pheromonesDict at: 3) includesKey: aPoint)
				ifFalse: [ "The following code permit to not create pheromones in the ant hill. In order to keep the ant hill clear."
					| pointRectangle antHillRectangle |
					pointRectangle := BlBounds
						                  origin: anAnt position - (20 @ 20)
						                  extent: 40 @ 40.

					antHillRectangle := BlBounds
						                    origin:
						                    MASimulationManager
							                    simulationAntHillPosition
						                    extent: 0 @ 0.
					(pointRectangle intersects: antHillRectangle) ifFalse: [ 
						(pheromonesDict at: 3) add: aPoint -> (anAnt -> maxIntensity) ] ]
				ifTrue: [ (pheromonesDict at: 3) at: aPoint put: anAnt -> maxIntensity ] ].

	aPoint x > (MASimulationManager simulationWidth / 2 - 5)
	& (aPoint y < (MASimulationManager simulationHeight / 2 + 5)) 
		ifTrue: [ 
			((pheromonesDict at: 2) includesKey: aPoint)
				ifFalse: [ "The following code permit to not create pheromones in the ant hill. In order to keep the ant hill clear."
					| pointRectangle antHillRectangle |
					pointRectangle := BlBounds
						                  origin: anAnt position - (20 @ 20)
						                  extent: 40 @ 40.

					antHillRectangle := BlBounds
						                    origin:
						                    MASimulationManager
							                    simulationAntHillPosition
						                    extent: 0 @ 0.
					(pointRectangle intersects: antHillRectangle) ifFalse: [ 
						(pheromonesDict at: 2) add: aPoint -> (anAnt -> maxIntensity) ] ]
				ifTrue: [ (pheromonesDict at: 2) at: aPoint put: anAnt -> maxIntensity ] ].

	aPoint x > (MASimulationManager simulationWidth / 2 - 5)
	& (aPoint y > (MASimulationManager simulationHeight / 2 - 5)) 
		ifTrue: [ 
			((pheromonesDict at: 4) includesKey: aPoint)
				ifFalse: [ "The following code permit to not create pheromones in the ant hill. In order to keep the ant hill clear."
					| pointRectangle antHillRectangle |
					pointRectangle := BlBounds
						                  origin: anAnt position - (20 @ 20)
						                  extent: 40 @ 40.

					antHillRectangle := BlBounds
						                    origin:
						                    MASimulationManager
							                    simulationAntHillPosition
						                    extent: 0 @ 0.
					(pointRectangle intersects: antHillRectangle) ifFalse: [ 
						(pheromonesDict at: 4) add: aPoint -> (anAnt -> maxIntensity) ] ]
				ifTrue: [ (pheromonesDict at: 4) at: aPoint put: anAnt -> maxIntensity ] ]
]

{ #category : #events }
MAPheromones >> pheromoneReturnNew: aPoint for: anAnt [

	"Adding or updating a pheromone of return at a specific point."

	(pheromonesReturnDict includesKey: aPoint)
		ifFalse: [ pheromonesReturnDict add: aPoint -> maxIntensity ]
		ifTrue: [ 
			pheromonesReturnDict
				at: aPoint
				update: [ :v | v - v + maxIntensity ] ]
]
