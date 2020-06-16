Latent random variables, as opposed to observable random variables, are random variables that are not directly observed but are rather inferred through a probabilistic model from other observable random variables. 

Probabilistic models that aim to explain observed random variables in terms of latent random variables are called latent variable models.

Sometimes latent variables correspond to aspects of physical reality, which could in principle be measured, but may not be for practical reasons. In this situation, the term hidden variables is commonly used (reflecting the fact that the variables are "really there", but hidden). Other times, latent variables correspond to abstract concepts, like categories, behavioral or mental states, or data structures. The terms hypothetical variables or hypothetical constructs may be used in these situations.

One advantage of using latent variables is that they can serve to reduce the dimensionality of data. A large number of observable variables can be aggregated in a model to represent an underlying concept, making it easier to understand the data. In this sense, they serve a function similar to that of scientific theories. At the same time, latent variables link observable ("sub-symbolic") data in the real world to symbolic data in the modeled world.


Suppose we have two or more `RandomVariables` where only *one* of them may be
directly *observed* and the remaining, denoted *latent* random variables, are
not directly observable. However, suppose we have additional random variables
for which 

$$
P[X = x, Y = y, Z = z]
$$

Suppose we can only observe X and Z and wish to know which value Y realized.
If Y is in some way correlated with X or Z, then observing X or Z conveys
information about Y.

$$
P[Y = y | X = x, Z = z]
$$



A `Masked` observation consists of two parts.

The first part is a point valueindicating a value of statistical interest and the second part is a *set* of
values indicating 