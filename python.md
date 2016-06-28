---
layout: pagetoc
title: Python
---

Some notes on my recent attempt to learn Python.

## Naming and formatting

+ Use lowercase `_`-separated for modules and functions name. E.g. `my_function`.
+ Use CapsWord for classes. E.g. `MyClass`.
+ Use `_` prefix for private variable. E.g. `_secret_variable`.

## Data structures

### Array

~~~python
arr = [3]
arr.append(19)
for elt in arr:
    print elt
~~~

### Hash

Hash tables or dictionaries holds unordered sets of key/value pairs.

~~~python
a_hash = {'bob': 42, 'kevin': 7}
~~~

### Class

## Strings

~~~python
'tempString' + another_string + str(an_integer)
line.split('\t')
~~~

+ `rstrip` removes the trailing characters. By defaut, white spaces. `s.rstrip('\t\n')` removes *any combination* of tabs and new lines.

## Input/Output

To read a file line by line:

~~~python
for line in open(input_file)
    line.rstrip('\n')
~~~

Or in one line:

~~~python
lines = [line.rstrip('\n') for line in open(input_file)]
~~~

To write a file:

~~~python
f = open(output_file, 'w')
f.write('something' + str(an_integer) + '\n')
f.close()
~~~

## Files structure, packages and imports

There should be a `__init__.py` file **in each directory containing modules** to import. It can be empty. If not the code inside is run on import.

To import the classes defined in file `class1.py`, simply do

~~~python
import class1
~~~

## Passing arguments to a script

The quick way is to use `sys.argv` like that:

~~~python
import sys
in1 =  sys.argv[1]
~~~

The more fancy way is to use `argparse`. I usually use it like this (see the [doc](https://docs.python.org/2/library/argparse.html) for a more complete example):

~~~python
import argparse

parser = argparse.ArgumentParser(description='Do something cool.')
parser.add_argument('-in', dest='input', help='the input file')
parser.add_argument('-k', dest='k', default=3, type=int, help='an integer')
parser.add_argument('-out', dest='output', help='the output file')

args = parser.parse_args()
print args.input
print args.k
print args.output
~~~


## Tricks

+ When iterating, use `xrange` instead of `range`. It's faster and more memory efficient.
+ Sort elements with `sorted(a_list, key=lambda k: -something[k])`.

When filling a nested dictionary, it's painful to always test if the key exists before updating it's value. One trick is to use `try`/`except`. It's not that much quicker but it looks fancier so you forget about the *pain*:

~~~python
try:
    dict[lev1].append(i)
except KeyError:
    dict[lev1] = [i]
~~~

## Bioinfo

BioPython main documentation is available [here](http://biopython.org/DIST/docs/tutorial/Tutorial.html). What I ended up using are the following.

### Sequences

~~~python
from Bio.Seq import MutableSeq
from Bio.Alphabet import generic_dna

mseq = MutableSeq('ATGCTAGCT', generic_dna)
len(mseq)
str(mseq[3:6])
~~~

To simulate sequences, I ended up using *numpy* arrays (I think they could take a list as indexes).

~~~python
import numpy
import random
from Bio.Seq import MutableSeq
from Bio.Alphabet import generic_dna

_nuc = numpy.array(["A", "T", "C", "G"])
def randSeq(length):
    seqArray = _nuc[[int(random.random()*4) for i in xrange(length)]]
    return(MutableSeq("".join(seqArray), generic_dna))
~~~

### Fasta

To read a fasta file:

~~~python
from Bio import SeqIO

for record in SeqIO.parse(fasta_file, "fasta"):
    print record.id + '\t' + str(len(record.seq))
~~~

To write a fasta:

~~~python
recs = []
for ii in xrange(1000):
    seq = randSeq(100))
    recs.append(SeqRecord(seq, id=str(ii))) 
SeqIO.write(recs, "reads.fa", "fasta")
~~~

#### Indexed fasta

I use `pyfaidx` (see [repo](https://github.com/mdshw5/pyfaidx)) to quickly access slices of an indexed fasta. The indexing can be performed by `samtools faidx` or functions from the package.

~~~python
from pyfaidx import Fasta

fa = Fasta(args.ref)
fa = fa[str(ch)][start:end]
print fa.id + '\t' + fa.seq
~~~


