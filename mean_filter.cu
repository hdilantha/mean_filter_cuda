#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <cuda.h>

// int *a, *b;  // host data


__global__ void mean_filter(int *A, int *B, int *C, int N)
{
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  C[tid] = A[tid] + B[tid];
}

void mean_filter_h(int *img, int *res, int N, int M, int k)
{
  for(int n = 0; n < N; n++) {
    for(int m = 0; m < M; m++) {
      for(int i = N - k; i <= N + k; i++) {
        for(int j = M - k; j <= M + k; j++) {
          if(img[i][j]) {
              res[n][m] = res[n][m] + img[i][j];
          }
        }
      }
    }
  }
}

int main(int argc, char **argv)
{
  // printf("Begin \n");
  const int N = 4;
  const int M = 4;
  int k = 3;

  int a[N][M] = {
    {0, 1, 2, 3},
    {4, 5, 6, 7},
    {8, 9, 10, 11},
    {12, 13, 14, 15}
  };

  int b[N][M] = {
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0}
  };
  // b = (int *)malloc(nBytes);

  // int *a_d, *b_d, *c_d;
  // block_size = 100;
  // block_no = n / block_size;

  // printf("Allocating device memory on device..\n");
  // cudaMalloc((void **)&a_d, n * sizeof(int));
  // cudaMalloc((void **)&b_d, n * sizeof(int));
  // cudaMalloc((void **)&c_d, n * sizeof(int));

  // printf("Copying to device..\n");
  // cudaMemcpy(a_d, a, nBytes, cudaMemcpyHostToDevice);
  // cudaMemcpy(b_d, b, nBytes, cudaMemcpyHostToDevice);

  // printf("Doing GPU Vector add..\n");
  // clock_t start_d = clock();
  // vecAdd<<<block_no, block_size>>>(a_d, b_d, c_d, n);
  // cudaDeviceSynchronize();
  // clock_t end_d = clock();

  // printf("Doing CPU Vector add..\n");
  clock_t start_h = clock();
  mean_filter_h((int *)a, (int *)b, N, M, k / 2);
  clock_t end_h = clock();

  // double time_d = (double)(end_d-start_d)/CLOCKS_PER_SEC;
  double time_h = (double)(end_h-start_h)/CLOCKS_PER_SEC;
  // cudaMemcpy(c, c_d, nBytes, cudaMemcpyDeviceToHost);

  printf("CPU Time: %f\n", time_h);
  // printf("Number of elements: %d, GPU Time: %f, CPU Time: %f\n", n, time_d, time_h);
  // cudaFree(a_d);
  // cudaFree(b_d);
  // cudaFree(c_d);

  for(int i = 0; i < N; i++ ) {
    for(int j = 0; j < M; j++ ) {
      printf("CPU Time: %f\n", b[i][j]);
    }
  }

  return 0;
}
