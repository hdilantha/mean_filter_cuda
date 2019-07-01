#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>



void mean_filter_h(int **img, int **res, int N, int M, int k)
{
  int count;
  float temp;
  for(int n = 0; n < N; n++) {
    for(int m = 0; m < M; m++) {
      count = 0;
      temp = 0.0;
      for(int i = N - k; i <= N + k; i++) {
        for(int j = M - k; j <= M + k; j++) {
          if(i >= 0 && i < N && j >= 0 && j < M) {
              count = count + 1;
              temp = res[n][m] + img[i][j];
          }
        }
        temp = temp / count;
        res[n][m] = (int)temp;
      }
    }
  }
}

int main()
{
  const int N = 4;
  const int M = 4;
  int k = 3;

  int *a[N], *b[N];

  for(int i = 0; i < N; i++ ) {
    a[i] = (int *)malloc(M * sizeof(int));
    b[i] = (int *)malloc(M * sizeof(int));
  }

  for(int i = 0; i < N; i++ ) {
    for(int j = 0; j < M; j++ ) {
      a[i][j] = 1;
      b[i][j] = 0;
    }
  }


  //clock_t start_h = clock();
  mean_filter_h(a, b, N, M, k / 2);
  //clock_t end_h = clock();

  //double time_h = (double)(end_h-start_h)/CLOCKS_PER_SEC;
  //printf("CPU Time: %f\n", time_h);

  for(int i = 0; i < N; i++ ) {
    for(int j = 0; j < M; j++ ) {
      printf("%d ", b[i][j]);
    }
  }

  return 0;
}
