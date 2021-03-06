/*
* Copyright (c) 2016 Jean-Noel Braun.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/


#ifdef BCNN_USE_CUDA

#include "bcnn/bcnn.h"

__global__ void _bcnn_forward_softmax_layer_kernel(int n, int batch, float *input, float *output)
{
    int i;
    float sum = 0;
    float largest = -INFINITY;
    int b = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    
    if (b >= batch) {
        return;
    }
    
    for (i = 0; i < n; ++i) {
        int val = input[i+b*n];
        largest = (val>largest) ? val : largest;
    }

    for (i = 0; i < n; ++i) {
        sum += exp(input[i+b*n]-largest);
    }

    sum = (sum != 0) ? largest+log(sum) : largest-100;

    for (i = 0; i < n; ++i) {
        output[i+b*n] = exp(input[i+b*n]-sum);
    }
}

int bcnn_forward_softmax_layer_gpu(bcnn_connection *conn)
{
    int src_size = conn->src_tensor.w * conn->src_tensor.h * conn->src_tensor.c;
    int batch_size = conn->dst_tensor.b;
    bcnn_tensor src = conn->src_tensor;
    bcnn_tensor dst = conn->dst_tensor;

    _bcnn_forward_softmax_layer_kernel<<<bcnn_cuda_gridsize(batch_size), BCNN_CUDA_THREADS>>>(src_size,
        batch_size, src.data_gpu, dst.data_gpu);
    bcnn_cuda_check(cudaPeekAtLastError());

    return BCNN_SUCCESS;
}

int bcnn_backward_softmax_layer_gpu(bcnn_connection *conn)
{
    int size = conn->src_tensor.w * conn->src_tensor.h * conn->src_tensor.c
        * conn->dst_tensor.b;
    bcnn_tensor src = conn->src_tensor;
    bcnn_tensor dst = conn->dst_tensor;

    bcnn_cuda_axpy(size, 1, dst.grad_data_gpu, 1, src.grad_data_gpu, 1);

    return BCNN_SUCCESS;
}


#endif