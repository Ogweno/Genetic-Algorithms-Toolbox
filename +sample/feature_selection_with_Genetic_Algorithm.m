% This is an example using the Genetic Algorith framework, applied to a feature selection problem.
% The example is quite dummy, because the fitness evaluation neither split the data and train and test, nor use cross validation, etc.
% Therefore, what we want to mean is that this example is a "how to use" example, more than a "full correct example"... 
% even so, it depict several importan issues:
%     1.- Concerning the genetic algorithm, you only need to redefine the problem specific issues, id est:
%         .- How to create individuals
%         .- How to crossover and mutate individuals
%         .- How to evaluate the fitness of an individual
%     2.- Selection and replacement operators can be defined in the framework, they not need to be problem specific anymore.
%     3.- Few lines are enough to create your GA, regardless your problem
% 
% ENJOY

clear all; clc;

% Load inputs (9676 x 50) and target (9676 x 1) variables
load('+sample\dummy_data.mat');
inputs = zscore(inputs);
target = zscore(target);

% GA config
gaConfig = fsf.ga.Configuration();
gaConfig.MaximumIterations = 50;
gaConfig.PopulationSize = 50;
gaConfig.PopulationType = 'random';
gaConfig.CrossoverRate = 0.8;
gaConfig.MutationRate = 0.03;

% GA operators
gaOps = fsf.ga.OperatorSet(...
                    fsf.ga.operators.selection.Random(), ...
                    sample.features.Crossover(), ...
                    sample.features.Mutation(), ...
                    fsf.ga.operators.replacement.Elitism());

% Factory to create individuals
problem_dimensions = size(inputs, 2);
gaIndFactArgs = sample.features.IndividualFactoryArgs(problem_dimensions);
gaIndFact = sample.features.IndividualFactory(gaIndFactArgs);

% Fitness evaluator
gaFitEvaluator = sample.features.FitnessEvaluator(inputs, target);

ga = fsf.ga.GeneticAlgorithm(gaConfig, gaOps, gaFitEvaluator, gaIndFact);

gaGUI = sample.dummy_GUI();
ga.addlistener('IterationEnds', @gaGUI.Plot);

gaResult = ga.Execute();

