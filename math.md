---
layout: page
title: Math/Stats
---

{% include toc.html %}


All of this is mostly extracted from [Wikipedia](https://en.wikipedia.org). These notes are exactly fitted to my fragmented knowledge/memory, the purpose is to fill the gaps, not to fully review the concepts.

## Probability distributions

### Binomial

Binomial distribution models the **number of successes in *n* tries**, knowing the **probability *p* of success**, \\(\mathcal{B}(n,p)\\). It has *np* mean and \\(np(1-p)\\) variance.

\\[\mathrm{Pr}(X=k) = \binom{n}{k}p^k (1-p)^{n-k} \\]

### Hypergeometric

Hypergeometric distribution models the **number of successes** when drawing, **without replacement, *n* elements from a population of size *N* containing *K* successes**. It can be used to analyze over-/under-representation of a sub-population in a sample. Its mean is \\(n\frac{K}{N}\\). 

\\[\mathrm{Pr}(X=k) = \frac{\binom{K}{k}\binom{N-K}{n-k}}{\binom{N}{n}} \\]

### Normal

### Poisson

Poisson distribution models the **number of events occurring in an interval of time**, knowing the rate \\(\lambda\\). It has \\(\lambda\\) mean and variance. Of note a binomial distribution with large *n* and small *p* can be approximated by a Poisson with parameter *np*.

\\[\mathrm{Pr}(X=k) = \frac{\lambda^k e^{-\lambda}}{k!} \\]

*Example:* number of mutation on a strand of DNA

### Beta-binomial

Beta-binomial distribution is a **binomial** distribution in which the **probability of success follows a beta distribution**. It's often used as an over-dispersed binomial distribution. The three parameters are *n*, \\(\alpha\\) and \\(\beta\\).

### Beta

Beta distribution is defined on interval [0,1] by two shape parameters, \\(\alpha\\) and \\(\beta\\). It is often used as prior for binomial distributions.

*Example:* allele frequencies in population.



## Statistical tests

### Student t-test
Usually **tests if two distributions, assumed to be Normal, are different**. Student distribution describes the estimated mean, from a small sample size, of a normally distributed population. [Welch's t-test](https://en.wikipedia.org/wiki/Welch's_t_test) is similar but more robust to unequal variance and different sample sizes between the tested groups.

Different flavors exist, e.g one-sample vs two-sample or unpaired vs paired.

### Fisher's exact test
**Test association between two categorical classifications**. It is usually employed for small sample sizes but valid for all sample sizes. 

It models the number in the contingency table following a [hypergeometric distribution](#hypergeometric).

One difference with other test is that it assumes that the total are fixed before the sampling. *Is it a problem?*

### \\(\chi^2\\) test
Also used to test association between two categorical classifications. However it is **only suited when sample size is large and the expected values are not too low**.

### Wilcoxon test
Based on ranks, it **tests if one distribution is stochastically higher than another**. It is also called Mann-Whitney U test. Its non-parametric nature makes it robust to outliers and non-Normal or different distributions.

### ANOVA

## Regression

### Linear regression

### LASSO

### LOESS


## Misc stats

### Markov Model

### Monte Carlo methods

### MCMC

A Markov Chain Monte Carlo is **constructed to approximate a complex probability distribution**. It can be designed so that after enough iterations, the walk along the chain approximates the targeted distribution. 

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
