### Clone rigraph repo and go back to v1.1.0 (I think it helps)

```sh
git clone --recursive https://github.com/igraph/rigraph.git
cd rigraph
git checkout -b mod v1.1.0
```

### Compile once without changes

```sh
make
```

### Add modification

```sh
cp ../rinterface.c src/rinterface.c
cp ../init.c src/init.c
cp ../community.c cigraph/src/community.c
cp ../igraph_community.h cigraph/include/igraph_community.h
cp ../community.R R/community.R
```

### Compile again

```sh
make
```

### Install package in R

In R:

```r
> install.packages('igraph_1.1.0.tar.gz')
```
