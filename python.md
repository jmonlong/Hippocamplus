---
layout: page
title: Python
---

{% include toc.html %}

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

*numpy* arrays are more efficient when the data needs to be manipulated/combined. For example it allows for some vectorized operations:

~~~python
pred_counts = numpy.zeros((4, len(rfc.classes_)))
pred_counts[0, ] += sum(predprobs > .5)
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
+ `str.replace(a_string, ":", "_")` to replace characters.
+ `' '.join(a_string_array)` to merge an array into one string.

For regular expression:

~~~python
import re
pattern = re.compile('something:(.+)')
mres = pattern.search(line)
mres.group(1)
~~~

### Function

~~~python
def functionname( parameters ):
   "function_docstring"
   function_suite
   return [expression]
~~~


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

To quickly read a manually indexed (e.g. `grep -b`) file quickly, use `seek` to jump to a byte-offset and `tell` to save the current byte-offset.

~~~python
f = open(reads_fn)
f.seek(bos)
line = f.next()
f.close()
~~~

To save python objects one can use `pickle` module:

~~~python
pickle.dump(obj1, open("obj1.pkl","wb"))
obj1 = pickle.load(open("obj1.pkl", "rb"))
~~~

Note the *b* that specifies *binary mode* which is slightly more efficient for non-text files.

## Files structure, packages and imports

There should be a `__init__.py` file **in each directory containing modules** to import. It can be empty. If not the code inside is run on import.

To import the classes/functions defined in file `module1.py`, simply do

~~~python
import module1
~~~

### Install a module locally

For example when running a script on a HPC cluster, it's often easier to install modules in your home.

To initialize the local library I created the directory and updated `PYTHONPATH`.

~~~sh
mkdir -p /home/monlongj/pylib/lib/python2.7/site-packages/
PYTHONPATH=$PYTHONPATH:/home/monlongj/pylib/lib/python2.7/site-packages/
export PYTHONPATH
~~~

Then to install a module (e.g. pyfaidx) I did:

~~~sh
wget https://github.com/mdshw5/pyfaidx/archive/v0.4.7.1.tar.gz
tar -xzvf v0.4.7.1.tar.gz
cd pyfaidx-0.4.7.1/
python setup.py install --prefix=/home/monlongj/pylib
~~~

To use this, I must always have the local library in `PYTHONPATH`.

Modules (as in `module load ...`) might be a cleaner solution. I use existing *module* but I didn't take the time to see how I could create and use them more.

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
parser.add_argument('-in', dest='input', help='the input file', require=True)
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
+ Sub-sample with `random.sample(a_list, 10)`.
+ In a loop, jump to the next iteration with `continue`, or leave the loop with `break`.
+ `quit()` to stop a program.

When filling a nested dictionary, it's painful to always test if the key exists before updating it's value. One trick is to use `try`/`except`. It's not that much quicker but it looks fancier so you forget about the *pain*:

~~~python
try:
    dict[lev1].append(i)
except KeyError:
    dict[lev1] = [i]
~~~

To time a function, one simple way is to use `time.time()` before and after the function and report the difference. There might be issues with Windows but I use timing for internal benchmarks, never in final code.

To convert a **binary number into a decimal number**: `int('11011011', 2)`.

To get the index as well as the value in a list, use `enumerate`:

~~~python
for id, val in enumerate(myList):
	print(id, val)
~~~

## Shell integration

List files with *glob*, remove with *os*, remove non-empty directories with *shutil*.

~~~python
import glob
import os
import shutil

filelist = glob.glob('temp*')
for f in filelist:
    os.remove(f)
	
shutil.rmtree('myDir')
~~~

Run commands with *subprocess*. `/dev/null` to avoid annoying messages.

~~~python
import subprocess

bwa_cmd = ['bwa', 'mem', bwaidx_file, fastq_file]
dump = open('/dev/null')
bwa_out = subprocess.check_output(bwa_cmd, stderr=dump)
dump.close()
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
from Bio.SeqRecord import SeqRecord

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



### SAM files

Here is a short example on how to get reads from a region.

~~~python
import pysam

bamfile = pysam.AlignmentFile(bam_fn, "rb")

reads_reg = bamfile.fetch(reference=ch_reg, start=start_reg, end=end_reg)
reads_seq = {}
for read in reads_reg:
    reads_seq[read.query_name] = read.query_alignment_sequence
~~~

To iterate over all the reads (faster) use:

~~~python
for aln in bamfile.fetch(until_eof=True):
	...
~~~

If the BAM is indexed, the **number of mapped and unmapped reads** is stored in `bamfile.mapped` and `bamfile.unmapped`.
