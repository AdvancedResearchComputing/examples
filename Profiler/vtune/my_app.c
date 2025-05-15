// my_app.c: Simple matrix multiplication
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 512

int main() {
    static float A[N][N], B[N][N], C[N][N];
    int i, j, k;

    // Initialize matrices A and B with random values
    srand(time(NULL));
    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++) {
            A[i][j] = rand() % 100;
            B[i][j] = rand() % 100;
        }

    // Multiply A and B to get C
    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++) {
            C[i][j] = 0;
            for (k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];
        }

    // Print one element to prevent compiler optimization
    printf("C[100][100] = %.2f\n", C[100][100]);
    return 0;
}
