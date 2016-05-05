# Unitless

Unitless is a lightweight alternative to the various unit libraries that
create quantities with units (hence the name).  Instead, it provides a
system for doing unit conversions which is easy-to-use and readable.  The
system is written in cython so that it can be used in high-speed numerical
codes without any loss of speed, yet still available in python scripts and the
interpreter.  Usability is important so that Unitless can be used for both
numerical codes and the analysis of their outputs.

## Usage

It is in an early stage of development, but the intended functionality looks
something like:

```python
import unitless
u = unitless.Unit_System('CGS')
print u.meters_per_second
print u.exajoules_per_gigayear
print u.pounds_per_centimeter_second2
```
