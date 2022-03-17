# Master-Thesis-Code
Matlab code used to generate results used in my **Master Thesis** that I wrote in 2022 while in TU Delft.

* *Tested on MATLAB R2021b on a Windows 11 64bit machine.*

## Which file to run?
To reproduce the results from my thesis, simply clone the repository run:

* `main_FT.m` for parallel scheduling of the hybrid repeater architecture.
* `main_NFT.m` for sequential scheduling of the hybrid repeater architecture.
* `main_NOCONCAT.m` for homogeneous repeater architecture.

## Important note
Some functions are compiled using the Matlab command [`codegen`](https://www.mathworks.com/help/coder/ref/codegen.html) in Windows. You can distinguish them by their file extension: `.mexw64`. Unfortunately, `.mexw64` functions can only be accessed in a Windows machine. If you are running Linux or Mac, attempts to use `.mexw64` functions will throw errors, thus you need to recompile them.

