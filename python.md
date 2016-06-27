---
layout: pagetoc
title: Python
---

Some notes on my recent attempt to learn Python.

## Naming and formatting

+ Use lowercase `_`-separated for modules and functions name. E.g. `my_function`.
+ Use CapsWord for classes. E.g. `MyClass`.
+ Use `_` prefix for private variable. E.g. `_secret_variable`.

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
parser.add_argument('-in', dest=input', help='the input file')
parser.add_argument('-k', dest='k', default=3, type=int, help='an integer')
parser.add_argument('-out', dest='output', help='the output file')

args = parser.parse_args()
print args.input
print args.k
print args.output
~~~
