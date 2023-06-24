# A Penrose tiling

This project generates a SVG file with a *Penrose tiling* (an aperiodic tiling of the plane with two tiles), using the [cairo-fortran](https://github.com/vmagnin/cairo-fortran) bindings as a fpm (Fortran Package Manager) dependency.

The algorithm uses acute and obtuse golden triangles, with two interlaced recursive procedures. See the figures in https://fr.wikipedia.org/wiki/Pavage_de_Penrose to understand.

See the project https://github.com/vmagnin/hat_polykite for more information on the *ein Stein* problem and the tiling of the plane, and the most recent results in this domain.

![A Penrose tiling](penrose_tiling_10.svg)

Be careful with the number of recursions: the SVG file is growing like the Fibonacci sequence! 12 recursions will generate a 12.7 Mio SVG file. 15 recursions will give a 228 Mio file and your SVG viewer may freeze or crash...

## Requirements and dependencies

You need:

* a modern Fortran compiler, for example GFortran or the Intel ifort/ifx compilers. See the [Fortran-lang.org compilers page](https://fortran-lang.org/compilers/) for other compilers.
* The Cairo development files (`libcairo2-dev` package in Ubuntu).
* The Fortran Package Manager [fpm](https://fpm.fortran-lang.org/).

## Running the program

Just type `fpm run` and fpm will manage the dependencies and build and run the program:

```bash
$ fpm run
 + mkdir -p build/dependencies
Initialized empty Git repository in penrose_tiling/build/dependencies/cairo-fortran/.git/
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 23 (delta 0), reused 14 (delta 0), pack-reused 0
Unpacking objects: 100% (23/23), 82.99 KiB | 1.51 MiB/s, done.
From https://github.com/vmagnin/cairo-fortran
 * branch            HEAD       -> FETCH_HEAD
cairo-enums.f90                        done.
cairo-auto.f90                         done.
triangles.f90                          done.
libpenrose_tiling.a                    done.
main.f90                               done.
penrose_tiling                         done.
[100%] Project compiled successfully.
 ----------------------------------
           8 recursions
 These are Fibonacci numbers:
         610 blue acute triangles
         377 yellow obtuse triangles
 ----------------------------------
 Output file: penrose_tiling.svg
 ----------------------------------
```


## Licenses

This project is licensed under the [GNU General Public License version 3 or later](http://www.gnu.org/licenses/gpl.html).

The documentation is under the [GNU Free Documentation License 1.3 or any later version](http://www.gnu.org/licenses/fdl.html). The figures are under [CC-BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.

## Cairo documentation

* https://cairographics.org/documentation/
* API Reference Manual: https://cairographics.org/manual/

## Bibliography

* Roger Penrose, Set of tiles for covering a surface, Patent GB1548164A ([US-4133152-A](https://patents.google.com/patent/US4133152A/en)), filed 1975-06-25.
* Hargittai, Istvan, et Balazs Hargittai. « 2020 Physics Nobel Laureate Roger Penrose and the Penrose Pattern as a Forerunner of Generalized Crystallography ». *Structural Chemistry* 32, no.1 (1st February 2021): 1‑7. https://doi.org/10.1007/s11224-020-01669-8
* https://en.wikipedia.org/wiki/Einstein_problem
* https://en.wikipedia.org/wiki/Penrose_tiling
* https://fr.wikipedia.org/wiki/Pavage_de_Penrose
* https://en.wikipedia.org/wiki/Golden_ratio
* https://en.wikipedia.org/wiki/Golden_triangle_(mathematics)