"
To start the simulation :

MASimulationManager start.
"
Class {
	#name : #ManifestMolAnts,
	#superclass : #PackageManifest,
	#category : #'MolAnts-Manifest'
}

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleAssignmentInIfTrueRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MAWorker #moveFrom: #false)) #'2022-05-19T11:19:29.69331+02:00') #(#(#RGMethodDefinition #(#MAWorker #avoidPheromones:for: #false)) #'2022-05-19T13:59:34.536525+02:00') #(#(#RGClassDefinition #(#MAWorker)) #'2022-05-23T15:18:05.156659+02:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleCascadedNextPutAllsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#MASimulationManager)) #'2022-05-16T10:44:22.139683+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-16T12:30:20.492871+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleEndTrueFalseRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#MAWorker)) #'2022-05-23T16:29:40.786383+02:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleEquivalentSuperclassMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BlPheromone #fullDrawOnSpartaCanvas: #false)) #'2022-05-20T11:32:40.936812+02:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-13T07:29:41.80178+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MAWorker #moveFrom: #false)) #'2022-05-18T11:02:23.093201+02:00') #(#(#RGClassDefinition #(#MAWorker)) #'2022-05-23T16:29:45.158579+02:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleNoClassCommentRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-20T10:52:41.686206+02:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleReGuardClauseRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-13T07:29:44.66026+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleReTemporaryVariableCapitalizationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MAFighter #moveFrom: #false)) #'2022-05-16T13:17:48.511458+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MASimulationManager #start #false)) #'2022-05-12T14:12:58.495687+01:00') #(#(#RGClassDefinition #(#MASimulationManager)) #'2022-05-12T14:19:02.133629+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MASimulationManager #start #false)) #'2022-05-12T13:21:16.824486+01:00') #(#(#RGClassDefinition #(#MASimulationManager)) #'2022-05-12T14:18:59.859494+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MAWorker #moveFrom: #false)) #'2022-05-20T10:15:12.898008+02:00') #(#(#RGClassDefinition #(#MAWorker)) #'2022-05-23T15:18:09.187734+02:00') )
]
