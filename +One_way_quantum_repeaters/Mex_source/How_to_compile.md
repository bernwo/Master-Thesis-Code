# How to compile the C code into MEX functions?

First, make sure you are in the directory where the `.m`, `.c`, and `.h` files are located. Then, in your MATLAB terminal, run the following script to compile your C code into a MEX function which you can use in Matlab:

```Matlab
codegen <Matlab_function_name> -args {input1,input2,...} <filename.c>
```

## Example

For example, if you want to compile the Matlab function `eL_1Loss_gen` (which is dependent on `eL_1Loss.c`) into a MEX function, the script you should run is:

```Matlab
codegen eL_1Loss_gen -args {double(0),double(0)} eL_0Loss.c
```

## More information

For more information, do take a look at the official Matlab documentation [here](https://www.mathworks.com/help/coder/ug/call-cc-code-from-matlab-code.html).

## Compile using standalone .m files
You can compile a `.m` function into a `mex` function even without `C` code. Simply run in your Matlab:

```Matlab
codegen <Matlab_function_name> -args {input1,input2,...}
```