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

### Simulation

...

#### TMASimulationToGlobalEvents

This event is consumed by all the entities of the simulation: ground, ants, insects and pheromones. Thanks to this event, the simulation loop in the simulation thread send at each step of the simulation the *simulationStepSent* message to all the entities. This permit for each entites of the simulation to do their actions. 

This events also provides two messages: *pheromoneNew:for:* and *pheromoneReturnNew:for*, that needs to be implemented by the pheromone component. This two messages notify the Pheromone component of a pheromone creation or update.

#### TMASimulationServices

This service is used by the ground and the ants. It describe methods, that the simulation need to implement. Some of this methods permit to get information about the simulation. As all alive ants instances, insects positions, and all pheromones positions and informations about them. This information are used in the different implementations of ants to do consistent actions and in the ground to draw entities.

This service also describe two methods that the simulation need to implement: start/stop. And a variable: isRunning that the simulation implementation needs to keep up to date.

### Insects

The actual implementation of the *TMAInsectsType*: *MAInsect*, describe one insect. It means that if they are 50 insects on the simulation, their is also 50 instances of *MAInsects*. This implementation is very simple, insect only move on the ground randomly (waiting to be eaten...) at each step of the simulation.

#### TMAInsectEvents

Insects provide this events that is consumed by the simulation manager. This event describe one method *positionChnagedFor:oldPos:newPos:* that aim to be implemented by the simulation manager to keep the dictionary of insect positions up to date.

### Pheromones

The actual implementation of the *TMAPheromonesType*: *MAPheromones*, manage all the pheromones of the simulation. Pheromones are stored in two dictionary, one for exploration pheromones and one for returning pheromones. Dictionaries has for key: the position and for value: an association: (an Ant -> an Integer). In this association the ant represent the last ant that visit the pheromone and the integer represent the intensity of the the pheromone.

Pheromones are created by ants whe they are moving on the ground and if an ant move on a position where a pheromone already exists the pheromone is only update (intensity set to maximum). And at each step of the simulation each pheromone intensity is decreased by one.

#### TMAPheromoneServices

This service is provided by the pheromone implementation and used by the ground and the simulation manager. It provide two methods to retrieve the pheromones dictionaries. This aim to draw pheromones on the canvas and to detect if an ant is around pheromones.

### Ants

#### TMAAntServices

### Stages

#### TMAStageServices

#### TMAStageEvents

### Roles

#### TMARolesServices

#### TMARolesEvents

### Ground
