# fast month boundary

we present a fresh take on a very old and ubiqutous problem: it is very inefficient to represent dates of Gregorian calendar in computer memory in a way most humans are accustomed to perceive them. for instance, there is galaxy of ways to write down `February 1st, 1981` in some human-readable format, e.g. `020181`, `1981-02-01` or "1-e февраля 1981 года н.э." but none of them are good for a computer to store and perform efficient arithmetic on them. for that reason, computers usually do it differently.

## epoch date

let `ymd()` be a function which accepts an arbitrary triple (year, month, day) which represents a valid Gregorian date, and returns a unique signed integer which represents the number of days prior to or after some chosen fixed point in time, known as _epoch_. for example:

```с
int ymd(int y,int m,int d){return y-=2001,m=12*y+m+9,m/12*1461/4+mb(m%12)-307+d;}
```

in this C implementation, `ymd(2001,1,1)` yields `0`, which means January 1st, 2001 must be the _epoch_. contrary to another, much more famous epoch date chosen as the beginning of _Aerae vulgaris_, or just CE, we chose this particular epoch date for a more practical and literally more down-to-earth reason: Jan 1st 2001 was a `Monday`.

many great texts have been written on this and related algorighms, and any such [text](https://howardhinnant.github.io/date_algorithms.html) usually begins with elucidation of why it happens to be more convenient to "begin" a Gregorian year in March. if the reason for this oddity isn't immediately apparent, it helps to revisit the idea of _leap years_, which is a fundamental feature of Gregorian system which makes it remarkably accurate while keeping it sufficiently simple for humans.

however, efficient translation of relative epoch offsets back and forth to human-readable format is not at all a trivial task. we observe a critical moving part of `ymd()` implementation, which is the `mb()` routine, or _month boundary_, which we define as follows:

> a map of month indices `0..11` where `0` represents `March`, to the number of days elapsed since 1st of March up to the 1st day of a given month, which results in the following static sequence for _any_ given year, be it a leap year or not:

```
0 31 61 92 122 153 184 214 245 275 306 337
```

make no mistake, these conversions are taking place countless times per second all over the planet Earth, all day, every day, and since these conversions require computation, they require time and energy. luckily enough, one might say, at least implementation of `mb()` seems cheap and trivial enough.  

## some mb() implementations

the code in this repository implements a simple linear benchmark of two different implementations of `mb()` in plain ISO C:

 1. a trivial constant lookup table (LUT) solution.
 2. a less naive technique offered by the regents of kparc.

```
$ cd mb && make

Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: arm64-apple-darwin23.3.0

month boundary benchmark (kpc):

arena 3072 mb, 1 laps:
2008-2-24 61 2610
2059-11-9 337 21496
2045-3-27 92 16156
...
checksum: 1225299026794 wall time: 0.095106s

month boundary benchmark (lut):

arena 3072 mb, 1 laps:
2008-2-24 61 2610
2059-11-9 337 21496
2045-3-27 92 16156
...
checksum: 1225299026794 wall time: 0.152713s
```

please let us know if you are aware of prior art of the latter techique, or a better one.


copyright (c) 2020-2024 regents of kparc, MIT license

_in memoriam of aab._

`/:~`
