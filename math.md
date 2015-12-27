---
layout: pagetoc
title: Math/Stats
---

All of this is mostly extracted from [Wikipedia](https://en.wikipedia.org). These notes are exactly fitter to my fragmented knowledge/memory, the purpose is to fill the gaps, not to fully review the concepts.

## Probability distributions

### Binomial

### Normal

### Poisson

### Beta-binomial



## Statistical tests

### Student t-test

### Fisher test

### \\(\chi^2\\)

### Wilcoxon

### ANOVA

## Regression

### Linear regression

### LASSO

### LOESS


## Misc stats

### Markov Model

### Monte Carlo methods

### MCMC

### Hidden Markov Model

Hidden Markov Model (HMM) is a Markov chain where the states are unknown but an output, that depends on the state, is visible. A HMM is defined by a set of states (*X*) with transition (*a*) and emission (*b*) probabilities, and produces an observed variable *y*: 

![HMM](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/HiddenMarkovModel.svg/600px-HiddenMarkovModel.svg.png)

The [forward algorithm](https://en.wikipedia.org/wiki/Forward_algorithm) uses *dynamic programming* to **compute the probability of an observed sequence**, i.e. when the parameters of the HMM are known.

[Viterbi algorithm](https://en.wikipedia.org/wiki/Viterbi_algorithm) goes further and retrieves the **most likely sequence of states for an observed sequence**. The *dynamic programming* approach is very similar to the forward algorithm.

[Baum-Welch algorithm](https://en.wikipedia.org/wiki/Baum%E2%80%93Welch_algorithm) **finds the unknown parameters of a HMM** from an observed sequence. It's an *Expectation-Maximization method*. After initialization of the HMM parameters, the observed sequence and forward-backward are used to compute the probability of being in state *i* at time *t*. New parameters are then derived from these probabilities.



### Maximum Likelihood Estimation

### Expectation-Maximization

### Bayesian vs Frequentist



## Graph theory

### De Bruijn graphs

### Hamiltonian path

### Euclidian path



## Algebra

### SVD decomposition

### PCA
