# MolAnts

This project is inspired by an another project on pharo: ![Ants](https://github.com/plantec/Ants), and this version uses: ![Molecule](https://github.com/OpenSmock/Molecule).

## Getting Started

### Installing MolAnts

Add the repository directly in Pharo thanks to the Iceberg.

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAnts require ![Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and ![Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.
  
## Overview of the Components, Types, Services and Events organisation with Molecule

![MolAnts_schema](https://user-images.githubusercontent.com/64481702/170274425-ee86664e-7058-4b37-931c-5653caa19a8d.svg)

## Simulation

The actual implementation of the *TMASimulationManagerType*: *MASimulationManager*, describe the manager of the MolAnts's system. It aims to put in relation every entity of the system. The simulation manager reference all the entities of the system in ordered collections or dictionaries and can access to all the entities and send them events. This feature permits to do concrete actions as interaction between ants and insects or ants and pheromones.

Futhermore, the simulation manager contains the main loop of the system. This loop send the *simulationStepSend* event message to each entity at each turn.

The simulation manager also implement methods to manage ants and insects (create, update and remove).

Finally this implementation provides *start / pause / play / stop* methods on the class side. Also on the side class the simulation manager provides the simulation data as step duration, width and height of the ground, and ant hill position.

***Variables :***

 -*isFirstStep*
 
 -*simulationThread*
 
 -*step*
 
 -*isAntHillCreated*
 
 -*ants*
 
 -*nbAnt*
 
 -*insectsPos*
 
 -*nbDelivered*

##### TMASimulationToGlobalEvents

This event is consumed by all the entities of the simulation: ground, ants, insects and pheromones. Thanks to this event, the simulation loop in the simulation thread send at each step of the simulation the *simulationStepSent* message to all the entities. This permit for each entity of the simulation to do their actions. 

This event also provides two messages: *pheromoneNew:for:* and *pheromoneReturnNew:for*, that needs to be implemented by the pheromone component. This two messages notify the Pheromone component of a pheromone creation or update.

##### TMASimulationServices

This service is used by the ground and the ants. It describes methods that the simulation need to implement. Some of these methods permit to get information about the simulation. As all alive ants, insects positions and all pheromones positions and data. These data are used in the different implementations of ants to do consistent actions and in the ground to draw entities.

This service also describe two methods that the simulation need to implement: *start/stop*. And a variable: *isRunning* that the simulation implementation needs to keep up-to-date.

## Insects

The actual implementation of the *TMAInsectsType*: *MAInsect*, describe one insect. It means that if there are 50 insects on the simulation, there are also 50 instances of *MAInsects*. This implementation is very simple, insect only move on the ground randomly (waiting to be eaten...) at each step of the simulation.

***Variables :***

 -*position*
 
 -*ageInMs*
 
 -*stage*
 
##### TMAInsectEvents

Insects provide this event that is consumed by the simulation manager. This event describe one method *positionChnagedFor:oldPos:newPos:* that aim to be implemented by the simulation manager to keep the dictionary of insect positions up-to-date.

## Pheromones

The actual implementation of the *TMAPheromonesType*: *MAPheromones*, manage all the pheromones of the simulation. Pheromones are stored in two dictionaries, one for exploration's pheromones and one for returning's pheromones. Dictionaries has for key: the position and for value: an association: (an Ant -> an Integer). In this association the ant represent the last ant that visits the pheromone and the integer represent the intensity of the pheromone.

Pheromones are created by ants when they are moving on the ground and if an ant moves on a position where a pheromone already exists the pheromone is only update (intensity set to maximum). And at each step of the simulation each pheromone intensity is decreased by one.

***Variables :***

 -*maxIntensity*
 
 -*pheromonesDict*
 
 -*pheromonesReturnDict*
 
##### TMAPheromoneServices

This service is provided by the pheromone implementation and used by the ground and the simulation manager. It provides two methods to retrieve the pheromones dictionaries. This aim to draw pheromones on the canvas and to detect if an ant is around pheromones.

## Ants

The actual implementation of the *TMAAntsType*: *MAAnt*, describe one ant. For each ant created there is also one *MAStage* component and one *MARole* component created. There are associate through their component name (example: ***Ant29***, ***StageAnt29*** and ***RoleStageAnt29***). The stage of the ant is created by the ant and the role is created by the stage. The implementation of the ant *MAAnt* permit to increase the age of the ant and to send to the stage the order to do the simulation step and to move.

***Variables :***

 -*position*
 
 -*ageInMs*
 
##### TMAAntServices

This service is provided by the ant implementation isn't used by another component. However, it permits to describe methods that the ant implementation need to provide.

## Stages

The actual implementation of the *TMAStageType*: *MAStage*, describe the stage of one ant. The stage manages the life cycle of an ant, it determines when an ant is an egg, an adult or when the ant is dead. It also sends to the role the order to do the simulation step and to move.

***Variables :***

 -*eggStateDurationInMs*
 
 -*adultStateDurationInMs*
 
##### TMAStageServices

This service is provided by the stage implementation and used by the ant implementation. It describes methods that the stage needs to implement because the ant implementation needs it to work correctly.

##### TMAStageEvents

Stages provide this event that is consumed by the simulation manager. This event describe one method *stageChanged:for:* that aim to be implemented by the simulation manager to remove, from the ordered collection *ants*, ants that are dead.

## Roles

The actual implementation of the *TMARoleeType*: *MARole*, describe the role of one stage. The role provides the behavior of an ant at each step. Actually roles are implemented by *MAQueen*, *MAFighter* or *MAWorker* that are subclass of *MARole*. In each different implementation there is one method: *doSimulationStepFor:* that manage the action of the ant and one method: *moveFrom:* that manage the position of the ant at each step.

##### TMARolesServices

This service is provided by the role implementation and used by the stage. It describes methods that the role needs to implement because the stage implementation needs it to work correctly.

##### TMARolesEvents

Roles provide this event that is consumed by the simulation manager. This event describes methods that aim to make the actions of the ants concrete in the system.

## Ground

The actual implementation of the *TMAGroundType*: *MAGround* is the implementation of the system's view. It permits to draw all the entities of the system on a canvas and to keep the information panel up-to-date. It also permits to have a functional interface with buttons to start, pause and stop the system and also buttons to change the refresh rate.
