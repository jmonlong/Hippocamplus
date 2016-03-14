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

The more fancy way is to use `argparse`. The [doc](https://docs.python.org/2/library/argparse.html) gives this example:

~~~python
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                   help='an integer for the accumulator')
parser.add_argument('--sum', dest='accumulate', action='store_const',
                   const=sum, default=max,
                   help='sum the integers (default: find the max)')

args = parser.parse_args()
print args.accumulate(args.integers)
~~~
