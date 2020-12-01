# Overview
This repository runs the following pipecleaner designs through a digital physical design flow using Design Compiler and Innovus with the SkyWater open source 130nm PDK.
*  GcdUnit - computes the greatest common divisor function, consists of 100-200 gates
*  SramWrapper - uses an OpenRAM generated SRAM (to be added soon)

# Setup
To run this flow, please install the following dependencies first:

* `skywater-pdk` 

Get SkyWater PDK:
```
git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk
```
The cell libraries are in submodules that need to be checked out independently:
```
git submodule update --init libraries/sky130_fd_sc_hd/latest
```
To create liberty files, go into the `skywater-pdk` directory and do:
```
make timing
```

* `mflowgen` - This is a tool to create ASIC design flows in a modular fashion.
Follow the setup steps at https://github.com/mflowgen/mflowgen.

* `skywater-130nm-adk` - This repo has some scripts that convert the SkyWater PDK into the format that mflowgen expects.

# Using the Pipecleaners

First, make sure you update various install paths the `setup.bashrc` file. Then source it.

Next, enter into the build directory of the pipecleaner you want to run, and run the following:

`$MFLOWGEN_HOME/configure --design ../design/`

# Helpful make Targets
*  `make list` - list all the nodes in the graphs and their corresponding step number
*  `make status` - list the build status of all the steps
*  `make graph` - generates a PDF of the graph
*  `make N` - runs step N
*  `make clean-N` - removes the folder for step N, and sets the status of steps [N,) to build
*  `make clean-all` - removes folders for all the steps
*  `make runtimes` - lists the runtime for each step
