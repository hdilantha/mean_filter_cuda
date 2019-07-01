#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <cuda.h>

int *a, *b;  // host data
int *c, *c2;  // results

__global__ void vecAdd(int *A, int *B, int *C, int N)
{
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  C[tid] = A[tid] + B[tid];
}

void vecAdd_h(int *A1, int *B1, int *C1, int N)
{
  for(int i = 0; i < N; i++)
    C1[i] = A1[i] * B1[i];
}

int main(int argc, char **argv)
{
  // printf("Begin \n");
  int v_sizes [4] = {100, 10000, 1000000, 10000000};

  for(int j = 0; j < 4; j++) {
    int n = v_sizes[j];
    int nBytes = n * sizeof(int);
    int block_size, block_no;
    a = (int *)malloc(nBytes);
    b = (int *)malloc(nBytes);
    c = (int *)malloc(nBytes);
    c2 = (int *)malloc(nBytes);
    int *a_d, *b_d, *c_d;
    block_size = 100;
    block_no = n / block_size;
    dim3 dimBlock(block_size, 1, 1);
    dim3 dimGrid(block_no, 1, 1);

    for(int i = 0; i < n; i++ ) {
      a[i] = sin(i) * sin(i);
      b[i] = cos(i) * cos(i);
    }

    // printf("Allocating device memory on device..\n");
    cudaMalloc((void **)&a_d, n * sizeof(int));
    cudaMalloc((void **)&b_d, n * sizeof(int));
    cudaMalloc((void **)&c_d, n * sizeof(int));

    // printf("Copying to device..\n");
    cudaMemcpy(a_d, a, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b, nBytes, cudaMemcpyHostToDevice);

    // printf("Doing GPU Vector add..\n");
    clock_t start_d = clock();
    vecAdd<<<block_no, block_size>>>(a_d, b_d, c_d, n);
    cudaDeviceSynchronize();
    clock_t end_d = clock();

    // printf("Doing CPU Vector add..\n");
    clock_t start_h = clock();
    vecAdd_h(a, b, c2, n);
    clock_t end_h = clock();

    double time_d = (double)(end_d-start_d)/CLOCKS_PER_SEC;
    double time_h = (double)(end_h-start_h)/CLOCKS_PER_SEC;
    cudaMemcpy(c, c_d, nBytes, cudaMemcpyDeviceToHost);

    printf("Number of elements: %d, GPU Time: %f, CPU Time: %f\n", n, time_d, time_h);
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
  }

  return 0;
}
