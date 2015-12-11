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

```python
import class1
```
