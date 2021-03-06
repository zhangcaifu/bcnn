# bcnn

[![Build Status](https://travis-ci.org/jnbraun/bcnn.svg?branch=master)](https://travis-ci.org/jnbraun/bcnn/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

#### ***  Contributors are welcomed ! ***

bcnn (Bare CNN) is a minimalist implementation of Convolutional Neural Networks in plain C and Cuda.

It is aimed to be easy to build with a very limited number of dependencies (standalone if only used on CPU) and designed with 'hackability' in mind.

At the current state, it can run on CPU and Nvidia's GPU. CuDNN versions >= 5 (up to 7) are supported.

## Dependencies:
### Minimal build (CPU with or without SSE2 acceleration):
No external dependency (only requires bip (image processing library) and bh (helpers library) already included).

### GPU build: 
Requires CUDA libraries (cudart, cublas, curand) and a GPU with compute capability 2.0 at least. CuDNN is optional but supported.

## Build:
Download or clone the repository:
```
git clone --recursive https://github.com/jnbraun/bcnn.git
```

### Linux:
* CMake build:
```
mkdir build
cd build/
cmake ../
cmake --build ./
```

* Provided Makefile: 
```
make
```
You may want to edit the following lines of the Makefile at your convenience:
```
CUDA=1
CUDNN=0
DEBUG=0
USE_SSE2=1
CUDA_PATH=/usr/local/cuda
ARCH= --gpu-architecture=compute_50 --gpu-code=compute_50
```

### Windows:
Use cmake to generate the project (choose x64 configuration if using CUDA lib), then build the solution.
Tested with msvc2010 and msvc2013 only.

## Features:

* Currently implemented layers: 
	- Convolution
	- Transposed convolution (aka Deconvolution)
	- Depthwise separable convolution
	- Fully-connected
	- Activation functions: relu, tanh, abs, ramp, softplus, leaky-relu, clamp.
	- Softmax
	- Max-pooling
	- Dropout
	- Batch normalization
* Learning algorithms: SGD, Adam.
* Online data augmentation (crop, rotation, distortion, flip)

## How to use it:

* Use the command line tool bcnn-cl with configuration file: see an example [here](https://github.com/jnbraun/bcnn/tree/master/examples/mnist_cl).

* Or use the static library and write your own code: see an example [there](https://github.com/jnbraun/bcnn/tree/master/examples/mnist).

## License:

Released under MIT license.
